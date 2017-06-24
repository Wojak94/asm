.section .data

x:	.long 0
y:	.double 2.718281828459

.section .text

.type exfunc @function
.globl exfunc

exfunc:
	push %rbp
	movq %rsp, %rbp
	
	movq %rdi, x

	finit
	fildl x
	fldl y
	fyl2x
	fld1
	fld %st(1)
	fprem
	f2xm1
	faddp
	fscale
	fxch %st(1)
	fstp %st
	fstp y
	movsd y, %xmm0

	movq %rbp, %rsp
	pop %rbp
	ret 
