%{
#include<stdio.h>
#include<string.h>
void insert(char* str);
unsigned charCount = 1, idCount = 0, lineCount = 1;
char **symbol_table;
int i, idx, prev;
%}
space [ \t]
eol \n

/* You should write your own regular expression. */
comment \/\*(.|\n)*\*\/|\/\/[^\r\n]*
reserved_word boolean|break|byte|case|char|catch|class|const|continue|default|do|double|else|extends|false|final|finally|float|for|if|implements|int|long|main|new|print|private|protected|public|return|short|static|String|switch|this|true|try|void|while
symbol [\,\:\;\(\)\[\]\{\}\@\?]
string \"([^\\\"\n]|\\\\|\\\"|\\\'|\\n|\\t|\\r|\\0|\\b|\\f)*\"
Invalid_string \"([^\\\n]*\\[^ntr0bf\"][^\\\n]*)+\"|\"[^\" \t\n\r\,\:\;\(\)\[\]\{\}\@\?|\+|\-|\*|\/|\%|\=|\&|\||\!|\<|\>|\^|\~]*|[^\" \t\n\r\,\:\;\(\)\[\]\{\}\@\?|\+|\-|\*|\/|\%|\=|\&|\||\!|\<|\>|\^|\~]*\"
integer [\+\-]?(0x0*[0-9a-fA-F]{1,8}|0+[0-7]{0,11}|[1-9][0-9]{0,9})
Invalid_integer [\+\-]?(0x0*[0-9a-fA-F]{9,}|0+[0-9]{12,}|[1-9][0-9]{10,})
float [\+\-]?([0-9]+(\.[0-9]*)?|\.[0-9]+)([Ee][+-]?[0-9]+)?[Ff]?
Invalid_float [\+\-]?([0-9]+(\.[0-9]*)?|\.[0-9]+)[Ee][\+\-]?[Ff]?
operator \+\+|\+|\-\-|\-|\*|\/|\%|\=\=|\=|\&\&|\|\||\!\=|\!|\<\=|\<|\>\=|\>|\^|\&|\||\~
char \'(\\\'|\\\"|\\|\\n|\\t|\\r|\\0|\\b|\\f|[^\'\\])\'
Invalid_char \'\'\'|\'\'|\'[^\\ ]{2,}\'|\'\\[^ntr0bf]\'
id [A-Za-z_\$][A-Za-z0-9_\$]*
Invalid_id [0-9][A-Za-z0-9_\$]*
Invalid_symbol `|#|\.
%%
{space} {
	charCount++;
}
{eol}   {
	lineCount++;
	charCount = 1;
}
{comment} {
	prev = 1;
	printf("Line: %d, 1st char: %d, \"%s\" is a \"comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
	if(yytext[1] == '*'){
		for(i=0;i<strlen(yytext);i++){
			if(yytext[i] == '\n'){
				lineCount++;
			}
		}
	}
}
{string} {
	prev = 2;
	charCount++;
	printf("Line: %d, 1st char: %d, %s is a \"string\".\n", lineCount, charCount, yytext);
	charCount--;
	charCount += yyleng;
}
{Invalid_string} {
	prev = 0;
	printf("Line: %d, 1st char: %d, %s is an \"invalid string\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{reserved_word} {
	prev = 3;
	printf("Line: %d, 1st char: %d, \"%s\" is a \"reserved word\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{symbol} {
	prev = 4;
	printf("Line: %d, 1st char: %d, \"%s\" is a \"symbol\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{integer} {
	if((yytext[0] == '+') || (yytext[0] == '-')){
		if((prev!=2) && (prev!=5) && (prev!=6) && (prev!=7) && (prev!=9)){
			printf("Line: %d, 1st char: %d, \"%s\" is an \"integer\".\n", lineCount, charCount, yytext);
		}
		else{
			printf("Line: %d, 1st char: %d, \"%c\" is an \"operator\".\n", lineCount, charCount, yytext[0]);
			for(i=0;i<strlen(yytext);i++){
				yytext[i] = yytext[i+1];
			}
			
			printf("Line: %d, 1st char: %d, \"%s\" is an \"integer\".\n", lineCount, charCount+1, yytext);
		}
	}
	else{
		printf("Line: %d, 1st char: %d, \"%s\" is an \"integer\".\n", lineCount, charCount, yytext);
	}
	charCount += yyleng;
	prev = 5;
}
{Invalid_integer} {
	prev = 0;
	printf("Line: %d, 1st char: %d, \"%s\" \"integer number too large\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{float} {
	if((yytext[0] == '+') || (yytext[0] == '-')){
		if((prev!=2) && (prev!=5) && (prev!=6) && (prev!=7) && (prev!=9)){
			printf("Line: %d, 1st char: %d, \"%s\" is a \"float\".\n", lineCount, charCount, yytext);
		}
		else{
			printf("Line: %d, 1st char: %d, \"%c\" is an \"operator\".\n", lineCount, charCount, yytext[0]);
			for(i=0;i<strlen(yytext);i++){
				yytext[i] = yytext[i+1];
			}
			printf("Line: %d, 1st char: %d, \"%s\" is a \"float\".\n", lineCount, charCount+1, yytext);
		}
	}
	else{
		printf("Line: %d, 1st char: %d, \"%s\" is a \"float\".\n", lineCount, charCount, yytext);
	}
	prev = 6;
	charCount += yyleng;
}
{Invalid_float} {
	prev = 0;
	printf("Line: %d, 1st char: %d, \"%s\" is an \"invalid float\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{char} {
	prev = 7;
	printf("Line: %d, 1st char: %d, %s is a \"char\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{Invalid_char} {
	prev = 0;
	printf("Line: %d, 1st char: %d, \"%s\" is an \"invalid char\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{operator} {
	if((prev!=2) && (prev!=5) && (prev!=6) && (prev!=7) && (prev!=9) && ((!strcmp(yytext,"+")) || (!strcmp(yytext,"-")))){
		printf("Line: %d, 1st char: %d, \"%s\" is an \"symbol\".\n", lineCount, charCount, yytext);
	}
	else{
		printf("Line: %d, 1st char: %d, \"%s\" is an \"operator\".\n", lineCount, charCount, yytext);
	}
	prev = 8;
	charCount += yyleng;
}
{id} {
	prev = 9;
	printf("Line: %d, 1st char: %d, \"%s\" is an \"ID\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
	insert(yytext);
}
{Invalid_id} {
	prev = 0;
	printf("Line: %d, 1st char: %d, \"%s\" is an \"invalid id\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{Invalid_symbol} {
	prev = 0;
	printf("Line: %d, 1st char: %d, \"%s\" is an \"Invalid symbol\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
%%
void create(){
	symbol_table=(char **)malloc(10000*sizeof(char *));
    for(i=0;i<10000;i++){
        symbol_table[i]=(char*)malloc(100*sizeof(char));
    }
	idx = 0;
}
int lookup(char* str){
	for(i=0;i<idx;i++){
		if(!strcmp(str,symbol_table[i])){
			return i;
		}
	}
	return -1;
}
void insert(char* str){
	if(lookup(str) == -1){
		strcpy(symbol_table[idx],str);
		idx++;
	}
}
void dump(){
	printf("The symbol table contains:\n");
	for(i=0;i<idx;i++){
		printf("%s\n", symbol_table[i]);
	}
}
int main(){
	create();
	yylex();
	dump();
	return 0;
 }
