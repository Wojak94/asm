#cpuid.s Sample program to extract proc ID
.data
output:
	.ascii "The processor Vendor ID is 'xxxxxxxxxxxx'\n"
.text
.globl _start
_start:
	movq $0, %rax
	cpuid
	movq $output, %rdi
	movq %rbx, 28(%rdi)
	movq %rdx, 32(%rdi)
	movq %rcx, 36(%rdi)
	movq $1, %rax		#syswrite
	movq $1, %rdi		#stdout
	movq $output, %rsi	#wskaźnik na tekst
	movq $42, %rdx		#długość tekstu
	syscall
	movq $1, %rax
	movq $60, %rdi
	syscall
