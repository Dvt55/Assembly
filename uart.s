/*  Este código serve para ler números até que se leia um caracatere que não seja número. Quando isso ocorrer ele vai printar o vetor dos numeros que li */


/* Global Symbols */
.global .uart_putc
.global .uart_getc
.global .uart0_setup
.global .uart0
.global .num
.global _buffer_count
.global flag
.global .ler_end
.global .ler_numeros
.global _buffer_count2


.type .uart_getc, %function
.type .uart_putc, %function


/* Registradores */
.equ UART0_BASE, 0x44E09000
.equ UART0_IER, 0x44E09004

/* Text Section */
.section .text,"ax"
         .code 32
         .align 4
         

/********************************************************
UART0 SETUP 
********************************************************/
.uart0_setup:
	stmfd sp!,{r0-r1,lr}
	
	/* Enable UART0 */
    	ldr r0, =UART0_IER
    	ldr r1, =#(1<<0) 
    	strb r1, [r0]
    	ldr r1, =#(1<<1) 
    	strb r1, [r0]
    	
    	 /* UART0 Interrupt configured as IRQ Priority 0 */
    	//UART0 Interrupt number 72
    	ldr r0, =INTC_ILR
   	ldr r1, =#0    
    	strb r1, [r0, #72]
	
	/* Interrupt mask */
    	ldr r0, =INTC_BASE
    	ldr r1, =#(1<<8)    
    	str r1, [r0, #0xc8] //(72 --> Bit 8 do 3º registrador (MIR CLEAR2))  ;  MIRCLEAR2_BASE = C8
	
	ldmfd sp!,{r0-r1,pc}

/********************************************************/
         
/********************************************************
UART0 PUTC (Default configuration)  
********************************************************/
.global _putc
.type _putc, %function

_putc:
.uart_putc:
    stmfd sp!,{r1-r2,lr}
    ldr     r1, =UART0_BASE

.wait_tx_fifo_empty:
    ldr r2, [r1, #0x14] 
    and r2, r2, #(1<<5)
    cmp r2, #0
    beq .wait_tx_fifo_empty

    strb    r0, [r1]                
    ldmfd sp!,{r1-r2,pc}

/********************************************************
UART0 GETC (Default configuration)  
********************************************************/
.uart_getc:
    stmfd sp!,{r1-r2,lr}
    ldr     r1, =UART0_BASE

.wait_rx_fifo:
    ldr r2, [r1, #0x14] 
    and r2, r2, #(1<<0)
    cmp r2, #0
    beq .wait_rx_fifo

    ldrb    r0, [r1]                 
    ldmfd sp!,{r1-r2,pc}
/********************************************************/
.numero:
	sub r0,r0, #0x30
	bl .volta
/********************************************************
LER
********************************************************/

.ler_numeros:
	stmfd sp!,{r1-r2,lr}
	
	bl .uart_getc
	cmp r0,#'\r'
	bleq .enter
	bl .uart_putc
	cmp r0, #0x30
	blt .printa_numeros
	cmp r0, #0x39
	bgt .printa_numeros
	
	
	ldr r3, =_buffer_count
	ldrb r2, [r3]
	ldr r1, =_buffer
	strb r0, [r1,r2]
	add r2,r2, #1
	strb r2,[r3]
	
	ldr r3, =flag
	ldrb r2, [r3]
	add r2,r2,#1
	strb r2, [r3]
	ldmfd sp!,{r1-r2,pc}
						
	
.enter:
	ldr r0, =prox_linha
	bl .print_string
	
	
.ascii_to_hexa:

     
     // transformando para hexa e colocando no buffer
     ldr r3, =_buffer_count
     ldrb r2, [r3]
     ldr r4, =_buffer
     mov r5, #0
     mov r3, #0
     
.loop_buffer:
     ldrb r0, [r4, r5]
     cmp r0, #58         
     blt .numero
     sub r0, r0, #0x57
.volta:
     mov r3, r3, LSL #4
     add r3, r3, r0
     add r5, r5, #1
     cmp r2, r5
     bne .loop_buffer
     
     ldr r6, =_buffer_count2
     ldrb r2, [r6]
     ldr r4, =_buffer2
     strb r3, [r4,r2]
     add r2, r2, #1
     strb r2, [r6]


     
    ldr r3, =_buffer_count
    mov r2, #0
    strb r2, [r3]
    ldmfd sp!,{r1-r2,pc}
    
	
	/*mov r5,#0
	mov r6,#0*/
	
.printa_numeros:
	ldr r0, =prox_linha
	bl .print_string
	mov r6,#0
	
.loop:
	ldr r3, =_buffer2
	ldrb r0, [r3,r6]
	bl .hex_to_ascii
	add r6,r6,#1
	
	
	ldr r3, =flag
	ldrb r2, [r3]
	cmp r6,r2
	bne .loop
	
.final_codigo:
	bl _start
	

/*************************************************/


prox_linha:    .asciz "\n\r"


/* Data Section */
.section .data
.align 4

/* BSS Section */
.section .bss
.align 4

.equ BUFFER_SIZE, 16


_buffer: .fill BUFFER_SIZE
_buffer_count: .fill 4

_buffer2: .fill BUFFER_SIZE
_buffer_count2: .fill 4



flag: .fill 1


