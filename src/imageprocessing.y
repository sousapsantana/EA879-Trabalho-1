%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>

void yyerror(char *c);
int yylex(void);
float vmax;

%}
%union {
  char    strval[50];
  int     ival;
}
%token <strval> STRING
%token <ival> VAR IGUAL EOL ASPA ACOL FCOL
%token FLOAT 
%left SOMA PRODUTO DIVISAO

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    | STRING IGUAL STRING {
        printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
    }
    | STRING IGUAL STRING PRODUTO FLOAT {
    	printf ("produto\n");
    }
    | STRING IGUAL STRING DIVISAO FLOAT {
    	printf ("divisao\n");
    }    
    | ACOL STRING FCOL {
    	printf ("maximo\n");
    	imagem I = abrir_imagem ($2);
    	vmax = vmax_imagem (&I);
    	printf ("Valor máximo: %.2f\n", vmax);
    }

    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
