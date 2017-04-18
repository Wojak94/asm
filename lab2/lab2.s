.section .data

SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
SYSEXIT = 60

filename:
	.asciz "number.txt"
filename2:
	.asciz "number2.txt"
filename3:
	.asciz "sumhex.txt"

.section .bss
.comm filehandle, 8
.comm asciibuff, 1024
.comm octal, 400
.comm octal2, 400
.comm octalsum, 400
.comm asciibuffout, 1024



.section .text
.globl _start
_start:
	nop
	movq $0, %r14			#0 as we processing first number
	movq $filename, %rdi		#Load filename to %rdi for open_file system call
open_file:
	movq $SYSOPEN, %rax	
	movq $00, %rsi			#C-like O_RDONLY
	movq $0644, %rdx		#File privilges
	syscall				#Opening file
	test %rax, %rax			
	js badfile
	movq %rax, filehandle	

read_file:
	movq $SYSREAD, %rax
	movq filehandle, %rdi
	movq $asciibuff, %rsi		#Destination of read bytes
	movq $1024, %rdx		#Number of bytes to read
	syscall			
	movq %rax, %rbx			#Save actual number of bytes read	
	
close_file:	
	movq $SYSCLOSE, %rax
	movq filehandle, %rdi
	syscall				#Closing file	
	cmp $1, %r14			#if we closed second file, jump to ...
	je convert_second_number
	
	movq $octal, %r15
	
ascii_to_octal_linefeed:
	movq $asciibuff, %rsi
	dec %rbx			#Decrementing %rbx to point to last byte of ascii
	dec %rbx			#Skipping new line feed (0x0A) ASCII sign	

ascii_to_octal:		
	movb (%rsi, %rbx, 1), %al	#Moving first ASCII sign to %al register				
	sub $'0', %al			#Conversion from ASCII sign to octal (coded on 8 bits)
	movb %al, (%r15)		#Moving 8 bits to first byte of 'octal' memory buffer
	cmp $0, %rbx
	je after_ascii_to_octal		#If %rbx == 0 that means we convreted all of the numbers, so we exiting instruction
	dec %rbx
	movb (%rsi, %rbx, 1), %al	#First byte of 'octal' memory buffer now -> 00000xxx	
	sub $'0', %al
	salb $3, %al			#Shifting value by 3 bits to the left (00000xxx -> 00xxx000)
	orb %al, (%r15)			#Logical OR on shifted number with first byte of 'octal' memory buffer
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	movb (%rsi, %rbx, 1), %al	#First byte of 'octal' memory buffer now -> 00yyyxxx	
	sub $'0', %al
	salb $6, %al			#Shifting value by 6 bits to the left (00000xxx -> xx000000)
	orb %al, (%r15)	
	inc %r15			#MSB of that number is now lost, so we must copy it to the next byte in 'octal'
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	sarb $2, %al			#%al register aftes shifting 2 bits to right (00000xxx -> 0000000x)
	movb %al, (%r15)		#First 2 bytes of 'octal' looks now like this: zzyyyxxx 0000000z
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	salb $1, %al
	orb %al, (%r15)			#First 2 bytes of 'octal' looks now like this: zzyyyxxx 0000aaaz
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	salb $4, %al
	orb %al, (%r15)			#First 2 bytes of 'octal' looks now like this: zzyyyxxx 0bbbaaaz
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	salb $7, %al
	orb %al, (%r15)			#First 2 bytes of 'octal' looks now like this: zzyyyxxx cbbbaaaz
	inc %r15			#Incrementing %r15 so it points to the 3rd byte of 'octal'
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	sarb $1, %al
	movb %al, (%r15)		#First 3 bytes of 'octal' looks now like this: zzyyyxxx cbbbaaaz 000000cc
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	salb $2, %al
	orb %al, (%r15)			#First 3 bytes of 'octal' looks now like this: zzyyyxxx cbbbaaaz 000dddcc
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	movb (%rsi, %rbx, 1), %al
	sub $'0', %al
	salb $5, %al
	orb %al, (%r15)			#First 3 bytes of 'octal' looks now like this: zzyyyxxx cbbbaaaz eeedddcc
	cmp $0, %rbx
	je after_ascii_to_octal
	dec %rbx
	inc %r15
	jmp ascii_to_octal

after_ascii_to_octal:
	cmp $1, %r14			
	je add_numbers_start
	movq $filename2, %rdi		#Move second filename to %rdi for file opening
	movq $1, %r14			#Set %r14 to '1' to indicate second number processing
	jmp open_file			#Jump to open, read, and close the file

convert_second_number:
	movq $octal2, %r15		#Move address of second octal buffer and jmp to convert from ascii
	jmp ascii_to_octal_linefeed

add_numbers_start:
	clc				#Clean carry flag
	pushf				#Push flag register with cleared CF to stack
	movq $50, %rcx			#Counter of 'octal' buffer bytes
	movq $0, %r15			#Counter for 'octal' offset

add_numbers:
	popf				#Pop flag register with cleared CF from stack 
	movq octal(, %r15, 8), %rax	#Load 1 byte from each number to regisetrs
	movq octal2(, %r15, 8), %rbx
	adc %rax, %rbx			
	pushf				#Push flag register with CF after ADC command
	movq %rbx, octalsum(, %r15, 8)	#Move summed number to its buffer
	dec %rcx
	inc %r15
	cmp $0, %rcx			#If %rcx == 0 then all bytes were added
	jg add_numbers	
	
	movq $400, %rcx
skip_zeros:
	dec %rcx	
	movb octalsum(, %rcx, 1), %al	
	cmp $0, %al			#If loaded byte was 0, then loop until find !=0
	je skip_zeros	
	inc %rcx	
	movq $0, %r14			#Offset for 'asciibuffout'

octal_to_ascii_hex:
	dec %rcx
	movb octalsum(, %rcx, 1), %al	#Load byte with 2 hex numbers to both registers
	movb octalsum(, %rcx, 1), %bl
	sarb $4, %al			#Shift one of them to achieve higher bits on lower positions
	and $0b1111, %al		#AND both registers to erase higher bits (0000xxxx)
	and $0b1111, %bl
	add $'0', %al			#Add value of '0' ASCII sign to convert from hex to ASCII
	cmp $'9', %al			#Then, when ASCII value is higher than '9' add decimal 7 (A-F number)
	jle num1_less
	add $7, %al

num1_less:				#Do the same for number in other register
	add $'0', %bl
	cmp $'9', %bl
	jle num2_less
	add $7, %bl	

num2_less:	
	movb %al, asciibuffout(, %r14, 1)	#Move ASCII number to output buffer until you reach end 
	inc %r14
	movb %bl, asciibuffout(, %r14, 1)
	inc %r14
	cmp $0, %rcx
	jnz octal_to_ascii_hex
	movb $0x0A, asciibuffout(, %r14, 1)	#Adding endline char
	inc %r14				#%r14 contains number of bytes (ASCII char) in buffer

open_file_out:
	movq $filename3, %rdi		#Load filename to %rdi for open_file system call
	movq $SYSOPEN, %rax	
	movq $02101, %rsi		#C-like O_WRONLY + O_CREAT + O_APPEND
	movq $0644, %rdx		#File privilges
	syscall				#Opening file
	test %rax, %rax			
	js badfile
	movq %rax, filehandle	

write_to_file:
	movq $SYSWRITE, %rax
	movq filehandle, %rdi
	movq $asciibuffout, %rsi	#Source of bytes to write
	movq %r14, %rdx			#Number of bytes to write
	syscall			

close_output_file:	
	movq $SYSCLOSE, %rax
	movq filehandle, %rdi
	syscall				#Closing file	
	
exit:
	movq $SYSEXIT, %rax
	syscall				#Exiting program

badfile:
	movq %rax, %rbx			#Copy error code to %rbx
	movq $SYSEXIT, %rax
	syscall
