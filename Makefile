
# compilation flags for gdb
CFLAGS  = -O1 -g
ASFLAGS = -g 

# object files
OBJS = main.o
OBJS += gpio.o
OBJS += i2c.o
OBJS += lcd_st7032.o
OBJS += startup_ARMCM0.o
OBJS += system_LPC11Uxx.o
# Contains declarations such as __INLINE
OBJS += core_cm0.o

#LDFLAGS_POST = -lm

ELF=$(notdir $(CURDIR)).elf
MAP_FILE=$(notdir $(CURDIR)).map  #AO!
BIN_FILE=$(notdir $(CURDIR)).bin  #AO!

# Tool path
#TOOLROOT=adfalfkal  AO! If needed, set directory containing compiler.

# Library path. Change for your installation:
LIBROOT=/home/onat/elektronik/ARM/Compiler/LPC

# Tools
CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy  #AO!

# LPC *requires* a checksum inserted into the binary. This does it:
CHECKSUM=/home/onat/elektronik/ARM/LPC/lpcpatchelf/lpcpatchelf
CHECKSUM_FLAG=-f

# Code Paths
DEVICE=$(LIBROOT)/Lib_MCU
CORE=$(LIBROOT)/Lib_CMSISv2p00_LPC11Uxx

# Search path for perpheral library
vpath %.c $(CORE)/src
#vpath %.c $(PERIPH)/src
vpath %.c $(DEVICE)/src

LDSCRIPT = lpc11u35.ld


LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m0 -Wl,-Map=$(MAP_FILE) #AO map!
CFLAGS+= -mcpu=cortex-m0 -mthumb 
CFLAGS+= -I$(DEVICE)/inc -I$(CORE)/inc -I.
CFLAGS+= -DUSE_STDPERIPH_DRIVER

CFLAGS += -D__USE_CMSIS


OBJCOPYFLAGS = -O binary --gap-fill 255 --pad-to 65536

# Build executable 
$(BIN_FILE) : $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

$(ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS) $(LDFLAGS_POST)
#	AO!: LPC requires a checksum to be patched into the ELF!:
	$(CHECKSUM) $(CHECKSUM_FLAG)  $@

# compile and generate dependency info
%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM $(CFLAGS) $< > $*.d

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) startup_stm32f.o 


uflash: $(BIN_FILE)
	dd bs=1024 conv=nocreat,notrunc if=$(BIN_FILE) of="/media/$(shell echo $$USER)/CRP DISABLD/firmware.bin"

