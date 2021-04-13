(* user declarations *)

%%

(* required declarations *)

%name Lap

%term CONST of string| IF | THEN | ELSE | AND | OR | XOR
      | EQUALS | TERM | IMPLIES | NOT | ID of string 
      | LPAREN | RPAREN | EOF

%nonterm START of AST.Node | program of AST.Node | statement1 of AST.Node | statement of AST.Node  
        | formula of AST.Node 

%pos int
%eop EOF
%noshift EOF

%right IF THEN ELSE
%right IMPLIES
%left AND OR XOR EQUALS
%right NOT
%nonassoc LPAREN RPAREN CONST ID

%start START
%verbose

%%

START : program                                       (program)

program : statement1                                  (statement1)
        | program statement1                          (statement1)


statement1 : statement TERM                           (statement1)

statement : formula                                   (formula)

formula : CONST                                       (AST.CONSTV(CONST))
        | ID                                          (AST.IDV(ID))
        | formula AND formula                         (AST.ANDV(formula1,formula2))
        | formula OR formula                          (AST.ORV(formula1,formula2))
        | formula XOR formula                         (AST.XORV(formula1,formula2))
        | formula EQUALS formula                      (AST.EQUALSV(formula1,formula2))
        | formula IMPLIES formula                     (AST.IMPLIESV(formula1,formula2))
        | NOT formula                                 (AST.NOTV(formula))
        | LPAREN formula RPAREN                       (formula)
        | IF formula THEN formula ELSE formula        (AST.ITEV(formula1,formula2,formula3))