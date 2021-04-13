signature AST = sig
    datatype Node = LPARENV
            |   RPARENV
            |   IDV of string            
            |   TERMV
            |	CONSTV of string
            |	NOTV of Node
            |	ANDV of Node * Node
            |	ORV of Node * Node
            |	XORV of Node * Node
            |	EQUALSV of Node * Node
            |	IMPLIESV of Node * Node
            |	ITEV of Node * Node * Node
    val post_trav : Node -> string
end  
  
structure AST : AST =
	struct
		datatype Node = LPARENV
            |   RPARENV
            |   IDV of string            
            |   TERMV
            |	CONSTV of string
            |	NOTV of Node
            |	ANDV of Node * Node
            |	ORV of Node * Node
            |	XORV of Node * Node
            |	EQUALSV of Node * Node
            |	IMPLIESV of Node * Node
            |	ITEV of Node * Node * Node

		fun postOrder (LPARENV) 		= (" LPAREN")
        |	postOrder (RPARENV) 		= (" RPAREN")
        |	postOrder (CONSTV(s)) 		= ("(") ^ (s) ^ ("--> CONST") ^ (")")
        |   postOrder (TERMV)           = ("(") ^ (" TERM") ^ (")") 
		|	postOrder (IDV(s)) 	        = ("(") ^ (s) ^ ("--> ID") ^ (")") 
		|	postOrder (NOTV(a)) 		= ("(") ^ postOrder (a) ^ ("--> NOT") ^ (")")
		|	postOrder (ANDV(a,b))	    = ("(") ^ postOrder (a) ^ (" * ") ^ postOrder (b) ^ ("--> AND") ^ (")")
		|	postOrder (ORV(a,b))		= ("(") ^ postOrder (a) ^ (" * ") ^ postOrder (b) ^ ("--> OR") ^ (")")
        |	postOrder (XORV(a,b))		= ("(") ^ postOrder (a) ^ (" * ") ^ postOrder (b) ^ ("--> XOR") ^ (")")
        |	postOrder (EQUALSV(a,b))	= ("(") ^ postOrder (a) ^ (" * ") ^ postOrder (b) ^ ("--> EQUALS") ^ (")")
		|	postOrder (IMPLIESV(a,b))	= ("(") ^ postOrder (a) ^ (" * ") ^ postOrder (b) ^ ("--> IMPLIES") ^ (")")
		|	postOrder (ITEV(a,b,c))	    = ("(") ^ postOrder (a) ^ (" * ") ^ postOrder (b) ^ (" * ") ^ postOrder (c) ^ ("--> IF-THEN-ELSE") ^ (")");


        val post_trav = postOrder;
end;