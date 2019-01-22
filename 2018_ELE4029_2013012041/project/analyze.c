/****************************************************/
/* File: analyze.c                                  */
/* Semantic analyzer implementation                 */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "analyze.h"
#include "util.h"

/* counter for variable memory locations */
static int location = 0;
static char * scope = "~";

char * getNewScope(TreeNode * t)
{ char *result = NULL;
  if (t->nodekind == StmtK)
  { if (t->kind.stmt == CompK)
    { result = (char *)malloc(sizeof(char) * (strlen(scope) + 12));
      sprintf(result, "%s:%d\0", scope, t->lineno);
    }
  }
  else if(t->nodekind == DeclK)
  {
    if (t->kind.dec == FuncK)
    { result = (char *)malloc(sizeof(char) * (strlen(scope) + strlen(t->attr.name)+3));
      sprintf(result, "%s:%s", scope, t->attr.name);
    }
  }
  if (result == NULL)
  { result = (char *)malloc(sizeof(char) * (strlen(scope) + 2));
    strcpy(result, scope);
  }
  return result;
}

/* Procedure traverse is a generic recursive 
 * syntax tree traversal routine:
 * it applies preProc in preorder and postProc 
 * in postorder to tree pointed to by t
 */
static void traverse( TreeNode * t,
               void (* preProc) (TreeNode *),
               void (* postProc) (TreeNode *) )
{ if (t != NULL)
  { 
    preProc(t);
    { int i;
      char * scopeBackup = scope;
      int locationBackup = location;
      scope = getNewScope(t);
      location = 0;

      for (i=0; i < MAXCHILDREN; i++)
        traverse(t->child[i],preProc,postProc);

      free(scope);
      scope = scopeBackup;
      location = locationBackup;
    }
    postProc(t);
    traverse(t->sibling,preProc,postProc);
  }
}

/* nullProc is a do-nothing procedure to 
 * generate preorder-only or postorder-only
 * traversals from traverse
 */
static void nullProc(TreeNode * t)
{ if (t==NULL) return;
  else return;
}

/* Procedure insertNode inserts 
 * identifiers stored in t into 
 * the symbol table 
 */
static void insertNode( TreeNode * t)
{ switch (t->nodekind)
  { case DeclK:
      switch (t->kind.dec)
      { case FuncK:
          if (st_lookup(scope,t->attr.name) == NULL)
          /* not yet in table, so treat as new definition */
            st_insert(scope,t->attr.name,t->type,t->lineno,location++);
          else
          /* already in table, so ignore location, 
             add line number of use only */ 
            //st_insert(t->attr.name,t->lineno,0);
            fprintf(listing, "error:%d: %s is already declared\n", t->lineno, t->attr.name);
          break;
        case VarK:
        case VarArrK:
          if (t->attr.name != NULL && st_lookup_excluding_parent(scope,t->attr.name) == NULL)
          {
          /* not yet in table, so treat as new definition */
            st_insert(scope,t->attr.name,t->type,t->lineno,location++);
            if(t->kind.exp == VarArrK)
              location += t->child[0]->attr.val - 1;
          }
          else if(t->attr.name != NULL)
          /* already in table, so ignore location, 
             add line number of use only */ 
            //st_insert(t->attr.name,t->lineno,0);
            fprintf(listing, "error:%d: %s is already declared\n", t->lineno, t->attr.name);
          break;
        default:
          break;
      }
      break;
    case ParamK:
      switch (t->kind.param)
      {
        case SinParamK:
        case ArrParamK:
          if (t->attr.name != NULL && st_lookup_excluding_parent(scope,t->attr.name) == NULL)
          {
          /* not yet in table, so treat as new definition */
            st_insert(scope,t->attr.name,t->type,t->lineno,location++);
            if(t->kind.exp == VarArrK)
              location += t->child[0]->attr.val - 1;
          }
          else if(t->attr.name != NULL)
          /* already in table, so ignore location, 
             add line number of use only */ 
            //st_insert(t->attr.name,t->lineno,0);
            fprintf(listing, "error:%d: %s is already declared\n", t->lineno, t->attr.name);
          break;
        default:
          break;
      }
      break;
    case ExpK:
      switch (t->kind.exp)
      { 
        case IdK:
        case CallK:
          if (st_lookup(scope,t->attr.name) == NULL)
            fprintf(listing, "error:%d: %s is not declared\n", t->lineno, t->attr.name);
          else
            addline(scope,t->attr.name,t->lineno,0);
          break;
        default:
          break;
      }
      break;
    default:
      break;
  }
}

void insertBuiltinFunctions(TreeNode ** syntaxTree)
{ TreeNode *input = newDeclNode(FuncK);
  input->sibling = *syntaxTree;
  *syntaxTree = input;
  input->lineno = 0;
  input->attr.name = malloc(sizeof(char) * (strlen("input") + 1));
  strcpy(input->attr.name, "input");
  input->type = Integer;

  TreeNode *output = newDeclNode(FuncK);
  output->sibling = *syntaxTree;
  *syntaxTree = output;
  output->lineno = 0;
  output->attr.name = malloc(sizeof(char) * (strlen("output") + 1));
  strcpy(output->attr.name, "output");
  output->type = Void;

  TreeNode *param = newParamNode(SinParamK);
  param->type = Integer;
  param->attr.name = malloc(sizeof(char) * (strlen("arg") + 1));
  strcpy(param->attr.name, "arg");
  param->lineno = 0;

  output->child[0] = param;
}

/* Function buildSymtab constructs the symbol 
 * table by preorder traversal of the syntax tree
 */
void buildSymtab(TreeNode * syntaxTree)
{ insertBuiltinFunctions(&syntaxTree);
  traverse(syntaxTree,insertNode,nullProc);
  if (TraceAnalyze)
  { fprintf(listing,"\nSymbol table:\n\n");
    printSymTab(listing);
  }
}

static void typeError(TreeNode * t, char * message)
{ fprintf(listing,"Type error at line %d: %s\n",t->lineno,message);
  Error = TRUE;
}

/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(TreeNode * t)
{ switch (t->nodekind)
  { 
    case DeclK:
      switch (t->kind.dec)
      {
        case FuncK:
            break;
        case VarK:
        case VarArrK:
          if (t->type == Void)
            typeError(t, "variable can not be void type");
          break;
        default:
          break;
      }
    case ExpK:
      switch (t->kind.exp)
      { BucketList bucket;
        case OpK:
          break;
        case ConstK:
          break;
        case IdK:
          break;
        case CallK:
          break;
        case AssignK:
          if (t->child[1]->kind.exp == IdK || t->child[1]->kind.exp == CallK)
          { bucket = st_lookup(scope, t->child[1]->attr.name);
            if (bucket->type != Integer)
              typeError(t->child[1], "rvalue must be integer type");
          }
          else if (t->child[1]->type != Integer)
            typeError(t->child[1], "rvalue must be integer type");
          break;
        default:
          break;
      }
      break;
    case StmtK:
      switch (t->kind.stmt)
      { char *tmp;
        BucketList l;
        case IfK:
          break;
        case CompK:
          break;
        case IteK:
          break;
        case RetK:
          tmp = (char *)malloc(sizeof(char) * (strlen(scope) + 1));
          strcpy(tmp, scope);
          strtok(tmp, ":");
          char *functionName = strtok(NULL, ":");
          l = st_lookup("~", functionName);
          if (l == NULL)
          { char *tmp;
            tmp = (char *)malloc(sizeof(char) * (strlen(functionName) + strlen("there is no ") + 1));
            sprintf(tmp, "%s%s", "there is no %s", functionName);
            typeError(t, tmp);
            free(tmp);
          }
          else if (l->type != Integer)
            typeError(t, "Void function can not return a value");
          free(tmp);
          break;
        default:
          break;
      }
      break;
    default:
      break;

  }
}

/* Procedure typeCheck performs type checking 
 * by a postorder syntax tree traversal
 */
void typeCheck(TreeNode * syntaxTree)
{ traverse(syntaxTree,nullProc,checkNode);
}
