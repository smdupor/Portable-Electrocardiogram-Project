/*FILE: mcu_sysfunctions.c
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * Purpose: Contains the code for microcontroller system functions including initialisation,
 * printing to the LCD, and system-waits. 
 */

#include <stdio.h>

/*FUNCTION: printWelcomeScreen()
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: None
 * PARAMETERS:None
 * PURPOSE: Print the welcome screen on the system LCD when the system starts up.
 */
void printWelcomeScreen(void)
{
	FILE *lcd;
	lcd = fopen("/dev/lcd_display", "w");

	fprintf(lcd, "ECG System\n");
	fprintf(lcd, "A Dupor-Gadfort-Lang Production\n");

	fclose(lcd);
}

/*FUNCTION: initMCU()
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: None
 * PARAMETERS: None
 * PURPOSE: Prints the welcome screen. FUTURE IMPLEMENTATION: Contains more parallel IO setup,
 * compact flash setup.
 */
void initMCU()
{
	printWelcomeScreen();
}

/*FUNCTION: waitMCU(int wait)
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: None
 * PARAMETERS: int wait is the number of tens of microseconds that the microcontroller waits.
 * PURPOSE: Causes the microcontroller to enter a wait state for a specified number of 
 * tens of microseconds, i.e. passing an "int wait" value of 5 would cause the system to wait for 
 * 50 microseconds.
 */
void waitMCU(int wait)
{
	int i, j;
	wait=wait*5;
	for (i = 0; i < wait; i++)
	{
		j=i+1;
	};
}

/*FUNCTION: printLCD(int bpm, int FS)
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * PRECONDITIONS: System is running and reading data actively
 * PARAMETERS: int bpm indicates the beats per minute to be printed to the LCD
 * 				int FS indicates the system sampling frequency
 * PURPOSE:	Function updates the LCD with basic patient vitality information: heart rate and
 * whether the heart rate is low, normal, high, or very high. 
 */
void printLCD(int bpm, int FS)
{
	unsigned int rate;

	FILE *lcd;
	lcd = fopen("/dev/lcd_display", "w");

	rate = (int)(60*(FS/((double)bpm)));
	fprintf(lcd, "Heart Rate: %u\n", rate);
	//fprintf(stderr,"Heart Rate: %d: %u\n",bpm, rate);
	if (rate>150)
	{
		fprintf(lcd, "Very High\n");
	} else if (rate>100)
	{
		fprintf(lcd, "High\n");
	} else if (rate>50)
	{
		fprintf(lcd, "Normal\n");
	} else
	{
		fprintf(lcd, "Low\n");
	}

	fclose(lcd);
	return;
}

