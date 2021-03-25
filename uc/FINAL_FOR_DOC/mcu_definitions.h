/*FILE: mcu_definitions.h
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * Purpose: Contains declarations of constants for use throughout the system including 
 * rs232 control characters, memory locations, mathematical constants, and error checking
 * controls.
 */


//rs232 communication control characters------------------------------------------
#define STARTCOMMUNICATION 'a'	//indicates a request to start communication
#define STARTCOMMREALTIME 'b'	//indicates a request for realtime communication
#define STARTCOMMSD 'c'			//indicates a request for stored data communication
#define STARTBLOCKRTDATABLOCK 'g'		//indicates an incoming realtime datablock
#define KILLCOMMUNICATION 'z'			//indicates a communication kill signal
#define TIMESTAMPCTRLCHAR 'h'			//indicates an incoming timestamp
#define CTRLCHARWAIT 'i'				//indicates a request for a system wait/delay in 
										//general wait state
#define ACK 'x'							//acknowledge good data
#define NACK 'y'						//indicate bad data, request retransmit
#define CHARCOMMWAIT 'Z'				//indicates a request for system delay/wait in 
										//realtime wait state
#define CONTINUE 'j'					//allow comm to continue


//system mathematical constants, address locations, and repeat controls--------------
#define BADDATARETRY 5 //number of retries when NACK is received.
#define NOISEGUARD 0x0125	//guard band for noise, used in findBeats
#define ADDRESS_PIO_HW_DATA 0x00800880  //Input port to get data from, 16bit wide
#define ADDRESS_UART_BASE 0x00800820	//Physical address of UART1 in the FPGA
#define BUFFERSIZE 3000					//size of the circular buffer
#define FS 500							//sampling frequency

int BEAT_THRESHOLD; 	//dynamic threshold under which we consider this an "R" wave
