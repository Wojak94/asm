all: lab4 lab42

lab4: lab4.o func.o
	ld -o lab4 -dynamic-linker /lib64/ld-linux-x86-64.so.2 func.o lab4.o -lc 
lab4.o: lab4.s
	as -gstabs lab4.s -o lab4.o
func.o: func.c
	gcc -c func.c

lab42: lab42.c lab42.o
	gcc -g -o lab42 lab42.c lab42.o
lab42.o: lab42.s
	as -gstabs -o lab42.o lab42.s
	


