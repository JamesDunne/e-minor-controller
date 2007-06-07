//-----------------------------------------------------------------------------------------------------------------------------
/**
 * @author Ali Rizavi		07/22/2005		Original.
 * @version 1.0,			07/22/2005
 * File Name:
 */
//-----------------------------------------------------------------------------------------------------------------------------
								

//----------------------------- PUBLIC ----------------------------------------------------------------------------------------
void LOAD_SHED_ROUTINE(void);
void LOAD_RAMP_ROUTINE(void);
void CopyFromNVR(void);
void GET_MAX_DELAY_LBC(void);
void START_SHEDDING_LBC(void);
void END_SHEDDING_LBC(void);
void START_RAMPING_LBC(void);
void END_RAMPING_LBC(void);
void RESET_CONTROL_COUNTER_LBC(void);
void START_LBC(void);
void STOP_LBC(void);
void WRITE_TO_RELAYS(void);
void SEND_TO_LATCHES_10(void);
void UpdateLBCCntr(void);
void MinDelayOnLoadCntrlCheck(void);
void SETUP_AUX_OUTLETS_COMMAND(void);
void ProcessLoadControl(void);
void LoadRampDelaysFromNVR(void);
void LoadShedDelaysFromNVR(void);
void ABORT_ALL_LBC(void);
void CHECK_AUTO_RAMP(void);
void CHECK_AUTO_SHED(void);

//----------------------------- DEFINITIONS -----------------------------------------------------------------------------------
#define LRC_REBOOT						0
#define LRC_TURN_ON						1
#define LRC_TURN_OFF					2
#define NUMBER_OF_LOAD_BANKS			3
