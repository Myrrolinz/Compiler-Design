%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
struct symbol {//定义结构体，有name和value两个属性，用来存放标识符
	char* name;
	double value;
};
struct symbol sample[10];

int isUMINUS = 1;
int index_of_symbol = 0;

#ifndef YYSTYPE
#define YYSTYPE struct symbol
#endif


char idStr[50];//用来存放变量名
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}


%token NUM
%token NAME
%token ADD
%token SUB
%token MUL
%token DEV
%token LB
%token RB
%token EQUAL

%left ADD SUB
%left MUL DEV
%right UMINUS

%%

lines	:	lines expr ';' { printf("%f\n", $2.value);}
	|	lines ';'
	|
	;

 expr	: 	expr ADD expr { $$.value = $1.value + $3.value; }
	| 	expr SUB expr { $$.value = $1.value - $3.value; }
	|	expr MUL expr { $$.value = $1.value * $3.value; }
	|	expr DEV expr { $$.value = $1.value / $3.value; }
	|	LB expr RB { $$ = $2; }
	| 	UMINUS expr %prec UMINUS { $$.name = $2.name; $$.value = -$2.value; }
	|	NUM { $$ = $1; }
	|	NAME { $$ = $1; }
	|	NAME EQUAL expr { sample[index_of_symbol].name = (char*)malloc(50*sizeof(char));strcpy(sample[index_of_symbol].name, $1.name);sample[index_of_symbol].value = $3.value;index_of_symbol+=1;$$.value = sample[index_of_symbol].value; }
	;	//把变量的name和value值放入sample数组中


%%

// programs section
int isdigit(int t){
	if(t>='0' && t<='9')return 1;
	else return 0;
}

int isletter(int t){
	if((t>='a' && t<='z') || (t>='A' && t<='Z'))return 1;
	else return 0;
}

int yylex()
{
	int temp;
	while(1){
		temp = getchar();
		if(temp==' '||temp=='\t'||temp=='\n'){
			//nothing to do
		}
		else if(isdigit(temp)==1){//处理数字串的情况
			yylval.value = 0;
			yylval.name = "";
			while(isdigit(temp)==1){
				yylval.value = yylval.value*10 + temp - '0';
				temp=getchar();
			}
			isUMINUS = 0;//数字之后的-不是单目运算符
			ungetc(temp, stdin);
			return NUM;
		}
		else if(isletter(temp)==1||(temp=='_')){//处理字符串的情况
			int indexTemp = 0;
			while(isletter(temp)==1||(temp=='_')||(isdigit(temp)==1)){
				idStr[indexTemp]=temp;//存放变量名
				temp=getchar();
				indexTemp++;
			}
			idStr[indexTemp]='\0';
			yylval.name = idStr;//yylval赋值
			for(int i=0;i<index_of_symbol;i++){
				if(!strcmp(sample[i].name, yylval.name)) {
					yylval.value = sample[i].value;
					break;
				}
			}
			isUMINUS = 0;//变量名之后的-不是运算符
			ungetc(temp, stdin);		
			return NAME;
		}
		else if(temp=='+')return ADD;
		else if(temp=='-'){
			if(isUMINUS == 1) return UMINUS;
			else {
				isUMINUS = 1;
				return SUB;
			}			
		}
		else if(temp=='*')return MUL;
		else if(temp=='/')return DEV;
		else if(temp=='(')return LB;
		else if(temp==')')return RB;
		else if(temp=='=')return EQUAL;
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
