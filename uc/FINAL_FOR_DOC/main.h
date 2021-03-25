/*FILE: main.h
 * AUTHOR: Stevan Dupor
 * MODIFIED: 4/24/2008
 * Purpose: Contains code to declare global state variables for the system, communication, and 
 * beat locating state machines. Also contains code to 
 */

//controls states for the communication state machine
enum COMM_STATE
{
  DOWN, //communication is not active
  NEG, //communication is being negotiated
  RTINIT,	//realtime comm is being initialised
  RTTIME, 	//sending a realtime timestampo
  RTID, 	//sending a realtime ID code
  RTDAT, 	//sending realtime datablocks
  RTWAIT,	//delay state during realtime communication
  RTWAIT_CHECK,	//delay state during realtime communication with ACKs
  SDDAT, 		//stored data state, unsupported as of now.
  SDEMPTY, 		//stored data state, unsupported as of now.
  WAIT			//general delay state
};

//control states for the system state machine
enum MAIN_STATE
{
  INITIAL,	//initialisation state, entered only once, at system start-up
  READ,		//state to read data from hardware
  SEND,		//state to send data over rs232
};

//control states for beat locator state machine
enum BEAT_STATE
{
  RISINGEDGEFIRST,	//looking for rising edge of first heartbeat R wave
  FALLINGEDGEFIRST,	//looking for falling edge of first heartbeat R wave
  RISINGEDGESECOND,	//looking for rising edge of second heartbeat R wave
  FALLINGEDGESECOND,	//looking for falling edge of second heartbeat R wave
  RISINGEDGETHIRD 	//looking for rising edge of third heartbeat R wave
};

//structure to hold indices for the circular buffer
struct beatIndicesSTR
{
  int beatStart;	//start of the heartbeat we are interested in based on 
  					//execution of findBeats()
  int beatEnd;		//end of the heartbeat we are interested in based on 
					//execution of findBeats()
  
  int dataReadStart;	//index in circular buffer at which good data begins being read.
  int dataWriteStart;	//index in circular buffer at which data begins being 
  						//written from hardware
};

//function prototypes section-----------------------------------------------------------
void getDataFromHardware(int);	//read data from parallel IO
void findBeats(void);			//isolate one complete heartbeat 
char convert(int);				//convert an int to a char representation, in hexidecimal
enum COMM_STATE communicateData(enum COMM_STATE);	//communications state machine
