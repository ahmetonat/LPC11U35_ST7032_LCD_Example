

//This code is for managing the Sitronix ST7032 character LCD controller. This one was attached to a 2x16 LCD screen as a CoG.
// The code is intended to run on an LPC11U35 processor.

#include <type.h>
#include "LPC11Uxx.h"
#include <system_LPC11Uxx.h>
#include "i2c.h"
#include "lcd_st7032.h"

void lcd_i2cInit (void){ //Initialize on-chip I2C peripheral for master ops.

  uint8_t i;
  i=I2CInit (I2CMASTER, 0); //Second argument is for slave address. Irrelevant.
  /*
  if (i==!TRUE){ //True is defined in type.h
    //It did not initialize correctly. Stop here:
    GPIOSetBitValue(LED7_GPIO, LED7_BIT, LED_ON); // Turn LED on
    while (1){} //And stop here.
  }
  */
}

void lcd_init(void){  //Initialize controller registers

  uint8_t i2c_buffer[I2C_INIT_BUF];
  uint8_t i;

  const uint8_t LCD_Init_CMDS[]={0x38, 0x39, 0x14, 0x73, 0x56, 0x6C, 0x38, 0x01, 0x0C};  //Commands to initialize the LCD internal registers.


  i2c_buffer[0]=LCD_CMD;
  for (i=0; i< 9; ++i){  // always 9 commands to initialize;
    i2c_buffer[1]=LCD_Init_CMDS[i];
    I2CWrite(LCD_ADDR, i2c_buffer, 2);
    Delay_ms(20); //This may be too long, but does not hurt.
  }
}

void lcd_putchar (uint8_t character){  //Write one character to LCD

  uint8_t i2c_buffer[I2C_INIT_BUF];
  
  i2c_buffer[0]=LCD_DAT;  
  i2c_buffer[1]=character;
  I2CWrite(LCD_ADDR, i2c_buffer, 2);
}


void lcd_writecmd (uint8_t command){ //Write one command byte.

  uint8_t i2c_buffer[I2C_INIT_BUF];
  
  i2c_buffer[0]=LCD_CMD;  
  i2c_buffer[1]=command;
  I2CWrite(LCD_ADDR, i2c_buffer, 2);

}

void lcd_message (uint8_t * msgbuf){ //Write the contents of a string buffer.

  uint8_t i;
  uint8_t i2c_buffer[I2C_INIT_BUF];

  i2c_buffer[0]=LCD_DAT;
  for (i=0; i< strlen (msgbuf); ++i){  //Write a message:
    i2c_buffer[1]=msgbuf[i];
    I2CWrite(LCD_ADDR, i2c_buffer, 2);
  }

}


//Arg1: Either LCD_LINE1 or LCD_LINE2
//Arg2: Position 0~15

void lcd_goto (uint8_t line, uint8_t posn){ //Go to a specific position.

  uint8_t i2c_buffer[I2C_INIT_BUF];

  if (line>1) line=1; //only 2 lines
  if (posn>15) posn=15; //and 16 positions.
  //No negetive values by definition.

  i2c_buffer[0]=LCD_CMD;
  i2c_buffer[1]=0x80+(line*0x40)+posn;
  I2CWrite(LCD_ADDR, i2c_buffer, 2);
}
