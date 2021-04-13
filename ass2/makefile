main : lap.yacc.sml lap.lex.sml
	clear
	rlwrap sml

lap.yacc.sml : lap.yacc
	ml-yacc lap.yacc

lap.lex.sml : lap.lex
	ml-lex lap.lex

clean:
	rm lap.yacc.*
	rm lap.lex.*
