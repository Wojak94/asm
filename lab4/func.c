double f(int steps, double n1, double n2);

double f(int steps, double n1, double n2){
	double result;
	
	result = n1 * n2;
	n1 = n2;
	n2 = result;
	steps--;
	if(steps > 0){result = f(steps, n1, n2);}
	
	return result;	
}
