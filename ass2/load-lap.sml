structure LapLrVals = LapLrValsFun(structure Token = LrParser.Token)
structure LapLex = LapLexFun(structure Tokens = LapLrVals.Tokens);
structure LapParser =Join(
        structure LrParser = LrParser
        structure ParserData = LapLrVals.ParserData
        structure Lex = LapLex
        )

fun invoke lexstream =
        let 
            fun print_error (s,pos:int,_) =
            TextIO.output(TextIO.stdOut, "Error, line " ^ (Int.toString pos) ^ "," ^ s ^ "\n")
		in
            print("[");
		    LapParser.parse(0,lexstream,print_error,())
		end

fun stringToLexer str =
    let 
        val done = ref false
    	val lexer=  LapParser.makeLexer (fn _ => if (!done) then "" else (done:=true;str))
    in
	lexer
    end	
		
fun parse (lexer) =
    let val dummyEOF = LapLrVals.Tokens.EOF(0,0)
    	val (result, lexer) = invoke lexer
	val (nextToken, lexer) = LapParser.Stream.get lexer
    in
        if LapParser.sameToken(nextToken, dummyEOF) then result
 		else (TextIO.output(TextIO.stdOut, "Warning: Unconsumed input \n"); result)
    end

val parseString = parse o stringToLexer