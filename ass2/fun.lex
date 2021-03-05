structure Tokens = Tokens
  
  type pos = int
  type svalue = Tokens.svalue
  type ('a,'b) token = ('a,'b) Tokens.token  
  type lexresult = (svalue, pos) token

val pos = ref 0
val eof = fn () => EOF

fun inc a =(a := !a + 1;!a)

%%
%header (functor CalcLexFun(structure Tokens:mlyacc_TOKENS));
alpha = [A-Za-z];

%%

"\n"                => (pos := (!pos) +1; lex());
[\ \t]              => (lex());
";"                 => (print(yytext);Tokens.TERM(!pos,!pos));
"TRUE"              => (print(yytext);Tokens.CONST(!pos,!pos));
"FALSE"             => (print(yytext);Tokens.CONST(!pos,!pos));
"NOT"               => (print(yytext);Tokens.NOT(!pos,!pos));
"AND"               => (print(yytext);Tokens.AND(!pos,!pos));
"OR"                => (print(yytext);Tokens.OR(!pos,!pos));
"XOR"               => (print(yytext);Tokens.XOR(!pos,!pos));
"IMPLIES"           => (print(yytext);Tokens.IMPLIES(!pos,!pos));
"IF"                => (print(yytext);Tokens.IF(!pos,!pos));
"THEN"              => (print(yytext);Tokens.THEN(!pos,!pos));
"ELSE"              => (print(yytext);Tokens.ELSE(!pos,!pos));
"("                 => (print(yytext);Tokens.LPAREN(!pos,!pos));
")"                 => (print(yytext);Tokens.RPAREN(!pos,!pos));
{alpha}+            => (print(yytext);Tokens.ID(yytext,!pos,!pos));
.                   => (lex());