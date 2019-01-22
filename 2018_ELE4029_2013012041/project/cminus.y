/****************************************************/
/* File: cminus.y                                   */
/* The TINY Yacc/Bison specification file           */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"

#define YYSTYPE TreeNode *
static char * savedName; /* for use in assignments */
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */
static int yylex(void); // added 11/2/11 to ensure no conflict with lex
char *nameStack[10];
int nameStackIndex = 0;
char* nameStackPop();
int lineStack[10];
int lineStackIndex = 0;
int lineStackPop();
%}

%token IF ELSE WHILE RETURN INT VOID
%token ID NUM
%token EQ NE LT LE GT GE LPAREN RPAREN LBRACE RBRACE LCURLY RCURLY SEMI
%token ERROR 
%left PLUS MINUS TIMES OVER COMMA
%right ASSIGN

%% /* Grammar for C- */

program             : dec_list
                         { savedTree = $1; } 
                    ;
dec_list            : dec_list dec
                         { YYSTYPE t = $1;
                           if (t != NULL)
                             { while (t->sibling != NULL)
                                  t = t->sibling;
                               t->sibling = $2;
                               $$ = $1; }
                           else $$ = $2;
                         }
                    | dec { $$ =$1; }
                    ;
dec                 : var_dec { $$ = $1; }
                    | func_dec { $$ = $1; }
                    ;
var_dec             : type_spec ID SEMI
                         { $$ = newDeclNode(VarK);
                           $$->type = (ExpType)$1;
                           $$->attr.name = nameStackPop();
                           $$->lineno = lineStackPop();
                         }
                    | type_spec ID LBRACE size RBRACE SEMI
                         { $$ = newDeclNode(VarArrK);
                           $$->type = (ExpType)$1;
                           $$->attr.name = nameStackPop();
                           $$->lineno = lineStackPop();
                           $$->child[0] = $4;
                         }
                    ;
size                : NUM
                         { $$ = newExpNode(ConstK);
                           $$->type = Integer;
                           $$->attr.val = atoi(tokenString);
                           $$->lineno = lineno;
                         }
                    ;
type_spec           : INT { $$ = Integer; }
                    | VOID { $$ = Void; }
                    ;
func_dec            : type_spec ID LPAREN params RPAREN comp_stmt
                         { $$ = newDeclNode(FuncK);
                           $$->type = (ExpType)$1;
                           $$->attr.name = nameStackPop();
                           $$->lineno = lineStackPop();
                           $$->child[0] = $4;
                           $$->child[1] = $6;
                         }
                    ;
params              : param_list { $$ = $1; }
                    | VOID
                         { $$ = newParamNode(SinParamK);
                           $$->type = Void;
                           $$->lineno = lineno;
                         }
                    ;
param_list          : param_list COMMA param
                         { YYSTYPE t = $1;
                           if (t != NULL)
                           { while (t->sibling != NULL)
                                t = t->sibling;
                             t->sibling = $3;
                             $$ = $1; }
                             else $$ = $3;
                         }
                    | param { $$ = $1; }
                    ;
param               : type_spec ID
                         { $$ = newParamNode(SinParamK);
                           $$->type = (ExpType)$1;
                           $$->attr.name = nameStackPop();
                           $$->lineno = lineStackPop();
                         }
                    | type_spec ID LBRACE RBRACE
                         { $$ = newParamNode(ArrParamK);
                           $$->type = (ExpType)$1;
                           $$->attr.name = nameStackPop();
                           $$->lineno = lineStackPop();
                         }
                    ;
comp_stmt           : LCURLY local_dec stmt_list RCURLY
                         { $$ = newStmtNode(CompK);
                           $$->child[0] = $2;
                           $$->child[1] = $3;
                           //$$->lineno = $2->lineno;
                         }
                    ;
local_dec           : local_dec var_dec
                         { YYSTYPE t = $1;
                           if (t != NULL)
                           { while (t->sibling != NULL)
                                t = t->sibling;
                             t->sibling = $2;
                             $$ = $1; }
                             else $$ = $2;
                         }
                    | empty { $$ = $1; }
                    ;
stmt_list           : stmt_list stmt
                         { YYSTYPE t = $1;
                           if (t != NULL)
                           { while (t->sibling != NULL)
                                t = t->sibling;
                             t->sibling = $2;
                             $$ = $1; }
                             else $$ = $2;
                         }
                    | empty { $$ = $1; }
                    ;
stmt                : exp_stmt { $$ = $1; }
                    | comp_stmt { $$ = $1; }
                    | sel_stmt { $$ = $1; }
                    | ite_stmt { $$ = $1; }
                    | ret_stmt { $$ = $1; }
                    ;
exp_stmt            : exp SEMI { $$ = $1;}
                    | SEMI { $$ = NULL; }
                    ;
sel_stmt            : IF LPAREN exp RPAREN stmt
                         { $$ = newStmtNode(IfK);
                           $$->child[0] = $3;
                           $$->child[1] = $5;
                           $$->lineno = $3->lineno;
                         }
                    | IF LPAREN exp RPAREN stmt ELSE stmt
                         { $$ = newStmtNode(IfK);
                           $$->child[0] = $3;
                           $$->child[1] = $5;
                           $$->child[2] = $7;
                           $$->lineno = $3->lineno;
                         }
                    ;
ite_stmt            : WHILE LPAREN exp RPAREN stmt
                         { $$ = newStmtNode(IteK);
                           $$->child[0] = $3;
                           $$->child[1] = $5;
                           $$->lineno = $3->lineno;
                         }
                    ;
ret_stmt            : RETURN SEMI { $$ = newStmtNode(RetK);}
                    | RETURN exp SEMI
                         { $$ = newStmtNode(RetK);
                           $$->child[0] = $2;
                           $$->lineno = $2->lineno;
                         }
                    ;
exp                 : var ASSIGN exp
                         { $$ = newExpNode(AssignK);
                           $$->type = Integer;
                           $$->child[0] = $1;
                           $$->child[1] = $3;
                           $$->lineno = $1->lineno;
                         }
                    | simple_exp { $$ = $1; }
                    ;
var                 : ID
                         { $$ = newExpNode(IdK);
                           $$->type = Integer;
                           $$->attr.name = nameStackPop();
                           $$->lineno = lineStackPop();
                         }
                    | ID LBRACE exp RBRACE
                         { $$ = newExpNode(IdK);
                           $$->attr.name = nameStackPop();
                           $$->child[0] = $3;
                           $$->lineno = lineStackPop();
                         }
                    ;
simple_exp          : add_exp relop add_exp
                         { $$ = newExpNode(OpK); 
                           $$->type = Integer;
                           $$->child[0] = $1;
                           $$->child[1] = $3;
                           $$->attr.op = $2;
                           $$->lineno = $1->lineno;
                         }
                    | add_exp
                         { $$ = $1; }
                    ;
relop               : LE { $$ = LE; }
                    | LT { $$ = LT; }
                    | GT { $$ = GT; }
                    | GE { $$ = GE; }
                    | EQ { $$ = EQ; }
                    | NE { $$ = NE; }
                    ;
add_exp             : add_exp addop term
                         { $$ = newExpNode(OpK);
                           $$->type = Integer;
                           $$->child[0] = $1;
                           $$->child[1] = $3;
                           $$->attr.op = $2;
                           $$->lineno = $1->lineno;
                         }
                    | term { $$ = $1; }
                    ;
addop               : PLUS { $$ = PLUS; }
                    | MINUS { $$ = MINUS; }
                    ;
term                : term mulop factor
                         { $$ = newExpNode(OpK);
                           $$->type = Integer;
                           $$->child[0] = $1;
                           $$->child[1] = $3;
                           $$->attr.op = $2;
                           $$->lineno = $1->lineno;
                         }
                    | factor { $$ = $1; }
                    ;
mulop               : TIMES { $$ = TIMES; }
                    | OVER { $$ = OVER; }
                    ;
factor              : LPAREN exp RPAREN
                         { $$ = $2; }
                    | var { $$ = $1; }
                    | call { $$ = $1; }
                    | NUM
                         { $$ = newExpNode(ConstK);
                           $$->type = Integer;
                           $$->attr.val = atoi(tokenString);
                           $$->lineno = lineno;
                         }
                    ;
call                : ID LPAREN args RPAREN
                         { $$ = newExpNode(CallK);
                           $$->attr.name = nameStackPop();
                           $$->child[0] = $3;
                           $$->lineno = lineStackPop();
                         }
                    ;
args                : arg_list
                         { $$ = $1; }
                    | empty
                         { $$ = $1; }
                    ;
arg_list            : arg_list COMMA exp
                         { YYSTYPE t = $1; 
                           if (t != NULL)
                           { while (t->sibling != NULL)
                                t = t->sibling;
                             t->sibling = $3;
                             $$ = $1; }
                             else $$ = $3;
                         }
                    | exp
                         { $$ = $1; }
                    ;
empty               : { $$ = NULL;}
                    ;

%%

int yyerror(char * message)
{ fprintf(listing,"Syntax error at line %d: %s\n",lineno,message);
  fprintf(listing,"Current token: ");
  printToken(yychar,tokenString);
  Error = TRUE;
  return 0;
}

/* yylex calls getToken to make Yacc/Bison output
 * compatible with ealier versions of the TINY scanner
 */
static int yylex(void)
{ TokenType token = getToken();
  if (token == ID)
  { nameStackPush(copyString(tokenString));
    lineStackPush(lineno); }
  return token;
}

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}

void nameStackPush(char *name)
{ nameStack[nameStackIndex++] = name; }

char* nameStackPop()
{ return nameStack[--nameStackIndex]; }

void lineStackPush(int line)
{ lineStack[lineStackIndex++] = line; }

int lineStackPop()
{ return lineStack[--lineStackIndex]; }
