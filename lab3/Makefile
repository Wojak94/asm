all: lab3 lab3reg

lab3: lab3.o
	ld lab3.o -o lab3
lab3.o: lab3.s
	as -gstabs lab3.s -o lab3.o

lab3reg: lab3reg.o
	ld lab3reg.o -o lab3reg
lab3reg.o: lab3reg.s
	as -gstabs lab3reg.s -o lab3reg.o

