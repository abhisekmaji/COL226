(* user declarations *)

%%

(* required declarations *)

%name parse

%term CONST | IF | THEN | ELSE | AND | OR | XOR
      | EQUALS | TERM | IMPLIES | NOT | ID of string 
      | LPAREN | RPAREN

%nonterm program | statement | formula | formulaA | formula1
      | formula2 | formula3 | formula4 | binop

%pos int
%eop EOF
%noshift EOF

%right IMPLIES
%left AND OR XOR EQUALS
%right NOT

%start program
%verbose

%%

program : statement1                                  (statement)
        | statement1 statement1                       ()

statement1 : statement TERM                           ()

statement : formula0                                  (formula)
          | formula0 formula0                         ()

formula0 : formula                                    ()

formula : IF formula THEN formula                     ()
        | IF formula THEN formula1 ELSE formula       ()
        | formula2                                    ()

formula1 : IF formula THEN formula1 ELSE formula1     ()
         | formula2

formula2 : CONST                                      (cons)
         | ID                                         ()
         | NOT formula                                (no(formula))
         | formula binop formula                      (bin(formula1,formula2))
         | formula IMPLIES formula                    (imp(formula,formula))
         | IF formula                                 (ift(formula1,formula2,formula3))
          THEN formula
          ELSE formula
         | LPAREN formula RPAREN                      ()

binop : AND                                           (an)
      | OR                                            (o)
      | XOR                                           (xo)
      | EQUALS                                        (eqs)