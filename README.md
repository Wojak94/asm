# OiAK Laboratory
This repository contains programs written in x86_64, GAS syntax Assembler, during OiAK course labs. There is also some C parts, due to combining both languages in one project. There is pdf report of each laboratory in all folders.

## Lab 2 
Program loads two integer numbers in octal notation from txt files, saves them to memory buffers in little endian format, then adds them together with CF flag and 64 bit register. Result is saved to output txt file in hexadecimal notation.

## Lab 3
There are two programs that realize recursive function that computes desired sequence element. First program passing arguments using stack, second uses registers.

## Lab 4
First program loads integer number with scanf function, then passes it to recursive function written in C that computes n-th sequence element. That function returns number in double format, which is printed to terminal using printf function.
Second program is written in C using function written in assembler which computes value of passed number in artificial positional notation in which value of n-th positioned number equals x * n!. For example: 555 = 5 * 3! + 5 * 2! + 5 * 1!.

## Lab 5
First program checks and changes precision of x87 FPU calculations. Menu and user interaction interface are written in C, functions manipulating FPU precision in assembler.
Second program is using assembler function to compute value of e^x using FPU stack, which is calculated using following transformation:
![xd](http://latex.codecogs.com/gif.latex?e^x&space;=&space;2&space;^{x\log&space;_{2}e}).
