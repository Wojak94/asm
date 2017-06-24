.section .data

SYSEXIT = 60
formatd: .asciz "%d"
formatf: .asciz "%f \n"
decimal: .long 0
flt: .double 0
n1: .double 1.5
n2: .double 2.5

.extern f

.section .text
.globl _start
_start:
 	movq $0, %rax    		#clear rax (passing 0 float arguments)
    	movq $formatd, %rdi    		#load format string
   	movq $decimal, %rsi    		#set storage to address of x
    	call scanf
	movq $2, %rax    		#2 floating point arguments
	movq $0, %rdi    		#clear rdi
	movl decimal, %edi
	movsd n1, %xmm0
	movsd n2, %xmm1
	call f
	movsd %xmm0, flt
	movq $1, %rax    		#one float number as argument
    	movq $formatf, %rdi    		#load format string
    	call printf
	addq $8, %rsp
    	movq $SYSEXIT, %rax
	syscall				#Exiting program
