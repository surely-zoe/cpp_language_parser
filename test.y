%{
	#include<stdio.h>
	#include<stdlib.h>
	int yylex();
	void yyerror();
	int yylineno;
	extern int last_column;
	extern FILE *yyin;
%}
%locations
%define parse.error verbose
%token MAIN OB CB OFB CFB SC INT CHAR COMMA OSB CSB EQU IF ID NUM ELSE WHILE
FOR DO EQQ NEQU LT GT G L PLUS MINUS MUL DIV MOD SWITCH CASE DEFAULT COLON
DQ BREAK PPLUS MMINUS NOT PEQU SEQU MEQU DEQU STRUCT STATIC FLOAT DOUBLE BOOL 
SHORT LONG SIGNED UNSIGNED CLASS PRIVATE PUBLIC PROTECTED DOT RETURN VOID
%%
program : declarations program
		 | STRUCT ID OFB structmem CFB idlist SC program
		 | STRUCT ID OFB structmem CFB SC program
		 | methoddef program
		 | class program
		 | app
app :MAIN OB CB OFB statlist CFB
;
class : CLASS ID ext OFB pvt pub pro CFB SC 
;
ext : COLON accspec ID idext
		|
;
idext : COMMA accspec ID idext
		|
;
accspec : PRIVATE
		 | PUBLIC
		 | PROTECTED
		 |
;		  				
pvt : PRIVATE COLON member 
	  | member
;	
pub : PUBLIC COLON member
	 |	 
;
pro : PROTECTED COLON member	 
	  |
;
member : dtype a1 member
		| ID OB paramlist CB methterm member
		|
;
a1 : OSB CSB ID OB paramlist CB methterm
	 | ID OB paramlist CB methterm
	 | idlist SC 
;
structmem : STATIC declarations structmem
			| asstat SC structmem
			| declarations structmem
			| methoddef structmem
			|
;
methoddef : dtype OSB CSB ID a2
			| dtype ID a2
;
a2 : OB paramlist CB methterm
	  | COLON COLON ID OB paramlist CB OFB statlist CFB 
;
methterm : OFB statlist CFB 
			| SC
;			
paramlist : paramlistext
			|
paramlistext : dtype ID
			| ID ID
			| dtype ID COMMA paramlistext
			| ID ID COMMA paramlistext
			| dtype ID EQU ID 
			| dtype ID EQU constants
			| dtype ID EQU ID COMMA paramlistext
			| dtype ID EQU constants COMMA paramlistext
			| ID ID EQU ID
			| ID ID EQU constants 
			| ID ID EQU ID COMMA paramlistext
			| ID ID EQU constants COMMA paramlistext
;
dtype : sign a3
		| CHAR
		| FLOAT
		| DOUBLE
		| BOOL
;
a3 : INT
	  |SHORT INT
	  | LONG INT
	  | LONG LONG INT
;	  
sign : SIGNED
	   | UNSIGNED
	   |
;	
idlist : ID idlistext
	    | ID OSB NUM CSB idlistext
;
idlistext : COMMA ID idlistext
	  | COMMA ID OSB NUM CSB idlistext
	  |
;
statlist : stat statlist 
			|
;
stat :  declarations
		| unarystat SC
		| asstat SC 
		| decstat
		| loopstat
		| switchblock
		| BREAK SC
		| methcall SC
		| RETURN rval SC
;
rval : ID 
		| constants
		|
;
methcall : ID OB arglist CB 
;
arglist : ID argext
		 |
;
argext : COMMA ID argext 
		| 
;
unarystat : unaryop ID 
			| ID unaryop
;
unaryop : PPLUS
		  | MMINUS
;		
unaryexpn : unaryop ID 
			| ID unaryop
			| NOT ID
;
declarations : dtype a4
			   | ID a4 				
;
a4 : ID EQU expn a5 
		| ID a5 
		| ID OSB NUM CSB a5 
a5 : SC 
	  | COMMA ID EQU expn a5
	  | COMMA ID a5
	  | COMMA ID OSB NUM CSB a5 
;
asstat : ID a6
;
a6 : assign expn
	  | DOT ID assign expn
;
assign : EQU
		| PEQU
		| SEQU
		| MEQU
		| DEQU
;
expn : unaryexpn 
	   | methcall
	   | ID DOT methcall
	   | sexpn eprime
;
eprime : relop sexpn
		|
;
sexpn : term seprime
		|
;
seprime : addop term seprime
			|
;
term : factor tprime
;
tprime : mulop factor tprime
		|
;
factor : ID
		| NUM
;
decstat : IF OB expn CB OFB statlist CFB dprime
;
dprime : ELSE OFB statlist CFB 
		|
;
switchblock : SWITCH OB expn CB OFB caseb defaultb CFB
;
caseb : CASE constants COLON statlist casebext
;
casebext : caseb 
			|
;
defaultb : DEFAULT COLON statlist
			|
;
constants : NUM	
			| DQ ID DQ
loopstat : WHILE OB expn CB OFB statlist CFB 
			| FOR OB asstat SC expn SC asstat CB OFB statlist CFB 											
			| DO OFB statlist CFB WHILE OB expn CB SC
;
relop : EQQ 
		| NEQU
		| LT 
		| GT
		| G
		| L		
;
addop : PLUS
		| MINUS
;
mulop : MUL 
		| DIV
		| MOD
;
%%
void main()
{
	yyin = fopen("input.txt","r");
	do{
		if(yyparse()){
			exit(0);
		}
	}while(!feof(yyin));
	printf("success\n");     
}
