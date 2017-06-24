.section .data

SYSEXIT = 60
FIRST_NUMBER = -1	
SECOND_NUMBER = -2

N_INDEX = 6				#Index of desired number


.section .text
.globl _start
_start:
	movq $N_INDEX, %rax		#Ni value to the stack 
	push %rax
	movq $FIRST_NUMBER, %rax	#N1 value to the stack 
	push %rax
	movq $SECOND_NUMBER,  %rax	#N2 value to the stack 
	push %rax	
	movq $3, %rax			#N-index of result number
	push %rax
	movq $0, %r15			#Iteration counter used for calculating offset
	call recursive
	movq 8(%rsp), %rbx
exit:
	movq $SYSEXIT, %rax
	syscall				#Exiting program

recursive:
	push %rbp
	movq %rsp, %rbp	
	movq 32(%rbp,%r15,8), %rax	#N(i-2) in %rax
	movq 24(%rbp,%r15,8), %rbx	#N(i-1) in %rbaxs
	imul %rbx, %rax			#Result is now in %rax	
	movq %rbx, 32(%rbp,%r15,8)	#Copy N(i-1) to N(i-2)
 	movq %rax, 24(%rbp,%r15,8)	#Result is now N(i-1)	
	movq 16(%rbp,%r15,8), %rbx	#Copy index of current result in %rax	
	cmp %rbx, 40(%rbp,%r15,8)	#Check if thats the final index
	je end
	inc %rbx
	movq %rbx, 16(%rbp,%r15,8)	#Update current index of result
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
