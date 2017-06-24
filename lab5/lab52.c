#include <stdio.h>
#include <stdlib.h>

extern float exfunc(int x);

int main(int argc, char *argv[]){
	
	int x;
	float result;
	
	x = atoi(argv[1]);
	result = exfunc(x);

	printf("Wynik dla x = %d wynosi: %f\n", x, result);
	
	return 0;
}
