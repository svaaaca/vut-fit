/**
 * @file main.h
 * @author David Kvacek (xkvace00@stud.fit.vutbr.cz)
 * @brief Header file for the ARM-FITkit3: Light board.
 * @date 2023-12-15
 */

#ifndef __MAIN_H__
#define __MAIN_H__

unsigned int counter = 0;	// Global loop counter
unsigned int choice = 0;  // Global choice variable

#define GPIO_PIN_MASK 0x1Fu							            // Bit-level register manipulation
#define GPIO_PIN(x) ((1) << ((x) & GPIO_PIN_MASK))	// Bit-level register manipulation

// Letter A
#define CHAR_A0 0b01110000
#define CHAR_A1 0b00101000
#define CHAR_A2 0b00100100
#define CHAR_A3 0b00101000
#define CHAR_A4 0b01110000

// Letter B
#define CHAR_B0 0b01111100
#define CHAR_B1 0b01010100
#define CHAR_B2 0b01010100
#define CHAR_B3 0b01010100
#define CHAR_B4 0b00101000

// Letter C
#define CHAR_C0 0b00111000
#define CHAR_C1 0b01000100
#define CHAR_C2 0b01000100
#define CHAR_C3 0b01000100
#define CHAR_C4 0b01000100

// Letter D
#define CHAR_D0 0b01111100
#define CHAR_D1 0b01000100
#define CHAR_D2 0b01000100
#define CHAR_D3 0b01000100
#define CHAR_D4 0b00111000

// Letter E
#define CHAR_E0 0b01111100
#define CHAR_E1 0b01010100
#define CHAR_E2 0b01010100
#define CHAR_E3 0b01010100
#define CHAR_E4 0b01000100

// Letter F
#define CHAR_F0 0b01111100
#define CHAR_F1 0b00010100
#define CHAR_F2 0b00010100
#define CHAR_F3 0b00010100
#define CHAR_F4 0b00000100

// Letter G
#define CHAR_G0 0b00111000
#define CHAR_G1 0b01000100
#define CHAR_G2 0b01000100
#define CHAR_G3 0b01010100
#define CHAR_G4 0b01110100

// Letter H
#define CHAR_H0 0b01111100
#define CHAR_H1 0b00010000
#define CHAR_H2 0b00010000
#define CHAR_H3 0b00010000
#define CHAR_H4 0b01111100

// Letter I
#define CHAR_I0 0b01000100
#define CHAR_I1 0b01000100
#define CHAR_I2 0b01111100
#define CHAR_I3 0b01000100
#define CHAR_I4 0b01000100

// Letter J
#define CHAR_J0 0b00100100
#define CHAR_J1 0b01000100
#define CHAR_J2 0b01000100
#define CHAR_J3 0b00111100
#define CHAR_J4 0b00000100

// Letter K
#define CHAR_K0 0b01111100
#define CHAR_K1 0b00010000
#define CHAR_K2 0b00010000
#define CHAR_K3 0b00101000
#define CHAR_K4 0b01000100

// Letter L
#define CHAR_L0 0b01111100
#define CHAR_L1 0b01000000
#define CHAR_L2 0b01000000
#define CHAR_L3 0b01000000
#define CHAR_L4 0b01000000

// Letter M
#define CHAR_M0 0b01111100
#define CHAR_M1 0b00001000
#define CHAR_M2 0b00010000
#define CHAR_M3 0b00001000
#define CHAR_M4 0b01111100

// Letter N
#define CHAR_N0 0b01111100
#define CHAR_N1 0b00001000
#define CHAR_N2 0b00010000
#define CHAR_N3 0b00100000
#define CHAR_N4 0b01111100

// Letter O
#define CHAR_O0 0b00111000
#define CHAR_O1 0b01000100
#define CHAR_O2 0b01000100
#define CHAR_O3 0b01000100
#define CHAR_O4 0b00111000

// Letter P
#define CHAR_P0 0b01111100
#define CHAR_P1 0b00010100
#define CHAR_P2 0b00010100
#define CHAR_P3 0b00010100
#define CHAR_P4 0b00001000

// Letter Q
#define CHAR_Q0 0b00111000
#define CHAR_Q1 0b01000100
#define CHAR_Q2 0b01010100
#define CHAR_Q3 0b00101100
#define CHAR_Q4 0b01011000

// Letter R
#define CHAR_R0 0b01111100
#define CHAR_R1 0b00010100
#define CHAR_R2 0b00010100
#define CHAR_R3 0b00010100
#define CHAR_R4 0b01101000

// Letter S
#define CHAR_S0 0b01001000
#define CHAR_S1 0b01010100
#define CHAR_S2 0b01010100
#define CHAR_S3 0b01010100
#define CHAR_S4 0b00100100

// Letter T
#define CHAR_T0 0b00000100
#define CHAR_T1 0b00000100
#define CHAR_T2 0b01111100
#define CHAR_T3 0b00000100
#define CHAR_T4 0b00000100

// Letter U
#define CHAR_U0 0b00111100
#define CHAR_U1 0b01000000
#define CHAR_U2 0b01000000
#define CHAR_U3 0b01000000
#define CHAR_U4 0b00111100

// Letter V
#define CHAR_V0 0b00011100
#define CHAR_V1 0b00100000
#define CHAR_V2 0b01000000
#define CHAR_V3 0b00100000
#define CHAR_V4 0b00011100

// Letter W
#define CHAR_W0 0b01111100
#define CHAR_W1 0b00100000
#define CHAR_W2 0b00010000
#define CHAR_W3 0b00100000
#define CHAR_W4 0b01111100

// Letter X
#define CHAR_X0 0b01000100
#define CHAR_X1 0b00101000
#define CHAR_X2 0b00010000
#define CHAR_X3 0b00101000
#define CHAR_X4 0b01000100

// Letter Y
#define CHAR_Y0 0b00000100
#define CHAR_Y1 0b00001000
#define CHAR_Y2 0b01110000
#define CHAR_Y3 0b00001000
#define CHAR_Y4 0b00000100

// Letter Z
#define CHAR_Z0 0b01000100
#define CHAR_Z1 0b01100100
#define CHAR_Z2 0b01010100
#define CHAR_Z3 0b01001100
#define CHAR_Z4 0b01000100

// Char Dash
#define CHAR_DH 0b00010000

// Char Space
#define CHAR_SP 0b00000000

// Number 0
#define NUM_00 0b00111000
#define NUM_01 0b01100100
#define NUM_02 0b01010100
#define NUM_03 0b01001100
#define NUM_04 0b00111000

// Number 1
#define NUM_10 0b01000100
#define NUM_11 0b01000100
#define NUM_12 0b01111100
#define NUM_13 0b01000000
#define NUM_14 0b01000000

// Number 2
#define NUM_20 0b01100100
#define NUM_21 0b01010100
#define NUM_22 0b01010100
#define NUM_23 0b01010100
#define NUM_24 0b01001000

// Number 3
#define NUM_30 0b01000100
#define NUM_31 0b01000100
#define NUM_32 0b01010100
#define NUM_33 0b01010100
#define NUM_34 0b00101000

// Number 4
#define NUM_40 0b00110000
#define NUM_41 0b00101000
#define NUM_42 0b00100100
#define NUM_43 0b01111100
#define NUM_44 0b00100000

// Number 5
#define NUM_50 0b01011100
#define NUM_51 0b01010100
#define NUM_52 0b01010100
#define NUM_53 0b01010100
#define NUM_54 0b00100100

// Number 6
#define NUM_60 0b00111000
#define NUM_61 0b01010100
#define NUM_62 0b01010100
#define NUM_63 0b01010100
#define NUM_64 0b00100100

// Number 7
#define NUM_70 0b00000100
#define NUM_71 0b01000100
#define NUM_72 0b00100100
#define NUM_73 0b00010100
#define NUM_74 0b00001100

// Number 8
#define NUM_80 0b00101000
#define NUM_81 0b01010100
#define NUM_82 0b01010100
#define NUM_83 0b01010100
#define NUM_84 0b00101000

// Number 9
#define NUM_90 0b01001000
#define NUM_91 0b01010100
#define NUM_92 0b01010100
#define NUM_93 0b01010100
#define NUM_94 0b00111000

/**
 * @brief Initialize the board.
 *
 */
void init(void);

/**
 * @brief Select the column (0-15).
 *
 * @param col_num Column number selector (0-15).
 */
void column_select(unsigned int col_num);

/**
 * @brief Select the row (0-7).
 *
 * @param row_num Row number selector (0-255).
 */
void row_select(unsigned int row_num);

/**
 * @brief PIT0 timer interrupt handler.
 *
 */
void PIT0_IRQHandler(void);

#endif // __MAIN_H__
