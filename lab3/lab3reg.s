.section .data

SYSEXIT = 60
FIRST_NUMBER = -1	
SECOND_NUMBER = -2
N_INDEX = 7
				#Index of desired number


.section .text
.globl _start
_start:
	movq $N_INDEX, %r11		#Ni value to the stack 
	push %rax
	movq $FIRST_NUMBER, %r12	#N1 value to the stack 
	push %rax
	movq $SECOND_NUMBER,  %r13	#N2 value to the stack 
	push %rax	
	movq $3, %r14			#N-index of result number
	push %rax
	movq $0, %r15			#Iteration counter used for calculating offset
	call recursive	
exit:
	movq $SYSEXIT, %rax
	syscall				#Exiting program

recursive:
	push %rbp
	movq %rsp, %rbp	
	push %r13	
	imul %r12, %r13				
 	pop %r12		
	cmp %r14, %r11			#Check if thats the final index
	je end
	inc %r14	
	inc %r15

	movq %rbp, %rsp
	pop %rbp	
	call recursive
end:	
	cmp $-1,%r15
	je end2
	movq %rbp, %rsp
	pop %rbp
	movq $-1, %r15
end2:
	ret
