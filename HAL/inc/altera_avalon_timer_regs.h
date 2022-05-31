/**@brief
 * timer.h
 *
 *  Created on: 23.03.2021
 *      Author: Dominik Socher
 *  Device driver for Timer_IP. 
 */
#ifndef ALTERA_AVALON_TIMER_REGS_H_INCLUDED
#define ALTERA_AVALON_TIMER_REGS_H_INCLUDED

#include <io.h>
#include <system.h>

///< Write "00" to bits 31-30
#define TIMER_STOP() IOWR_32DIRECT(TIMER_HW_IP_0_BASE,4,0x00000000)

///< Write "01" to bits 31-30
#define TIMER_RESET() IOWR_32DIRECT(TIMER_HW_IP_0_BASE,4,0x40000000)

///< Write "10" to bits 31-30
#define TIMER_START() IOWR_32DIRECT(TIMER_HW_IP_0_BASE,4,0x80000000)

///< Read 32 bits from data register
#define TIMER_READ() IORD_32DIRECT(TIMER_HW_IP_0_BASE,0)

#endif
