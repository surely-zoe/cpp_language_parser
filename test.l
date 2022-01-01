%{
#include "test.tab.h"
int yycolumn=1,last_column;
int s=0;
#define YY_USER_ACTION yycolumn+=yyleng;

typedef struct Table {
    char name[100];
    char type[100];
    int row,col;
} Table;
 
typedef struct lnode {
    Table entry;
    struct lnode* next;
} lnode;
 
lnode* sym_tbl[100];
int hash(char name[]) {
    int k = 0;
    for (int i = 0; name[i] != '\0'; i++) {
        k += name[i];
    }
    return (k % 100);
}
 
lnode* search(char name[]) {
    int idx = hash(name);
    for (lnode* node = sym_tbl[idx]; node != NULL; node = node->next) {
        if (strcmp(name, node->entry.name) == 0) {
            return node;
        }
    }
    return NULL;
}
 
void insert(char name[], char type[],int row,int col) {
	if (search(name) != NULL || strcmp(name,"\n")==0 || strcmp(name," ")==0 || strcmp(name,"\t")==0) {return;}
    int idx = hash(name);
    lnode* new_node = (lnode*)malloc(sizeof(lnode));
    int i;
    strcpy(new_node->entry.name,name);
    if(s==0)
       strcpy(new_node->entry.type,type);
    else{
    	strcpy(new_node->entry.type,"FUNCTION");
    	s=0;
    }
    new_node->entry.row=row;
    new_node->entry.col=col;
    new_node->next = NULL;
   
    if (sym_tbl[idx] == NULL) {
        sym_tbl[idx] = new_node;
        return;
    }
    lnode* node = NULL;
    for (node = sym_tbl[idx]; node->next != NULL; node = node->next);
    node->next = new_node;
}

%}

%option yylineno bison-locations bison-bridge
%%
"main" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return MAIN;}
"(" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return OB;}
")" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return CB;}
"{" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return OFB;}
"}" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return CFB;}
"," {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return COMMA;}
";" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return SC;}
"=" {insert(yytext,"assignmen",yylineno,yycolumn-yyleng);return EQU;}
"==" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return EQQ;}
"!=" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return NEQU;}
"!" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return NOT;}
"<=" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return LT;}
">=" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return GT;}
">" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return G;}
"<" {insert(yytext,"reloperator",yylineno,yycolumn-yyleng);return L;}
"[" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return OSB;}
"]" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return CSB;}
"++" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return PPLUS;}
"--" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return MMINUS;}
"+=" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return PEQU;}
"-=" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return SEQU;}
"*=" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return MEQU;}
"/=" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return DEQU;}
"+" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return PLUS;}
"-" {insert(yytext,"operator",yylineno,yycolumn-yyleng);return MINUS;}
"*"	{insert(yytext,"operator",yylineno,yycolumn-yyleng);return MUL;}
"/"	{insert(yytext,"operator",yylineno,yycolumn-yyleng);return DIV;}
"%"	{insert(yytext,"operator",yylineno,yycolumn-yyleng);return MOD;}
"int" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return INT;}
"char" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return CHAR;}
"float" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return FLOAT;}
"double" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return DOUBLE;}
"bool" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return BOOL;}
"short" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return SHORT;}
"long" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return LONG;}
"signed" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return SIGNED;}
"unsigned" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return UNSIGNED;}
"for" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return FOR;}
"while" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return WHILE;}
"do" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return DO;}
"if" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return IF;}
"else" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return ELSE;}
"switch" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return SWITCH;}
"case" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return CASE;}
"default" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return DEFAULT;}
"break" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return BREAK;}
"struct" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return STRUCT;}
"static" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return STATIC;}
"private" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return PRIVATE;}
"public" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return PUBLIC;}
"protected" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return PROTECTED;}
"class" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return CLASS;}
"return" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return RETURN;}
"void" {insert(yytext,"keyword",yylineno,yycolumn-yyleng);return VOID;}
"." {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return DOT;}
":" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return COLON;}
"\"" {insert(yytext,"symbol",yylineno,yycolumn-yyleng);return DQ;}
[0-9]+ {insert(yytext,"constant",yylineno,yycolumn-yyleng);return NUM;}
[a-zA-Z][a-zA-Z0-9]* {insert(yytext,"identifier",yylineno,yycolumn-yyleng);return ID;}
\n { last_column=yycolumn;yycolumn=1;}
%%
int yywrap(){
    printf(" %s 	 %s 	%s 	 %s	 %s \n\n", "INDEX","NAME", "TYPE", "ROW", "COL");
    for (int c = 0; c < 100; ++c) {

        if (sym_tbl[c] != NULL) {
            for (lnode* node = sym_tbl[c]; node != NULL; node = node->next) {
                printf("%d  %s  %s  %d  %d \n", c,node->entry.name,node->entry.type,node->entry.row,node->entry.col);
            printf("\n");
            }
        }
    }
	return 1;
}
int yyerror(char* msg,YYLTYPE yyloc){
    if(strcmp(yytext,"\n")!=0)
        printf("\n Error on line : %d and column %d %s \n",yylineno,yycolumn-yyleng,msg);
    else
        printf("\n Error on line : %d and column %d %s \n",yylineno,last_column-2,msg);
    exit(1);
}