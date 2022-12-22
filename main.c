#include <stdio.h>
extern void _main(void);
extern int _putc(int c);
extern char _int_to_ascii(int r);

int print_args(char x1){
	char aux = x1;
	int tam = 0;
	while (aux > 0){
	aux = aux/10;
	tam++;
	}
	char vet[tam];
	for(int i = 0; i < tam; i++){
	vet[i] = (x1 % 10)+48;
	x1= x1 / 10;
	
	}
	for(int i = tam-1; i >=0; i--){
	_putc(vet[i]);
	}
	
	
	return 0;
}

int main(char* vetor, int tam, char flag){

char mask = 1;
char cont = 0;

/********************************************************/
/*ordena*/

int vet_aux[tam];

for (int i = 0; i < tam; i++)
{
	vet_aux[i] = vetor[i];
	if (mask & flag)
	{
		vet_aux[i]*=(-1);
		cont++;
	}
	mask*=2;

}

    int i , j , key;
    for (j = 1; j < tam ; j++)
    {
        key = vet_aux[j];
        i = j-1;
        while(i >= 0 && vet_aux[i] > key){ 
            vet_aux[i+1] = vet_aux[i];
            i--;
        }
        vet_aux[i+1] = key;
        }


	for (int i = 0; i < tam; i++)
{

	if(vet_aux[i] < 0)
		vet_aux[i] *=(-1);
	vetor[i] = vet_aux[i];

}









/********************************************************/
	
/*	for(int i=0; i<tam; i++){
	
	}*/
	mask = 1;

	_putc(123);
	for(int i=0; i<tam; i++){
		if(cont>0){
			_putc(45);
			cont--;
		}
		mask *= 2;
		print_args(vetor[i]);
		if(i != tam-1){
			_putc(44);
			_putc(32);
		}
	}
	_putc(125);
	return 0;
}
