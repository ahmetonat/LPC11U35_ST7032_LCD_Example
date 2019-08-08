/* File: startup_ARMCM0.S
 * Purpose: startup file for Cortex-M0 devices. Should use with
 *   GCC for ARM Embedded Processors
 * Version: V1.3
 * Date: 08 Feb 2012
 *
 * Copyright (c) 2012, ARM Limited
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the ARM Limited nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ARM LIMITED BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
    .syntax unified
    .arch armv6-m

    .section .stack
    .align 3
#ifdef __STACK_SIZE
    .equ    Stack_Size, __STACK_SIZE
#else
    .equ    Stack_Size, 0x400
#endif
    .globl    __StackTop
    .globl    __StackLimit
__StackLimit:
    .space    Stack_Size
    .size __StackLimit, . - __StackLimit
__StackTop:
    .size __StackTop, . - __StackTop

    .section .heap
    .align 3
#ifdef __HEAP_SIZE
    .equ    Heap_Size, __HEAP_SIZE
#else
    .equ    Heap_Size, 0xC00
#endif
    .globl    __HeapBase
    .globl    __HeapLimit
__HeapBase:
    .if    Heap_Size
    .space    Heap_Size
    .endif
    .size __HeapBase, . - __HeapBase
__HeapLimit:
    .size __HeapLimit, . - __HeapLimit

    .section .isr_vector
    .align 2
    .globl __isr_vector
__isr_vector:
    .long    __StackTop            /* Top of Stack */
    .long    Reset_Handler         /* Reset Handler */
    .long    NMI_Handler           /* NMI Handler */
    .long    HardFault_Handler     /* Hard Fault Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    SVC_Handler           /* SVCall Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    PendSV_Handler        /* PendSV Handler */
    .long    SysTick_Handler       /* SysTick Handler */

    /* External interrupts */
    /* AO!: The originals did not match what is in the Programming manual*/
    /*   of the device: pp65, Table 58 */

    /* The new table is: */
    .long PIN_INT0Handler    /* 0 */
    .long PIN_INT1Handler    /* 1 */
    .long PIN_INT2Handler    /* 2 */
    .long PIN_INT3Handler    /* 3 */
    .long PIN_INT4Handler    /* 4 */
    .long PIN_INT5Handler    /* 5 */
    .long PIN_INT6Handler    /* 6 */
    .long PIN_INT7Handler    /* 7 */

    .long GINT0Handler       /* 8 */
    .long GINT1Handler       /* 9 */
    .long 0                  /* 10 Reserved */
    .long 0                  /* 11 Reserved */
    .long 0                  /* 12 Reserved */
    .long 0                  /* 13 Reserved */
    .long SSP1Handler        /* 14 */
/*    .long I2CHandler*/         /* 15 */
    .long I2C_IRQHandler         /* 15 AO!*/
    .long CT16B0Handler      /* 16 */
    .long CT16B1Handler      /* 17 */
    .long CT32B0Handler      /* 18 */
    .long CT32B1Handler      /* 19 */
    .long SSP0Handler	     /* 20 */
    .long USARTHandler       /* 21 */
    .long USB_IRQHandler     /* 22 */
    .long USB_FIQHandler     /* 23 */
    .long ADCHandler         /* 24 */
    .long WWDTHandler        /* 25 */
    .long BODHandler         /* 26 */
    .long FLASHHandler       /* 27 */
    .long 0                  /* 28 Reserved */
    .long 0                  /* 29 Reserved */
    .long USB_WAKEUPHandler  /* 30 */
    .long 0                  /* 31 Reserved */

	
    .size    __isr_vector, . - __isr_vector

    .text
    .thumb
    .thumb_func
    .align 2
    .globl    Reset_Handler
    .type    Reset_Handler, %function
Reset_Handler:
/*     Loop to copy data from read only memory to RAM. The ranges
 *      of copy from/to are specified by following symbols evaluated in
 *      linker script.
 *      __etext: End of code section, i.e., begin of data sections to copy from.
 *      __data_start__/__data_end__: RAM address range that data should be
 *      copied to. Both must be aligned to 4 bytes boundary.  */

    ldr    r1, =__etext
    ldr    r2, =__data_start__
    ldr    r3, =__data_end__

    subs    r3, r2
    ble    .flash_to_ram_loop_end

    movs    r4, 0
.flash_to_ram_loop:
    ldr    r0, [r1,r4]
    str    r0, [r2,r4]
    adds    r4, 4
    cmp    r4, r3
    blt    .flash_to_ram_loop
.flash_to_ram_loop_end:

#ifndef __NO_SYSTEM_INIT
    ldr    r0, =SystemInit
    blx    r0
#endif

    ldr    r0, =_start
    bx    r0
    .pool
    .size Reset_Handler, . - Reset_Handler

/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
    .macro    def_irq_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .size    \handler_name, . - \handler_name
    .endm

    def_irq_handler    NMI_Handler
    def_irq_handler    HardFault_Handler
    def_irq_handler    SVC_Handler
    def_irq_handler    PendSV_Handler
    def_irq_handler    SysTick_Handler
    def_irq_handler    Default_Handler

    def_irq_handler    PIN_INT0Handler     /* 00 */
    def_irq_handler    PIN_INT1Handler     /* 01 */
    def_irq_handler    PIN_INT2Handler     /* 02 */
    def_irq_handler    PIN_INT3Handler     /* 03 */
    def_irq_handler    PIN_INT4Handler     /* 04 */
    def_irq_handler    PIN_INT5Handler     /* 05 */
    def_irq_handler    PIN_INT6Handler     /* 06 */
    def_irq_handler    PIN_INT7Handler     /* 07 */
	
    def_irq_handler    GINT0Handler        /* 08 */
    def_irq_handler    GINT1Handler        /* 09 */
    def_irq_handler    SSP1Handler         /* 14 */
/*    def_irq_handler    I2CHandler */         /* 15 */
    def_irq_handler    I2C_IRQHandler          /* 15 AO!*/
    def_irq_handler    CT16B0Handler       /* 16 */
    def_irq_handler    CT16B1Handler       /* 17 */
    def_irq_handler    CT32B0Handler       /* 18 */
    def_irq_handler    CT32B1Handler       /* 19 */
    def_irq_handler    SSP0Handler         /* 20 */
    def_irq_handler    USARTHandler        /* 21 */
    def_irq_handler    USB_IRQHandler      /* 22 */
    def_irq_handler    USB_FIQHandler      /* 23 */
    def_irq_handler    ADCHandler          /* 24 */
    def_irq_handler    WWDTHandler         /* 25 */
    def_irq_handler    BODHandler          /* 26 */
    def_irq_handler    FLASHHandler        /* 27 */
    def_irq_handler    USB_WAKEUPHandler   /* 30 */

    .end
