datatype lexresult = EOF | TERM | CONST | NOT | AND | OR | XOR | EQUALS
                | IMPLIES | IF | THEN | ELSE | LPAREN | RPAREN | ID of string


type pos = int (* Position in file *)
val linenum = ref 1
val eof = fn () => EOF

fun inc a =(a := !a + 1,!a)

%%

alpha = [A-Za-z];

%%
"\n" => (inc linenum; lex());
[\ \t] => (lex());
";" => (TERM);
"TRUE" => (CONST);
"FALSE" => (CONST);
"NOT" => (NOT);
"AND" => (AND);
"OR" => (OR);
"XOR" => (XOR);
"IMPLIES" => (IMPLIES);
"IF" => (IF);
"THEN" => (THEN);
"ELSE" => (ELSE);
"(" => (LPAREN);
")" => (RPAREN);
{alpha}+ => (ID yytext);
. => (lex());