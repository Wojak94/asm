.section .data


.section .bss

.comm asciibuff, 64

.section .text
.type asmfunc @function
.globl asmfunc
asmfunc:
	push %rbp
	push %r13
	push %r14
	push %r15
	movq %rsp, %rbp	
	
	movq $0, %r14				#Register where will store out return value			
	
	movq %rsi, %rcx				#Lenght of the string to %rcx
	movq %rsi, %rdx				#Save value of string length
	movq %rdi, %rsi				#Copy pointer to %rsi
		
	leaq asciibuff, %rdi			#Move address of buff to destination register		
	cld
	rep movsb
	
	movq $1, %rcx	
	movq %rcx, %rax
	movq %rdx, %r13
factorial:
	push %rcx
	movq $0, %r15
	dec %r13				#%r13 is set to the position number of last sign in asciibuff
	mov asciibuff(,%r13,1), %r15b		#Copy ascii sign to %r15
	sub $'0', %r15b

mul:
	cmp $1, %rcx
	je end	
	dec %rcx
	mulq %rcx
	jmp mul
end:	
	mulq %r15
	addq %rax, %r14
	pop %rcx
	inc %rcx
	movq %rcx, %rax
	cmp $0, %r13
	jne factorial
	
	movq %r14, %rax

	movq %rbp, %rsp
	pop %r15
	pop %r14
	pop %r13
	pop %rbp
	ret
		


