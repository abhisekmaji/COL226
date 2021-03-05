(* user declarations *)

%%

(* required declarations *)

%name parse

%term CONST | IF | THEN | ELSE | AND | OR | XOR
      | EQUALS | TERM | IMPLIES | NOT | ID of string 
      | LPAREN | RPAREN | EOF

%nonterm start | program | statement1 | statement 
        | formula | formula1 | formula2
        | formula3 | formula4 | formula5 | binop

%pos int
%eop EOF
%noshift EOF

%right IMPLIES
%left AND OR XOR EQUALS
%right NOT

%start start
%verbose

%%

start : program                                       ()

program : statement1                                  ()
          | program statement1                        ()


statement1 : statement TERM                           ()

statement : formula                                   ()
          | statement formula                         ()

formula : IF formula THEN formula                     ()
        | IF formula THEN formula1 ELSE formula       ()
        | formula2                                    ()

formula1 : IF formula THEN formula1 ELSE formula1     ()
         | formula2                                   ()

formula2 : formula3 IMPLIES formula2                  ()
          | formula3                                  ()

formula3 : formula3 binop formula4                    ()
          | formula4                                  ()

formula4 : NOT formula4                               ()
          | formula5                                  ()

formula5 : LPAREN formula RPAREN                      ()
          | CONST                                     ()
          | ID                                        ()

binop : AND                                           ()
      | OR                                            ()
      | XOR                                           ()
      | EQUALS                                        ()