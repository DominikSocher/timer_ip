/*
 * Timer IP example 1
 *
 */

#include <stdio.h>
#include <altera_avalon_timer_regs.h>

int main()
{
	//reset timer
	TIMER_RESET();
	//start timer
	TIMER_START();
	while(1)
	{
		//timer test
		printf("time: %d \n", TIMER_READ());
		for(size_t i = 0; i < 500000; i++);
	}

  return 0;
}
