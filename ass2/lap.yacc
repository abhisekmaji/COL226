(* user declarations *)

%%

(* required declarations *)

%name Lap

%term CONST of string| IF | THEN | ELSE | AND | OR | XOR
      | EQUALS | TERM | IMPLIES | NOT | ID of string 
      | LPAREN | RPAREN | EOF

%nonterm START | program | statement1 | statement 
        | formula

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

START : program                                       ()

program : statement1                                  ()
        | program statement1                          ()


statement1 : statement TERM                           ()

statement : formula                                   ()
          | statement formula                         ()

formula : CONST                                       ()
        | ID                                          ()
        | formula AND formula                         ()
        | formula OR formula                          ()
        | formula XOR formula                         ()
        | formula EQUALS formula                      ()
        | formula IMPLIES formula                     ()
        | NOT formula                                 ()
        | LPAREN formula RPAREN                       ()
        | IF formula THEN formula ELSE formula        ()