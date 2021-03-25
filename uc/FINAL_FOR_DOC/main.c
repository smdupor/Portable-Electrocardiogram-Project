/*FILE: main.c
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * Purpose: Contains the code for starting up and running the top-level and 
 * communication functions of the NIOSII microcontroller.
 */
#include "main.h"
#include "alt_types.h"
#include <stdio.h>
#include "system.h"
#include "altera_avalon_timer_regs.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_dma.h"
#include "mcu_sysfunctions.h"
#include "mcu_definitions.h"

//global variables section------------------------------------------------------------- 
int sendLength; 						//Length of a datablock packet to be sent via RS232
volatile unsigned int buf[BUFFERSIZE]; 	/*software circular buffer in which datapoints 
										 *of ECG are stored*/
struct beatIndicesSTR beatIndices; 		/*structure to store indices of the read and 
										 *write points of circular buffer*/
char timestamp; 						//used to indicate the timestamp of ONE heartbeat

//mcu functions section-----------------------------------------------------------------

/*FUNCTION: getDataFromHardware(int)
 * PARAMETER: int k--indicates number of data samples to read from parallel IO at 1kHz
 * PRECONDITION: initMCU() has been executed
 * PURPOSE: To read data samples from digital hardware through parallel IO and store them
 * in the software buffer, buf[].
 */
void getDataFromHardware(int k)
{
	int i;
	int max = 0;
	for (i = 0; i < k; i++)
	{
		buf[beatIndices.dataWriteStart++] = IORD_16DIRECT(ADDRESS_PIO_HW_DATA,
		        0);

		if (beatIndices.dataWriteStart == BUFFERSIZE)
			beatIndices.dataWriteStart = 0;
		if (buf[beatIndices.dataWriteStart-1]>max)
			max=buf[beatIndices.dataWriteStart-1];

		waitMCU(133);
	}

	if (k == BUFFERSIZE)
	{
		BEAT_THRESHOLD = (max - 0x8000)*0.75 + 0x8000;
		FILE *lcd;
		lcd = fopen("/dev/lcd_display", "w");
		fprintf(lcd, "BEAT_THRESHOLD = %04x\n", BEAT_THRESHOLD);
		fclose(lcd);
	}

}

/*FUNCTION: findBeats(void)
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: getDataFromHardware(int) has been executed
 * PARAMETERS: None.
 * PURPOSE: Algorithm implementation to isolate one heartbeat using the rising and falling
 * edges of the first three heartbeats in the buffer.
 */
void findBeats(void)
{
	int i, k;
	int locs[5];
	enum BEAT_STATE bstate = RISINGEDGEFIRST;
	i=beatIndices.beatEnd; //set i to location of last beat.
	k=1;

	for (i = beatIndices.beatEnd+1; i != beatIndices.beatEnd; i++)
	{
		if (i == BUFFERSIZE)
			i = 0;

		switch (bstate)
		{
		case RISINGEDGEFIRST:	//find rising edge of the first R wave
			if (buf[i]>BEAT_THRESHOLD+NOISEGUARD)
			{
				locs[0]=i;
				bstate=FALLINGEDGEFIRST;
			}
			break;
		case FALLINGEDGEFIRST://find falling edge of the first R wave
			if (buf[i]<BEAT_THRESHOLD-NOISEGUARD)
			{
				locs[1]=i;
				bstate=RISINGEDGESECOND;
			}
			break;
		case RISINGEDGESECOND://find rising edge of the second R wave
			if (buf[i]>BEAT_THRESHOLD+NOISEGUARD)
			{
				locs[2]=i;
				bstate=FALLINGEDGESECOND;
			}
			break;
		case FALLINGEDGESECOND://find falling edge of the second R wave
			if (buf[i]<BEAT_THRESHOLD-NOISEGUARD)
			{
				locs[3]=i;
				bstate=RISINGEDGETHIRD;
			}
			break;
		case RISINGEDGETHIRD:	//find rising edge of the third R wave
			if (buf[i]>BEAT_THRESHOLD+NOISEGUARD)
			{
				locs[4]=i;
				beatIndices.beatStart=((locs[2]-locs[1])/2)+locs[1];
				beatIndices.beatEnd=((locs[4]-locs[3])/2)+locs[3];
				return;
			}
			break;
		}
	}

	FILE *lcd;
	lcd = fopen("/dev/lcd_display", "w");
	fprintf(lcd, "NO BEATS FOUND\n");	//debug output to the LCD
	fclose(lcd);
	return;
}

/*FUNCTION: convert(int)
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: None.
 * PARAMETERS: int in--the integer to be converted to a character value
 * RETURNS: character value of the integer
 * PURPOSE: Function created to move from the printf("04x",char) functionality due to problems
 * with the printf functionality. Function takes an integer from 0 to 15 and converts it to 
 * the ASCII representation in character form. IE inputting a 1 would return a '1', inputting a 
 * 12 would return a 'c'
 */
char convert(int in)
{
	if (in >= 0 && in <= 9)
		return (char)(in + '0');
	else if (in >= 10 && in <= 16)
		return (char)((in - 10) + 'a');

	return 0;
}

/*FUNCTION: communicateData(enum)
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: findBeats() has been executed, getDataFromHardware() has been executed.
 * 				stdout and stdin have been configured to point to UART1 on the FPGA.
 * PARAMETERS:enum COMM_STATE state is a state control variable that is passed into the function 
 * to ensure that the communications state machine starts in the correct state as dictated by 
 * the main state machine.
 * PURPOSE: Implements the RS232 communication state machine which, as it is called, 
 * communicates data and timestamps of individual heartbeats to the PC through rs232.
 * 
 */
enum COMM_STATE communicateData(enum COMM_STATE state)
{
	char idcode;
	int i; //data_read_index
	unsigned int datablock;
	volatile char ch;

	int masks[] = { 0xf000, 0x0f00, 0x00f0, 0x000f };
	int shifts[] = { 0x1000, 0x0100, 0x0010, 0x0001 };

	idcode = 3;	//idcode currently not implemented, this is a stub.
	beatIndices.dataReadStart=beatIndices.beatStart;
	
	while (1)
	{
		switch (state)
		{
		case DOWN:
			ch = getchar();
			if (ch == STARTCOMMUNICATION)
			{
				printf("%c", ACK);
				ch = getchar();
				if (ch == STARTCOMMREALTIME)
				{
					printf("%c", ACK);
					state = RTTIME;
					break;
				} else if (ch == STARTCOMMSD)
				{
					printf("%c", ACK);
					state = SDDAT;
					break;
				}
			}
			return DOWN;
			break;
		case RTTIME:
			timestamp = timestamp + 1;
			//begin transmitting with timestamp
			printf("%c", TIMESTAMPCTRLCHAR);
			ch = convert((timestamp&0xf0)/0x10);
			printf("%c", ch);
			ch = convert((timestamp&0xf));
			printf("%c", ch);
			fflush(stdout); 	//flush stdout buffers in case of delays
			state = RTID;
			break;
		case RTID:
			ch = convert(idcode);
			printf("%c", ch);
			fflush(stdout);
			state = RTDAT;
			if (beatIndices.beatEnd - beatIndices.dataReadStart < 0)
				sendLength = beatIndices.beatEnd - beatIndices.dataReadStart
				        + BUFFERSIZE;
			else
				sendLength = beatIndices.beatEnd - beatIndices.dataReadStart;
			break;
		case RTDAT:
			if (beatIndices.dataReadStart == beatIndices.beatEnd)
			{
				printf("0000");	//indicate packet is done. Ensure there are no
								//datapoints of -2.5V, 0x0000
				return DOWN;
			} else
			{
				datablock = buf[beatIndices.dataReadStart++];
				if (beatIndices.dataReadStart == BUFFERSIZE)
					beatIndices.dataReadStart = 0;
				for (i = 0; i < 4; i++)
				{
					ch = convert((datablock&masks[i])/shifts[i]);
					printf("%c", ch);
					waitMCU(5);

				}
				fflush(stdout);
			}
			break;
		case RTWAIT:
			printf("w");
			state = RTWAIT_CHECK;
			break;
		case RTWAIT_CHECK:
			ch = getchar();
			if (ch == 's')
				return DOWN;
			state = RTTIME;
			break;
		case SDDAT:
			//Stored data comm currently unsupported. responds with a channel kill signal.
			printf("%c", KILLCOMMUNICATION);
			state = DOWN;
			break;
		case SDEMPTY:
			//Stored data comm currently unsupported. responds with a channel kill signal.
			printf("%c", KILLCOMMUNICATION);
			state = DOWN;
			break;
		case WAIT:
			printf("%c", CTRLCHARWAIT);
			state = RTTIME;
			break;
		default:
			state = DOWN;
		}
	}

	return DOWN;
}

/*FUNCTION: main()
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: None.
 * PARAMETERS: None.
 * PURPOSE: Contains the system state machine at the highest level. Initializes necessary
 * microcontroller resources through initMCU(), reads in a full buffer of data as lead-in
 *  data, then waits for a request for communication with the PC to begin.
 */
int main()
{
	enum MAIN_STATE state = INITIAL;
	enum COMM_STATE txstate = DOWN;

	beatIndices.dataReadStart=0;
	beatIndices.dataWriteStart=0;
	beatIndices.beatStart=0;
	beatIndices.beatEnd=0;
	timestamp = 0;
	sendLength=200;

	initMCU();

	while (1)
	{
		switch (state)
		{
		case INITIAL:	//state only entered once, as an initialisation state.
			waitMCU(400000);	//MUST have 3+ second delay in order for ADC to come online.
			getDataFromHardware(BUFFERSIZE);
			findBeats();
			state = SEND;
			break;
		case READ:		//state to read data from hardware
			getDataFromHardware(sendLength);
			findBeats();
			state = SEND;
			break;
		case SEND:		//state to send data to the PC
			txstate = communicateData(txstate);
			printLCD(sendLength, FS);
			state = READ;
			break;
		default:
			state = READ;
		}
	}
}
