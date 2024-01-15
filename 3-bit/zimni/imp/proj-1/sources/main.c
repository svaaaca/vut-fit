/**
 * @file main.c
 * @author David Kvacek (xkvace00@stud.fit.vutbr.cz)
 * @brief Source file for the ARM-FITkit3: Light board.
 * @date 2023-12-15
 */

#include "MK60DZ10.h"
#include "main.h"

/**
 * Inspired by Ing. Vaclav Simek: Sample project to test the equipment [quoted 2023-12-04]
 * Available from: https://www.fit.vutbr.cz/~simekv/IMP_projekt_had_tabule_test.zip
 */
void init() {
	SIM->SCGC5 |= SIM_SCGC5_PORTA_MASK;	// Turn on all port clocks
	SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;	// Turn on PIT clock

	// Set corresponding PTA pins (column activators of 74HC154) for GPIO functionality
	PORTA->PCR[8] = (0 | PORT_PCR_MUX(0x01));  	// A0 (LSB)
	PORTA->PCR[10] = (0 | PORT_PCR_MUX(0x01));	// A1
	PORTA->PCR[6] = (0 | PORT_PCR_MUX(0x01));  	// A2
	PORTA->PCR[11] = (0 | PORT_PCR_MUX(0x01)); 	// A3 (MSB)

	// Set corresponding PTA pins (rows selectors of 74HC154) for GPIO functionality
	PORTA->PCR[26] = (0 | PORT_PCR_MUX(0x01));	// R0 (LSB)
	PORTA->PCR[24] = (0 | PORT_PCR_MUX(0x01));  // R1
	PORTA->PCR[9] = (0 | PORT_PCR_MUX(0x01));   // R2
	PORTA->PCR[25] = (0 | PORT_PCR_MUX(0x01));  // R3
	PORTA->PCR[28] = (0 | PORT_PCR_MUX(0x01));  // R4
	PORTA->PCR[7] = (0 | PORT_PCR_MUX(0x01));   // R5
	PORTA->PCR[27] = (0 | PORT_PCR_MUX(0x01));  // R6
	PORTA->PCR[29] = (0 | PORT_PCR_MUX(0x01));  // R7 (MSB)

	PTA->PDDR = GPIO_PDDR_PDD(0x3F000FC0);	// Change corresponding PTA port pins as outputs

	PIT->MCR &= ~PIT_MCR_MDIS_MASK;					// Enable PIT module
	PIT->MCR |= PIT_MCR_FRZ_MASK;					// Enable PIT module in debug mode
	PIT->CHANNEL[0].LDVAL |= 0x186A0;				// Set PIT0 timer
	PIT->CHANNEL[0].TCTRL |= PIT_TCTRL_TIE_MASK;	// Enable PIT0 timer
	PIT->CHANNEL[0].TCTRL |= PIT_TCTRL_TEN_MASK;	// Start PIT0 timer
	NVIC_SetPriority(PIT0_IRQn, 3);					// Set PIT0 interrupt priority
	NVIC_ClearPendingIRQ(PIT0_IRQn);				// Clear pending PIT0 interrupt
	NVIC_EnableIRQ(PIT0_IRQn);						// Enable PIT0 interrupt
}

/**
 * Inspired by Ing. Vaclav Simek: Sample project to test the equipment [quoted 2023-12-04]
 * Available from: https://www.fit.vutbr.cz/~simekv/IMP_projekt_had_tabule_test.zip
 */
void column_select(unsigned int col_num) {
	unsigned i, result, col_sel[4];
	for(i = 0; i < 4; i++) {
		result = col_num / 2;
		col_sel[i] = col_num % 2;
		col_num = result;
		switch(i) {
			// Selection signal A0
		    case 0:
				((col_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(8))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(8)));
				break;
			// Selection signal A1
			case 1:
				((col_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(10))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(10)));
				break;
			// Selection signal A2
			case 2:
				((col_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(6))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(6)));
				break;
			// Selection signal A3
			case 3:
				((col_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(11))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(11)));
				break;
			// Otherwise nothing to do...
			default:
				break;
		}
	}
}

void row_select(unsigned int row_num) {
	unsigned i, result, row_sel[8];
	for(i = 0; i < 8; i++) {
		result = row_num / 2;
		row_sel[i] = row_num % 2;
		row_num = result;
		switch(i) {
			// Selection signal R0
			case 0:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(26))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(26)));
				break;
			// Selection signal R1
			case 1:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(24))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(24)));
				break;
			// Selection signal R2
			case 2:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(9))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(9)));
				break;
			// Selection signal R3
			case 3:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(25))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(25)));
				break;
			// Selection signal R4
			case 4:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(28))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(28)));
				break;
			// Selection signal R5
			case 5:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(7))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(7)));
				break;
			// Selection signal R6
			case 6:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(27))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(27)));
				break;
			// Selection signal R7
			case 7:
				((row_sel[i]) == 0) ? (PTA->PDOR &= ~GPIO_PDOR_PDO(GPIO_PIN(29))) : (PTA->PDOR |= GPIO_PDOR_PDO(GPIO_PIN(29)));
				break;
			// Otherwise nothing to do...
			default:
				break;
		}
	}
}

void PIT0_IRQHandler() {
	if(PIT->CHANNEL[0].TFLG & PIT_TFLG_TIF_MASK) {
		PIT->CHANNEL[0].TFLG &= PIT_TFLG_TIF_MASK;	// Clear PIT0 interrupt flag
		counter++;
	}
}

int main(void) {
	init();
    for(;;) {
		if(counter > 641) {
			counter = 0;
			choice++;
			if(choice > 2) {
				choice = 0;
			}
		}
		switch(counter) {
			case 1:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(15);
				break;

			case 2:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 3:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(14);
				break;

			case 4:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 5:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 6:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(13);
				break;

			case 7:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 8:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 9:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 10:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(12);
				break;

			case 11:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 12:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 13:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 14:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 15:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(11);
				break;

			case 16:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 17:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 18:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 19:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 20:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(10);
				break;

			case 21:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 22:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 23:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 24:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 25:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 26:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(9);
				break;

			case 27:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 28:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 29:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 30:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 31:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 32:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 33:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(8);
				break;

			case 34:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 35:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 36:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 37:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 38:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 39:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 40:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 41:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(7);
				break;

			case 42:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 43:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 44:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 45:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 46:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 47:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 48:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 49:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 50:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(6);
				break;

			case 51:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 52:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 53:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 54:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 55:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 56:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 57:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 58:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 59:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 60:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(5);
				break;

			case 61:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 62:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 63:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 64:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 65:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 66:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 67:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 68:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 69:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 70:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(4);
				break;

			case 71:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 72:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 73:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 74:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 75:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 76:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 77:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 78:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 79:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 80:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 81:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(3);
				break;

			case 82:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 83:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 84:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 85:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 86:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 87:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 88:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 89:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 90:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 91:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 92:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 93:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(2);
				break;

			case 94:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 95:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 96:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 97:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 98:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 99:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 100:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 101:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 102:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 103:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 104:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 105:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 106:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 107:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 108:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 109:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 110:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 111:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 112:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 113:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 114:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 115:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 116:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 117:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 118:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 119:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 120:
				switch(choice) {
					case 0:
						row_select(CHAR_F0);
						break;
					case 1:
						row_select(CHAR_I0);
						break;
					case 2:
						row_select(CHAR_X0);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 121:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 122:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 123:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 124:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 125:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 126:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 127:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 128:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 129:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 130:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 131:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 132:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 133:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 134:
				switch(choice) {
					case 0:
						row_select(CHAR_F1);
						break;
					case 1:
						row_select(CHAR_I1);
						break;
					case 2:
						row_select(CHAR_X1);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 135:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 136:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 137:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 138:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 139:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 140:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 141:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 142:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 143:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 144:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 145:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 146:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 147:
				switch(choice) {
					case 0:
						row_select(CHAR_F2);
						break;
					case 1:
						row_select(CHAR_I2);
						break;
					case 2:
						row_select(CHAR_X2);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 148:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 149:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 150:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 151:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 152:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 153:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 154:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 155:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 156:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 157:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 158:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 159:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 160:
				switch(choice) {
					case 0:
						row_select(CHAR_F3);
						break;
					case 1:
						row_select(CHAR_I3);
						break;
					case 2:
						row_select(CHAR_X3);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 161:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 162:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 163:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 164:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 165:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 166:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 167:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 168:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 169:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 170:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 171:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 172:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 173:
				switch(choice) {
					case 0:
						row_select(CHAR_F4);
						break;
					case 1:
						row_select(CHAR_I4);
						break;
					case 2:
						row_select(CHAR_X4);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 174:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 175:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 176:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 177:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 178:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 179:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 180:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 181:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 182:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 183:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 184:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 185:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 186:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 187:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 188:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 189:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 190:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 191:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 192:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 193:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 194:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 195:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 196:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 197:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 198:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 199:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 200:
				switch(choice) {
					case 0:
						row_select(CHAR_I0);
						break;
					case 1:
						row_select(CHAR_M0);
						break;
					case 2:
						row_select(CHAR_K0);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 201:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 202:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 203:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 204:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 205:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 206:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 207:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 208:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 209:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 210:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 211:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 212:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 213:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 214:
				switch(choice) {
					case 0:
						row_select(CHAR_I1);
						break;
					case 1:
						row_select(CHAR_M1);
						break;
					case 2:
						row_select(CHAR_K1);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 215:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 216:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 217:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 218:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 219:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 220:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 221:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 222:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 223:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 224:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 225:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 226:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 227:
				switch(choice) {
					case 0:
						row_select(CHAR_I2);
						break;
					case 1:
						row_select(CHAR_M2);
						break;
					case 2:
						row_select(CHAR_K2);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 228:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 229:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 230:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 231:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 232:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 233:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 234:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 235:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 236:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 237:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 238:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 239:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 240:
				switch(choice) {
					case 0:
						row_select(CHAR_I3);
						break;
					case 1:
						row_select(CHAR_M3);
						break;
					case 2:
						row_select(CHAR_K3);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 241:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 242:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 243:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 244:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 245:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 246:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 247:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 248:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 249:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 250:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 251:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 252:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 253:
				switch(choice) {
					case 0:
						row_select(CHAR_I4);
						break;
					case 1:
						row_select(CHAR_M4);
						break;
					case 2:
						row_select(CHAR_K4);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 254:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 255:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 256:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 257:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 258:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 259:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 260:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 261:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 262:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 263:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 264:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 265:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 266:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 267:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 268:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 269:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 270:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 271:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 272:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 273:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 274:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 275:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 276:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 277:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 278:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 279:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 280:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(CHAR_P0);
						break;
					case 2:
						row_select(CHAR_V0);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 281:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 282:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 283:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 284:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 285:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 286:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 287:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 288:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 289:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 290:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 291:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 292:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 293:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 294:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(CHAR_P1);
						break;
					case 2:
						row_select(CHAR_V1);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 295:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 296:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 297:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 298:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 299:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 300:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 301:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 302:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 303:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 304:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 305:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 306:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 307:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(CHAR_P2);
						break;
					case 2:
						row_select(CHAR_V2);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 308:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 309:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 310:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 311:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 312:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 313:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 314:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 315:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 316:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 317:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 318:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 319:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 320:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(CHAR_P3);
						break;
					case 2:
						row_select(CHAR_V3);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 321:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 322:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 323:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 324:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 325:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 326:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 327:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 328:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 329:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 330:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 331:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 332:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 333:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(CHAR_P4);
						break;
					case 2:
						row_select(CHAR_V4);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 334:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 335:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 336:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 337:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 338:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 339:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 340:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 341:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 342:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 343:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 344:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 345:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 346:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 347:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 348:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 349:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 350:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 351:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 352:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 353:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 354:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 355:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 356:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 357:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 358:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 359:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 360:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A0);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 361:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 362:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 363:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 364:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 365:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 366:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 367:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 368:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 369:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 370:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 371:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 372:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 373:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 374:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A1);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 375:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 376:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 377:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 378:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 379:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 380:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 381:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 382:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 383:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 384:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 385:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 386:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 387:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A2);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 388:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 389:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 390:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 391:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 392:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 393:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 394:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 395:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 396:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 397:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 398:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 399:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 400:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A3);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 401:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 402:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 403:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 404:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 405:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 406:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 407:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 408:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 409:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 410:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 411:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 412:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 413:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(CHAR_SP);
						break;
					case 2:
						row_select(CHAR_A4);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 414:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 415:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 416:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 417:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 418:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 419:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 420:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 421:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 422:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 423:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 424:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 425:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 426:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 427:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 428:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 429:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 430:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 431:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 432:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 433:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 434:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 435:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 436:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 437:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 438:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 439:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 440:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(CHAR_C0);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 441:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 442:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 443:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 444:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 445:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 446:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 447:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 448:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 449:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 450:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 451:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 452:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 453:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 454:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(CHAR_C1);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 455:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 456:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 457:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 458:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 459:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 460:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 461:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 462:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 463:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 464:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 465:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 466:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 467:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(CHAR_C2);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 468:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 469:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 470:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 471:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 472:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 473:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 474:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 475:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 476:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 477:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 478:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 479:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 480:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(CHAR_C3);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 481:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 482:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 483:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 484:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 485:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 486:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 487:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 488:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 489:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 490:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 491:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 492:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 493:
				switch(choice) {
					case 0:
						row_select(CHAR_DH);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(CHAR_C4);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 494:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 495:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 496:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 497:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 498:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 499:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 500:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 501:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 502:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 503:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 504:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 505:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 506:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 507:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 508:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 509:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 510:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 511:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 512:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 513:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 514:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 515:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 516:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 517:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 518:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 519:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 520:
				switch(choice) {
					case 0:
						row_select(CHAR_B0);
						break;
					case 1:
						row_select(NUM_00);
						break;
					case 2:
						row_select(CHAR_E0);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 521:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(15);
				break;
			case 522:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 523:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 524:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 525:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 526:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 527:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 528:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 529:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 530:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 531:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 532:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 533:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 534:
				switch(choice) {
					case 0:
						row_select(CHAR_B1);
						break;
					case 1:
						row_select(NUM_01);
						break;
					case 2:
						row_select(CHAR_E1);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 535:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(14);
				break;
			case 536:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 537:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 538:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 539:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 540:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 541:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 542:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 543:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 544:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 545:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 546:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 547:
				switch(choice) {
					case 0:
						row_select(CHAR_B2);
						break;
					case 1:
						row_select(NUM_02);
						break;
					case 2:
						row_select(CHAR_E2);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 548:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(13);
				break;
			case 549:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 550:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 551:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 552:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 553:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 554:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 555:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 556:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 557:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 558:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 559:
				switch(choice) {
					case 0:
						row_select(CHAR_B3);
						break;
					case 1:
						row_select(NUM_03);
						break;
					case 2:
						row_select(CHAR_E3);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 560:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(12);
				break;
			case 561:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 562:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 563:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 564:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 565:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 566:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 567:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 568:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 569:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 570:
				switch(choice) {
					case 0:
						row_select(CHAR_B4);
						break;
					case 1:
						row_select(NUM_04);
						break;
					case 2:
						row_select(CHAR_E4);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 571:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(11);
				break;
			case 572:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 573:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 574:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 575:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 576:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 577:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 578:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 579:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 580:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 581:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(10);
				break;
			case 582:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 583:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 584:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 585:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 586:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 587:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 588:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 589:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 590:
				switch(choice) {
					case 0:
						row_select(CHAR_U0);
						break;
					case 1:
						row_select(NUM_20);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 591:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(9);
				break;
			case 592:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 593:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 594:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 595:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 596:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 597:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 598:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 599:
				switch(choice) {
					case 0:
						row_select(CHAR_U1);
						break;
					case 1:
						row_select(NUM_21);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 600:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(8);
				break;
			case 601:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 602:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 603:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 604:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 605:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 606:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 607:
				switch(choice) {
					case 0:
						row_select(CHAR_U2);
						break;
					case 1:
						row_select(NUM_22);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 608:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(7);
				break;
			case 609:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 610:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 611:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 612:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 613:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 614:
				switch(choice) {
					case 0:
						row_select(CHAR_U3);
						break;
					case 1:
						row_select(NUM_23);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 615:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(6);
				break;
			case 616:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 617:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 618:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 619:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 620:
				switch(choice) {
					case 0:
						row_select(CHAR_U4);
						break;
					case 1:
						row_select(NUM_24);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 621:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(5);
				break;
			case 622:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 623:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 624:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 625:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(1);
				break;

			case 626:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(4);
				break;
			case 627:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 628:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 629:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 630:
				switch(choice) {
					case 0:
						row_select(CHAR_T0);
						break;
					case 1:
						row_select(NUM_30);
						break;
					case 2:
						row_select(NUM_00);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 631:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(3);
				break;
			case 632:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 633:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 634:
				switch(choice) {
					case 0:
						row_select(CHAR_T1);
						break;
					case 1:
						row_select(NUM_31);
						break;
					case 2:
						row_select(NUM_01);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 635:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(2);
				break;
			case 636:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 637:
				switch(choice) {
					case 0:
						row_select(CHAR_T2);
						break;
					case 1:
						row_select(NUM_32);
						break;
					case 2:
						row_select(NUM_02);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 638:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(1);
				break;
			case 639:
				switch(choice) {
					case 0:
						row_select(CHAR_T3);
						break;
					case 1:
						row_select(NUM_33);
						break;
					case 2:
						row_select(NUM_03);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			case 640:
				switch(choice) {
					case 0:
						row_select(CHAR_T4);
						break;
					case 1:
						row_select(NUM_34);
						break;
					case 2:
						row_select(NUM_04);
						break;
					default:
						break;
				}
				column_select(0);
				break;

			default:
				break;
		}
	}
    // Never leave main
    return 0;
}
