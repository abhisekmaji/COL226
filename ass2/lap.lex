structure Tokens = Tokens
  
  type pos = int
  type svalue = Tokens.svalue
  type ('a,'b) token = ('a,'b) Tokens.token  
  type lexresult = (svalue, pos) token

val beg = ref true
val pos = ref 1
val col = ref 1
val eof = fn () => (beg:= true;col:=1;print("]\n");Tokens.EOF(!pos, !pos))
val error = fn (e, l:int, c:int) => TextIO.output(TextIO.stdOut,"\n Unknown Token:" ^ (Int.toString l) ^ ":" ^ (Int.toString c) ^ ":" ^ e ^ "\n")
fun inc a =(a := !a + 1;!a)

%%
%header (functor LapLexFun(structure Tokens:Lap_TOKENS));
alpha = [A-Za-z];

%%

"\n"                => (col:= 1;pos := (!pos) +1; lex());
[\ \t]              => (col:= !col+1;lex());
";"                 => (col:= !col+1;
                        if !beg then (beg := false;print("TERM \""^yytext^"\""))
                        else print(", TERM \""^yytext^"\"");
                        Tokens.TERM(!pos,!pos));
"TRUE"              => (col:= !col+4;
                        if !beg then (beg := false;print("CONST \""^yytext^"\""))
                        else print(", CONST \""^yytext^"\"");
                        Tokens.CONST(yytext,!pos,!pos));
"FALSE"             => (col:= !col+5;
                        if !beg then (beg := false;print("CONST \""^yytext^"\""))
                        else print(", CONST \""^yytext^"\"");
                        Tokens.CONST(yytext,!pos,!pos));
"NOT"               => (col:= !col+3;
                        if !beg then (beg := false;print("NOT \""^yytext^"\""))
                        else print(", NOT \""^yytext^"\"");
                        Tokens.NOT(!pos,!pos));
"AND"               => (col:= !col+3;
                        if !beg then (beg := false;print("AND \""^yytext^"\""))
                        else print(", AND \""^yytext^"\"");
                        Tokens.AND(!pos,!pos));
"OR"                => (col:= !col+2;
                        if !beg then (beg := false;print("OR \""^yytext^"\""))
                        else print(", OR \""^yytext^"\"");
                        Tokens.OR(!pos,!pos));
"XOR"               => (col:= !col+3;
                        if !beg then (beg := false;print("XOR \""^yytext^"\""))
                        else print(", XOR \""^yytext^"\"");
                        Tokens.XOR(!pos,!pos));
"IMPLIES"           => (col:= !col+7;
                        if !beg then (beg := false;print("IMPLIES \""^yytext^"\""))
                        else print(", IMPLIES \""^yytext^"\"");
                        Tokens.IMPLIES(!pos,!pos));
"EQUALS"            => (col:= !col+6;
                        if !beg then (beg := false;print("EQUALS \""^yytext^"\""))
                        else print(", EQUALS \""^yytext^"\"");
                        Tokens.EQUALS(!pos,!pos));
"IF"                => (col:= !col+2;
                        if !beg then (beg := false;print("IF \""^yytext^"\""))
                        else print(", IF \""^yytext^"\"");
                        Tokens.IF(!pos,!pos));
"THEN"              => (col:= !col+4;
                        if !beg then (beg := false;print("THEN \""^yytext^"\""))
                        else print(", THEN \""^yytext^"\"");
                        Tokens.THEN(!pos,!pos));
"ELSE"              => (col:= !col+4;
                        if !beg then (beg := false;print("ELSE \""^yytext^"\""))
                        else print(", ELSE \""^yytext^"\"");
                        Tokens.ELSE(!pos,!pos));
"("                 => (col:= !col+1;
                        if !beg then (beg := false;print("LPAERN \""^yytext^"\""))
                        else print(", LPAERN \""^yytext^"\"");
                        Tokens.LPAREN(!pos,!pos));
")"                 => (col:= !col+1;
                        if !beg then (beg := false;print("RPAREN \""^yytext^"\""))
                        else print(", RPAREN \""^yytext^"\"");
                        Tokens.RPAREN(!pos,!pos));
{alpha}+            => (col:= !col+(size yytext);
                        if !beg then (beg := false;print("ID \""^yytext^"\""))
                        else print(", ID \""^yytext^"\"");
                        Tokens.ID(yytext,!pos,!pos));
.                   => (error(yytext,!pos,!col);col:= !col+(size yytext);lex());