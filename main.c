

// This code is a demonstration of how to use:
// The I2C interface and
// A Sitronix ST7032 LCD
//  on the LPC11U35 processor
//
//  Development environment is GCC based with local libraries.
//
// It does not require any vendor locked libraries.


#include <type.h>
#include "LPC11Uxx.h"
#include <system_LPC11Uxx.h>
#include "gpio.h"
#include "i2c.h"
#include "lcd_st7032.h"


#define LED7_GPIO 0  // LED on GPIO 0,
#define LED7_BIT  7  // Pin 7.
#define LED_ON   1  // Level to set port to turn on led
#define LED_OFF  0  // Level to set port to turn off led

#define True 1
#define False 0
#define MSCOUNT_MAX 1000

// ISR based delay routine:
static __IO uint32_t TimingDelay;
static __IO uint8_t SystickEvt;  //Systick has occurred
void Delay_ms(uint32_t nTime);



int main(void) {

  uint32_t mscount=0;
  uint8_t i;

  SystickEvt=False;
  
  GPIOInit();  // Initialize GPIO port.
  
  TimingDelay=0; //Initialize timer variable.

  GPIOSetDir(LED7_GPIO, LED7_BIT, 1 );   // Configure LED pin as output

  GPIOSetBitValue(LED7_GPIO, LED7_BIT, LED_OFF);

  //Configure systick timer for 1ms interrupts:
  if (SysTick_Config(SystemCoreClock/1000)){
    while (1); //If not successful, block here...
  }
  

  lcd_i2cInit();
  lcd_init();

  lcd_goto (0,2);
  lcd_message ("NXP LPC11U35");

  lcd_goto (1,2);
  lcd_message("LCD: ST7032");
  
  while (1) {

    if (SystickEvt==True){ //Track the passing of time:
      ++mscount;
      SystickEvt=False;
      if (mscount==MSCOUNT_MAX) //Used to time LED blink.
	mscount=0;
    }

    if (mscount==0){  //Blink a '*' every second.
      lcd_goto(LCD_LINE2, 15);
      lcd_putchar('*');
    }else if (mscount==500){
      lcd_goto(LCD_LINE2, 15);
      lcd_putchar(' ');
    }
    
    if (mscount<100){ //Blink LED with a pleasing pattern:
      GPIOSetBitValue(LED7_GPIO, LED7_BIT, LED_ON); // Turn LED on

    }else if (mscount>=100 && mscount<200){
      GPIOSetBitValue(LED7_GPIO, LED7_BIT, LED_OFF);

    }else if (mscount>=200 && mscount<300){
      GPIOSetBitValue(LED7_GPIO, LED7_BIT, LED_ON);

    }else if (mscount>=300 && mscount<MSCOUNT_MAX){
      GPIOSetBitValue(LED7_GPIO, LED7_BIT, LED_OFF);
    }
    
  }  //End while(1)
} //End main()


// Delay_ms is needed in LCD initialization.
void Delay_ms( uint32_t nTime ){
  TimingDelay = nTime ;
  while ( TimingDelay != 0);
  }


void SysTick_Handler (void){   // Systick ISR
  if ( TimingDelay != 0x00)
    TimingDelay --;
  
  SystickEvt=True;

}
