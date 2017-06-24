.section .data

.section .bss

.comm control, 2

.section .text
.type checkprec @function
.type changeprec @function
.globl checkprec, changeprec


checkprec:

	push %rbp
	movq %rsp, %rbp
	
	fstcw control
	movq $0, %rax
	movw control, %ax
	and $0x0003, %ax	
	

	movq %rbp, %rsp
	pop %rbp	
	ret
changeprec:

	push %rbp
	movq %rsp, %rbp
	
	fstcw control
	movw control, %ax
	or $0x0003, %ax
	cmp $0, %rdi
	jne dbl
	xor $0x0003, %ax		#single precision
	jmp end
dbl:
	cmp $1, %rdi
	jne dblx
	xor $0x0001, %ax		#double precision
	jmp end
dblx:
	cmp $2, %rdi	
	xor $0x0, %ax			#double-ex precision	
end:
	movw %ax, control
	fldcw control	

	movq %rbp, %rsp
	pop %rbp
	ret
