/*C declarations*/


number [0-9]



%{
	#include <stdio.h>
 
	#include "Mycom.tab.h"

	extern int yylval;
	
	char str[100];
	char charval[3];

%}




%%
"dig"	{ return Int;}
"dec"	{return Float;}
"byte"	{return Char;}
{number}+	{yylval = atoi(yytext);
			return num; }
[+-]?([0-9]*[.])?[0-9]+		{printf(yytext);	return fnum;}
"gofor"  {printf("loop");return loop;}
"+*"	return aadd;
"-*"	return ssub;
"oddeve"	{return oddeve;}


"["		return LP3;
"]"		return RP3;
"/"		return sm;
","		return(*yytext);

"#"		return add;
"--"	return sub;
"&"		return mult;
"|"		return divi;
"<-"	return assign;
"="		return eequal;
"=>"	return Gequal;
"=<"	return Lequal;
">>"	return Gthan;
"<<"	return Lthan;
"out"	return Print;



"\""[a-zA-Z]([ a-z]+|[A-Z]+|[!]+)+"\"" {
				
				for(int i=0;i<yyleng-2;i++) str[i] = yytext[i+1];
				return STR;
			}
[a-z]	{ yylval = *yytext-'a';
			return var;
			}

"is"	{return If;}
"no"	{return Else;}
"dig prime"	{return IntMain;}

[ \t\n]*	;

"!!"(.)*"\n"	printf("This is a single comment\n");
"!+"(.|\n)*"+!"		printf("This is a multi comment");
.	{
		yyerror("Character not recognized\n");
		printf(yytext);
	}

%%


int main()
{
	printf("\nThis is a Compiler made by Asif\n");
	yyin = freopen("input.txt","r",stdin);
	yyparse();
}


