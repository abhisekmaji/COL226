
(*----------------------------------------------------------------
this part taken from load-calc.sml file uplaoded by the instructor
and modified some parts accordingly as per my requirement.
-----------------------------------------------------------------*)

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
            TextIO.output(TextIO.stdOut, "Syntax Error:" ^ (Int.toString pos) ^ ":" ^ String.extract(s,22,NONE) ^ "\n")
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

(*------------------------------------------
added more functions below to take print the 
postorder of AST to an output file "out.txt" 
------------------------------------------*)

fun parser (inputfile) =
		let val instrm = TextIO.openIn inputfile
			fun abstract_tree instrm = 
					case TextIO.inputLine instrm of
						SOME line 	=> (let
											val line_parsed = parseString(line)
										in
											line_parsed::abstract_tree instrm
										end
										handle LapParser.ParseError => abstract_tree instrm
									)
					    | NONE		=> []
		in abstract_tree instrm before TextIO.closeIn instrm
		end

fun fileOutput (astlist) = 
			case astlist of
				[] 			=> ""
				|	ast::aststrm	=> AST.post_trav(ast) ^ "\n" ^ (fileOutput aststrm);
                    

fun parse_File (inputfile: string, outputfile: string) = 
	let 
		val abstract_tree = parser inputfile
		val output = fileOutput abstract_tree
		fun printPostOrder (aststrm) =
			let 
				val outstrm = TextIO.openOut outputfile
			in 	
				(TextIO.output (outstrm, aststrm); TextIO.closeOut outstrm) 
			end		
	in printPostOrder (output)
	end