# LPC11U35_ST7032_LCD_Example

I have introduced the LPC11U35 processor local development environment based on [GNU ARM Embedded Toolchain](https://launchpad.net/gcc-arm-embedded) in my [LPC11U35 LED BLINK EXAMPLE repo](https://github.com/ahmetonat/LPC11U35_LED_BLINK_EXAMPLE). My eventual aim is to use this processor as a standalone data acquisition board that can be connected over USB and send data to any PC through a CDC device structure. In this repo, I show two things:
- How to use the I2C port on the LPC11U35
- How to drive a character LCD using the Sitronix ST7032 driver chip.

This driver is actually compatible with the popular [HD44780 driver chip](https://en.wikipedia.org/wiki/Hitachi_HD44780_LCD_controller) which has been around almost as long as myself (which is quite some time!)

This code uses the same simple libraries as [my introductory repo](https://github.com/ahmetonat/LPC11U35_LED_BLINK_EXAMPLE), and thus it is extremely lightweight.

The code is simple to use. It provides the following functions:
- ```C void lcd_i2cInit (void); //Initialize I2C interface.```

void lcd_init(void);  //Initialize LCD registers.

void lcd_putchar (uint8_t character); //Write 1 character.

void lcd_writecmd (uint8_t command);  //Write 1 command

void lcd_message (uint8_t * msgbuf);  //Write a message.

void lcd_goto (uint8_t line, uint8_t posn); //Goto a position on LCD.
