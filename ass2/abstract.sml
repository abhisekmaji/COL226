(*signature AST = sig
    datatype Prop = LPARENV
            |   RPARENV
            |   IDV of string            
            |   TERMV
            |	CONSTV of string
            |	NOTV of Prop
            |	ANDV of Prop * Prop
            |	ORV of Prop * Prop
            |	XORV of Prop * Prop
            |	EQUALSV of Prop * Prop
            |	IMPLIESV of Prop * Prop
            |	ITEV of Prop * Prop * Prop
    val post_trav : Prop -> string
end *) 
  
structure AST : AST =
	struct
		datatype Prop = LPARENV
            |   RPARENV
            |   IDV of string            
            |   TERMV
            |	CONSTV of string
            |	NOTV of Prop
            |	ANDV of Prop * Prop
            |	ORV of Prop * Prop
            |	XORV of Prop * Prop
            |	EQUALSV of Prop * Prop
            |	IMPLIESV of Prop * Prop
            |	ITEV of Prop * Prop * Prop

		fun postOrder (LPARENV) 		= (" LPAREN")
        |	postOrder (RPARENV) 		= (" RPAREN")
        |	postOrder (CONSTV(s)) 		= (s) ^ (" CONST")
        |   postOrder (TERMV)           = (" TERM")
		|	postOrder (IDV(s)) 	        = (s) ^ (" ID") 
		|	postOrder (NOTV(a)) 		= postOrder (a) ^ (" NOT")
		|	postOrder (ANDV(a,b))	    = postOrder (a) ^ (" ") ^ postOrder (b) ^ (" AND")
		|	postOrder (ORV(a,b))		= postOrder (a) ^ (" ") ^ postOrder (b) ^ (" OR")
        |	postOrder (XORV(a,b))		= postOrder (a) ^ (" ") ^ postOrder (b) ^ (" XOR")
        |	postOrder (EQUALSV(a,b))	= postOrder (a) ^ (" ") ^ postOrder (b) ^ (" EQUALS")
		|	postOrder (IMPLIESV(a,b))	= postOrder (a) ^ (" ") ^ postOrder (b) ^ (" IMPLIES")
		|	postOrder (ITEV(a,b,c))	    = postOrder (a) ^ (" ") ^ postOrder (b) ^ (" ") ^ postOrder (c) ^ (" IF-THEN-ELSE");


        val post_trav = postOrder;
end;