/*C declaration*/
%{
	#include<stdio.h>
	#include<math.h>
	
	int value[26],stor[26];
	extern char str[100];
	int ifn=0;
	int eln=0;
	


	void strclean(){
		for(int i=0;i<100;i++)str[i]='\0';
	}

%}

/*Bison declaration*/

%start program //define start
%token Int Float Char STring Lthan Gthan Print assign character 
%token LP3 RP3 If Else IntMain var num STR sm eequal Gequal Lequal
%token add sub mult divi loop aadd ssub oddeve fnum pwr
%nonassoc If
%nonassoc Else
%left add sub
%left divi mult
/* define token type*/


%%

program : IntMain LP3 mcode RP3	{printf("\ncompiled successfully\n");}
		;

mcode :
	|mcode declaration
	|mcode condition
	|mcode statement
	;



declaration: Type var2 sm {printf("\nValid declaration\n");}
		;


Type: Int	{printf("\nIts integer\n");}
	| Float	{printf("\nIts float\n");}
	| Char	{printf("\nIts character\n");}
	;
 var2 : var2 ',' var
	|var 	{ stor[$1]=1;}
	| var assign num 	{ 	
					if(stor[$1] == 1) printf("variable '%c' Redeclared\n",$1+'a');
					else stor[$1]=1;
					value[$1] = $3; 
					printf("%c = %d (declared and assigned)\n",$1+'a',$3);
									}
	;



condition: If expr LP3 Printifcode RP3   {	strclean();
						if($2){
						ifn=0;
						printf("condition is True\n");
						}
						else{
						printf("condintion is False\n");
						eln=1;
						}
 
					     }
		|Else LP3 Printifcode RP3	{
							eln=0;
							strclean();
						}
		;


Printifcode: Printif1
	| Printif1 Printifcode
	;
Printif1: Print STR sm         { if(ifn){ printf("\nPrinting if output: %s\n",str); strclean();}
				else if(eln)
				{ printf("\nPrinting else output: %s\n",str); strclean();}}
	| Print var sm         {if(ifn) printf("\nPrinting Variable value: %c = %d\n",$2+'a',value[$2]);
				else if(eln)
				 printf("\nPrinting Variable value: %c = %d\n",$2+'a',value[$2]);}
	;

statement: sm
        | expr sm 
              
        | var assign expr sm     { 
        				if(stor[$1]!=1)printf("\n'%c' is Undeclared\n",$1+'a');
					else{
						value[$1] = $3;
						printf("\n%c = %d (assigned)\n",$1+'a',$3);
					} 
				        
				}
        |Printcode
        |oddeve expr sm 	{if($2%2==0) printf("even number\n");
        				else printf("odd number\n");}
        |loop var Lthan expr LP3 Print var sm RP3  {int i=value[$2],n=$4;
        						int j=value[$7];
							while(i<n){
							if($2==$7)printf("\nPrinting Variable value3: %d\n",i);
							else printf("\nPrinting Variable value4: %d\n",j);
							i++;
							}} 

	|loop var Gthan expr LP3 Print var sm RP3  {int i=value[$2],n=$4;
        						int j=value[$7];
							while(i>n){
							if($2==$7)printf("\nPrinting Variable value1: %d\n",i);
							else printf("\nPrinting Variable value2: %d\n",j);
							i--;
							}} 
	|loop var Gthan expr LP3 Print STR sm RP3  {int i=value[$2],n=$4;
							while(i>n){
							 printf("\nPrinting output: %s\n",str); strclean();
							i--;
							}} 
	|loop var Lthan expr LP3 Print STR sm RP3  {int i=value[$2],n=$4;
							while(i<n){
							 printf("\nPrinting output: %s\n",str); strclean();
							i++;
							}} 

        ;

expr : var				{ $$ = value[$1]; } 
	| expr add expr		{ $$ = $1 + $3; }
	| expr sub expr		{ $$ = $1 - $3; }								
	| term
	| var Gthan expr 	{$$=$1>$3; if($1>$3)ifn=1;}
	| var Lthan expr 	{$$=$1<$3; if($1<$3)ifn=1;}
	| var eequal expr 	{$$=$1==$3; if($1==$3)ifn=1;}
	| var Lequal expr 	{$$=$1<=$3; if($1<=$3)ifn=1;}
	| var Gequal expr 	{$$=$1>=$3; if($1>=$3)ifn=1;}
	| var aadd 	 	{value[$1]=value[$1]+1;}
	| var ssub 		{value[$1]=value[$1]-1;}
	|var mult expr	{ $$ = $1 * $3; }
	| var divi expr	{ 
					if($3) 
					{
						$$ = $1 / $3;
					}
					else
					{
						$$ = 0;
						printf("\ndivision by zero error occurd\t");
					}
				}
			
	;
			 ;
			 
	
			
term 	: digit					{ $$ = $1; }
	| LP3 expr RP3				{ $$ = $2; }
			;
			
digit 		: num	    			{ $$ = $1; }
		| fnum	    			{ $$ = $1; }
			;


Printcode: Print1
	| Print1 Printcode
	;
Print1: Print STR sm { printf("\nPrinting output: %s\n",str); strclean();}
	| Print var sm {printf("\nPrintin Variable value: %c = %d\n",$2+'a',value[$2]);}
	;


%%
int yywrap(){
	return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}
