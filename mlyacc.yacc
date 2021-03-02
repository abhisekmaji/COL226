

%%

%eop EOF

%right NOT
%left AND OR XOR EQUALS
%right IMPLIES
%right IF THEN ELSE

%term CONST | IF | THEN | ELSE | AND | OR | XOR
            | EQUALS | TERM
%nonterm program | statement | formula | binop

% name pro
%start program

%%

program : statement

statement : formula TERM

formula : CONST
        | NOT formula
        | formula binop formula
        | formula IMPLIES formula
        | IF formula
          THEN formula
          ELSE formula

binop : AND
      | OR
      | XOR
      | EQUALS