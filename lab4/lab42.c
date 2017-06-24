#include <stdio.h>
#include <string.h>

extern int asmfunc(char *string, int len);

int main(int argc, char *argv[]){
	
	int result = 0;
	int len = strlen(argv[1]);	

	result = asmfunc(argv[1], len);
	printf("Wartość tej liczby to: %d\n", result);	

	return 0;
}
