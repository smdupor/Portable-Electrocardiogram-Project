/*FILE: mcu_sysfunctions.h
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * Purpose: Header file for microcontroller system functions. Specifies four functions
 *  to be implemented in mcu_sysfunctions.c
 */

//initialisation function
void initMCU(void);
//function to make the microcontroller wait for 10^-5 seconds based on int argument
void waitMCU (int) ;

//prints to the LCD to indicate heartbeat data
void printLCD(int, int);

//prints welcome screen on the LCD at system startup
void printWelcomeScreen(void);
