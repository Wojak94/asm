#include <stdio.h>
#include <stdlib.h>


extern int checkprec();
extern void changeprec(int setprec);

int main(){
	int action, precision;
	do{
	
	printf("Wybierz akcje: \n1 - Sprawdź precyzję\n2 - Zmień precyzję\n");
	scanf("%d", &action);
	system("clear");	
	switch(action){
	case 1:
		precision = checkprec();
		switch(precision){
			case 0:
				printf("Aktualna precyzja: Single-precision\n\n");
				break;
			case 1:
				printf("Aktualna precyzja: Not used\n\n");
				break;
			case 2:
				printf("Aktualna precyzja: Double-precision\n\n");
				break;
			case 3:
				printf("Aktualna precyzja: Double-extended-precision\n\n");
				break;
			default:
				printf("???");
				break;
			}
		break;
	case 2:
		printf("Wybierz precyzje: \n0 - Single-precision\n1 - Double-precision\n2 - Double-extended-precision\n");
		scanf("%d", &action);
		switch(action){
		case 0:
			changeprec(action);
			break;			
		case 1:
			changeprec(action);
			break;
		case 2:
			changeprec(action);
			break;		
		break;		
	default:
		printf("Niepoprawna opcja\n");
		return 0;
		}
	}		
	}while(action != 9);
	return 0;
}
