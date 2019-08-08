

#ifndef LCD_ST7023
#define LCD_ST7023

#define I2C_BUFSIZE 2
#define I2C_INIT_BUF 2

#define LCD_ADDR 0x7C
//#define LCD_ADDR 0x7E //Check: There seems to be registers addressable here.  

#define LCD_CMD 0x00  //Some convenience defs...
#define LCD_DAT 0x40

#define LCD_LINE1 0
#define LCD_LINE2 1

#define LCD_CLR 0x01


void lcd_i2cInit (void); //Initialize I2C interface.

void lcd_init(void);  //Initialize LCD registers.

void lcd_putchar (uint8_t character); //Write 1 character.

void lcd_writecmd (uint8_t command);  //Write 1 command

void lcd_message (uint8_t * msgbuf);  //Write a message.

void lcd_goto (uint8_t line, uint8_t posn); //Goto a position on LCD.

#endif
