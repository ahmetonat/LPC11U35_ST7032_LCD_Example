# LPC11U35_ST7032_LCD_Example

I have introduced the LPC11U35 processor local development environment based on [GNU ARM Embedded Toolchain](https://launchpad.net/gcc-arm-embedded) in my [LPC11U35 LED BLINK EXAMPLE repo](https://github.com/ahmetonat/LPC11U35_LED_BLINK_EXAMPLE). My eventual aim is to use this processor as a standalone data acquisition board that can be connected over USB and send data to any PC through a CDC device structure. In this repo, I show two things:
- How to use the I2C port on the LPC11U35
- How to drive a character LCD using the Sitronix ST7032 driver chip.

![It looks like this:](https://github.com/ahmetonat/LPC11U35_ST7032_LCD_Example/blob/master/LPC11U35_ST7032.jpg)

This LCD driver is actually compatible with the popular [HD44780 driver chip](https://en.wikipedia.org/wiki/Hitachi_HD44780_LCD_controller) which has been around almost as long as myself (which is quite some time!)

This code uses the same simple libraries as [my introductory repo](https://github.com/ahmetonat/LPC11U35_LED_BLINK_EXAMPLE), and thus it is extremely lightweight. The I2C interface is used in an interrupt setting, so the interrupt handler must be registered within the startup script startupARMCM0.S. This has already been done in this code, of course.

The code is simple to use. It provides the following functions:
- ` void lcd_i2cInit (void); //Initialize I2C interface.`
- `void lcd_init(void);  //Initialize LCD registers.`
- `void lcd_putchar (uint8_t character); //Write 1 character.`
- `void lcd_writecmd (uint8_t command);  //Write 1 command`
- `void lcd_message (uint8_t * msgbuf);  //Write a message.`
- `void lcd_goto (uint8_t line, uint8_t posn); //Goto a position on LCD.`

The user must include the file `lcd_st7032.h` in their code, and call the following functions to initialize the LCD:
```C
  lcd_i2cInit();
  lcd_init();
```
During normal use, the following commands will be used such as:
```C
  lcd_goto (0,2);
  lcd_message ("NXP LPC11U35");
```

["Share and Enjoy!"](https://hitchhikers.fandom.com/wiki/Sirius_Cybernetics_Corporation)
