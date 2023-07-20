%{//定义段
#include<stdio.h>
#include<stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double// YYSTYPE 用于确定 $$ 变量类型由于需要返回的是简单表达式计算结果，因此可定义为double类型
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUM
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
//$$ 代表产生式左部的属性值，$n 为产生式右部第 n 个 token 的属性值，注意运算符等终结符也计算其中，即，不止非终结符有属性值，终结符也有属性值。括号内为语义动作
lines	:	lines expr ';' { printf("%f\n", $2);}
	|	lines ';'
	|	//以分号结束而不是以回车结束，这样就可以实现由词法分析忽略回车。
	;
//yylval 是 Yacc 自动定义的全局变量。yacc 会将 yylval 隐式赋值给终结符的属性值，所以在语义动作中不需要显式地执行 $$ = yylval 的操作。
 expr	: 	expr ADD expr { $$ = $1 + $3; }
	| 	expr SUB expr { $$ = $1 - $3; }
	|	expr MUL expr { $$ = $1 * $3; }
	|	expr DEV expr { $$ = $1 / $3; }
	|	LB expr RB { $$ = $2; }
	|	SUB expr %prec UMINUS { $$ = -$2; }
	|	NUM
	;


%%

// programs section
int isdigit(int t){
	if(t=='0'||t=='1'||t=='2'||t=='3'||t=='4'||t=='5'||t=='6'||t=='7'||t=='8'||t=='9')return 1;
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
		else{
		if(isdigit(temp)==1){
			yylval=0;
			while(isdigit(temp)==1){
				yylval=yylval*10+temp-'0';
				temp=getchar();//ungetc 函数作用是将读出的多余字符再次放回到缓冲区去, 下一次读数字符进行下一个单词的识别时, 会再次读出来的。
			}
			ungetc(temp, stdin);
			return NUM;
		}
		if(temp=='+')return ADD;
		if(temp=='-')return SUB;
		if(temp=='*')return MUL;
		if(temp=='/')return DEV;
		if(temp=='(')return LB;
		if(temp==')')return RB;
		return temp;
		}
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
