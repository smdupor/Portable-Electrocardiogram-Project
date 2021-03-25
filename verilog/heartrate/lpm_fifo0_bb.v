// megafunction wizard: %LPM_FIFO+%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: scfifo 

// ============================================================
// File Name: lpm_fifo0.v
// Megafunction Name(s):
// 			scfifo
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 6.0 Build 202 06/20/2006 SP 1 SJ Full Version
// ************************************************************

//Copyright (C) 1991-2006 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

module lpm_fifo0 (
	clock,
	data,
	rdreq,
	sclr,
	wrreq,
	full,
	q);

	input	  clock;
	input	[0:0]  data;
	input	  rdreq;
	input	  sclr;
	input	  wrreq;
	output	  full;
	output	[0:0]  q;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AlmostEmpty NUMERIC "0"
// Retrieval info: PRIVATE: AlmostEmptyThr NUMERIC "-1"
// Retrieval info: PRIVATE: AlmostFull NUMERIC "0"
// Retrieval info: PRIVATE: AlmostFullThr NUMERIC "-1"
// Retrieval info: PRIVATE: CLOCKS_ARE_SYNCHRONIZED NUMERIC "0"
// Retrieval info: PRIVATE: Clock NUMERIC "0"
// Retrieval info: PRIVATE: Depth NUMERIC "8192"
// Retrieval info: PRIVATE: Empty NUMERIC "0"
// Retrieval info: PRIVATE: Full NUMERIC "1"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix"
// Retrieval info: PRIVATE: LE_BasedFIFO NUMERIC "0"
// Retrieval info: PRIVATE: LegacyRREQ NUMERIC "0"
// Retrieval info: PRIVATE: MAX_DEPTH_BY_9 NUMERIC "0"
// Retrieval info: PRIVATE: OVERFLOW_CHECKING NUMERIC "0"
// Retrieval info: PRIVATE: Optimize NUMERIC "2"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
// Retrieval info: PRIVATE: UNDERFLOW_CHECKING NUMERIC "0"
// Retrieval info: PRIVATE: UsedW NUMERIC "0"
// Retrieval info: PRIVATE: Width NUMERIC "1"
// Retrieval info: PRIVATE: dc_aclr NUMERIC "0"
// Retrieval info: PRIVATE: rsEmpty NUMERIC "1"
// Retrieval info: PRIVATE: rsFull NUMERIC "0"
// Retrieval info: PRIVATE: rsUsedW NUMERIC "0"
// Retrieval info: PRIVATE: sc_aclr NUMERIC "0"
// Retrieval info: PRIVATE: sc_sclr NUMERIC "1"
// Retrieval info: PRIVATE: wsEmpty NUMERIC "0"
// Retrieval info: PRIVATE: wsFull NUMERIC "1"
// Retrieval info: PRIVATE: wsUsedW NUMERIC "0"
// Retrieval info: CONSTANT: ADD_RAM_OUTPUT_REGISTER STRING "OFF"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix"
// Retrieval info: CONSTANT: LPM_NUMWORDS NUMERIC "8192"
// Retrieval info: CONSTANT: LPM_SHOWAHEAD STRING "ON"
// Retrieval info: CONSTANT: LPM_TYPE STRING "scfifo"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "1"
// Retrieval info: CONSTANT: LPM_WIDTHU NUMERIC "13"
// Retrieval info: CONSTANT: OVERFLOW_CHECKING STRING "ON"
// Retrieval info: CONSTANT: UNDERFLOW_CHECKING STRING "ON"
// Retrieval info: CONSTANT: USE_EAB STRING "ON"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
// Retrieval info: USED_PORT: data 0 0 1 0 INPUT NODEFVAL data[0..0]
// Retrieval info: USED_PORT: full 0 0 0 0 OUTPUT NODEFVAL full
// Retrieval info: USED_PORT: q 0 0 1 0 OUTPUT NODEFVAL q[0..0]
// Retrieval info: USED_PORT: rdreq 0 0 0 0 INPUT NODEFVAL rdreq
// Retrieval info: USED_PORT: sclr 0 0 0 0 INPUT NODEFVAL sclr
// Retrieval info: USED_PORT: wrreq 0 0 0 0 INPUT NODEFVAL wrreq
// Retrieval info: CONNECT: @data 0 0 1 0 data 0 0 1 0
// Retrieval info: CONNECT: q 0 0 1 0 @q 0 0 1 0
// Retrieval info: CONNECT: @wrreq 0 0 0 0 wrreq 0 0 0 0
// Retrieval info: CONNECT: @rdreq 0 0 0 0 rdreq 0 0 0 0
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: full 0 0 0 0 @full 0 0 0 0
// Retrieval info: CONNECT: @sclr 0 0 0 0 sclr 0 0 0 0
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0.bsf TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0_bb.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0_waveforms.html TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_fifo0_wave*.jpg TRUE
