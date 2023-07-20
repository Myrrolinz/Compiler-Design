%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idStr[50];
char numStr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUM
%token ID
%token ADD
%token SUB
%token MUL
%token DEV
%token LB
%token RB

%left ADD SUB
%left MUL DEV
%right UMINUS

%%

lines	:	lines expr ';' { printf("%s\n", $2);}
	|	lines ';'
	|
	;

 expr	: 	expr ADD expr { $$ = (char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"+ "); }
	| 	expr SUB expr { $$ = (char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"- "); }
	|	expr MUL expr { $$ = (char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"* "); }
	|	expr DEV expr { $$ = (char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"/ "); }
	|	UMINUS expr %prec UMINUS { $$ = (char *)malloc(50*sizeof(char));strcpy($$,"-"); strcat($$,$2); }
	|	LB expr RB {$$ = (char *)malloc(50*sizeof(char));strcpy($$,$2); }
	|	NUM {$$ = (char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
	|	ID {$$ = (char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
	;


%%

// programs section
int isdigit(int t){
	if(t=='0'||t=='1'||t=='2'||t=='3'||t=='4'||t=='5'||t=='6'||t=='7'||t=='8'||t=='9')return 1;
	else return 0;
}

int isletter(int t){
	if((t>='a' && t<='z') || (t>='A' && t<='Z'))return 1;
	else return 0;
}


int isUMINUS = 1;
int yylex()
{
	int temp;
	while(1){
		temp = getchar();
		if(temp==' '||temp=='\t'||temp=='\n'){
			//nothing to do
		}
		else if(isdigit(temp)==1){ //遇到数字串的情况
			int indexTemp=0;
			while(isdigit(temp)==1){
				numStr[indexTemp]=temp;
				temp=getchar();
				indexTemp++;
			}
			numStr[indexTemp]='\0';
			yylval=numStr;//串地址赋值给yylval
			if(temp == '-')
				isUMINUS = 0;//之后的不会是单目-
			ungetc(temp, stdin);
			return NUM;
		}
		//思路为当读到一个字符为字母或下划线时，连续读接下来的字符，直到出现一个不是数字或字母或下划线的字符停止，调用 ungetc 函数将读出的非数字非字母非下
		//划线字符放回缓冲区，将读到的若干字符存为一个字符串，将这个字符串的地址赋给 yylval
		else if(isletter(temp)==1||(temp=='_')){//遇到字符串的情况
			int indexTemp=0;
			while(isletter(temp)==1||(temp=='_')||(isdigit(temp)==1)){
				idStr[indexTemp]=temp;
				temp=getchar();
				indexTemp++;
			}
			idStr[indexTemp]='\0';
			yylval=idStr;
			if(temp == '-')//下一个读到的为-。由于在运算式中且前面不是(,则不是单目运算-
				isUMINUS = 0;
			ungetc(temp, stdin);
			return ID;
		}
		else if(temp=='+')return ADD;
		else if(temp=='-'){
			if(isUMINUS==1){
				isUMINUS = 1;
				return UMINUS;
			}
			else {
				isUMINUS = 1;//isUMINUS重新置1
				return SUB;
			}
		}
		else if(temp=='*')return MUL;
		else if(temp=='/')return DEV;
		else if(temp=='(')return LB;
		else if(temp==')')return RB;
		else return temp;
	}
}

int main()
{
	yyin = stdin;
	do{
		yyparse();
	}while(!feof(yyin));
	return 0;
}

void yyerror(const char* s){
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
