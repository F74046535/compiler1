/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>

	/* Symbol table function */
	void create_symbol();
	void insert_symbol();
	int lookup_symbol();
	void dump_symbol();
        int lines=0;
        int num1=0;
        int num2=0;
        int num3=0;
        int check1=0;
        int check2=0;
        int arr[5];
        int i=0;
        int vn=0;
        int vch=0;
        char ID[10];
        char Type[10];
        char to;
        int fi=0;
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
number {digit}+
       
/* Rules section */
%%
"int"     {
            printf("int TYPE VAR\n");
            printf("Insert a symbol %c\n",to);
            insert_symbol(2);
            if(vn==1)
            {
              printf("Create a symbol table\n");
            }
          }
"var"     {vn++;vch=1;}
"/*"      {printf("%s\t",yytext);num2=lines;check2=1;}
"*/"      {printf("%s\t",yytext);num3=lines+1;check2=2;arr[i]=num3-num2;i++;}
"//"      {printf("%s\t",yytext);num1++;check1=1;}
"else"    {printf("%s\t ELSE\n",yytext);}
"println" {printf("%s \t PRINTLN function\n",yytext);}
"for"   { printf("%s \t FOR function\n",yytext);}
"print" {printf("%s\t PRINT function\n",yytext);}
"if"    {printf ("%s\t IF function\n",yytext);}
"+" 	{ printf("%s \t Add \n", yytext); }
"-"	{ printf("%s \t Sub \n", yytext); }
{id}	{if(check1==1&&check2==0)
          {
             printf("%s\t",yytext);
          }
         if(check2==1&&check1==0)
          {
             printf("%s\t",yytext);
          }
          if(check1==0&&check2==0)
           { 
               if(vn==1)
               {
                   create_symbol();
               }
               if(vch==1)
               {
                   printf("%s \t",yytext);
                   insert_symbol(1);
                   to=yytext[0];
                   vch=0;
               }
               else
               {
                   printf("%s \t ID \n", yytext);
                   if(lookup_symbol()==1)
                   {
                         fi++;
                   }
               }
           } 
         }
\n	{lines++;
          if(check1==1)
          {
            check1=0;
            printf("c++ comment\n");
          }
          if(check2==2)
          {
             check2=0;
             printf("c++ comment\n");
          }
          
        }
{number}  {printf("%s \t Number\n",yytext);}
"*"     {
           if(check2==1)
           {
            
           }
           else
           {
             printf("%s \t Multiply \n",yytext);
           }
         }
"/"     {printf("%s \t Devide \n",yytext);}
"%"     {printf("%s \t Remainder \n",yytext);}
"++"    {printf("%s \t Increment \n",yytext);}
"--"    {printf("%s \t decrement \n",yytext);}
"="     {printf("%s \t Assign \n",yytext);}
"+="    {printf("%s \t Add assign\n",yytext);}
"-="    {printf("%s \t Sub assign\n",yytext);}
"*="    {printf("%s \t Mul assign\n",yytext);}
"/="    {printf("%s \t Div assign\n",yytext);}
"%="    {printf("%s \t Modulo assign\n",yytext);}
"<"     {printf("%s \t Less than\n",yytext);}
">"     {printf("%s \t More than\n",yytext);}
"<="    {printf("%s \t Less than or equal to\n",yytext);}
">="    {printf("%s \t More than or equal to\n",yytext);}
"=="    {printf("%s \t Equal to\n",yytext);}
"!="    {printf("%s \t Not equal tp\n",yytext);}
"&&"    {printf("%s \t Logical and\n",yytext);}
"||"    {printf("%s \t Logical or \n",yytext);}
"!"     {printf("%s \t Logical negation\n",yytext);}
"("     {printf("%s \t LB \n",yytext);}
")"     {printf("%s \t RB \n",yytext);}
"{"     {printf("%s \t LCB \n",yytext);}
"}"     {printf("%s \t RCB \n",yytext);}
%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

void create_symbol() 
{
    int i;
    for(i=0;i<10;i++)
    {
         ID[i]='\0';
         Type[i]='\0';
    }
}
void insert_symbol(int type) 
{
      if(type==1)
      {
          ID[vn-1]=yytext[0];
      }
      if(type==2)
      {
         // printf("Insert a symbol:%s\n",yytext); 
          Type[vn-1]=yytext[0];
      }
}
int lookup_symbol() 
{
    int c;
    for(c=0;c<5;c++)
    {
      if(ID[c]==yytext[0])
      {
           return 0;
      }
      else
      {
           return 1;
      }
    }

}
void dump_symbol() 
{
   printf("the symbol table dump\n");
   for(i=0;i<vn;i++)
   {
       printf("%d\t %c\t",i,ID[i]);
       if(Type[i]=='i')
       {
         printf("int\n");
       }
          
   }
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
        printf("Parse over,the lines numbers is %d\n",lines);
        int j;
        int total=0;
        for(j=0;j<5;j++)
        {
           total+=arr[j];
        }
        total=total+num1;
        printf("comment %d lines\n",total);
	dump_symbol();
        if(fi!=0)
        {
            printf("Note:there are variable not define!\n");
        }
	return 0;
}
