exception emptyInputFile
exception UnevenFields of int * int * int
exception IncorrectNewline
exception doubleQuotesError
exception fieldNotEnclosed

fun convertDelimiters(infilename, delim1, outfilename, delim2)=
        let 
            val istrm = TextIO.openIn infilename
            val ostrm = TextIO.openOut outfilename
            
            
            val sdelim1 = String.str delim1
            val sdelim2 = String.str delim2
            
            (*some values to store temp field values, current line
            number, current filed number, previous filed number etc.*)
            val quotes = chr 34
            val qstr = String.str quotes
            val newline = #"\n"
            val snewline = String.str newline
            val prev = ref 0
            val curr = ref 0
            val numfield = ref 0
            val field = ref ""
            val flag = ref false
            val out = ref ""
            val numquote = ref 0
            

            (*function to decide on the current field value a::string
            that the delimiter1, delimiter2, newline is a part of the
            field or not*)
            fun check1 (a,num) =
                if a = "" then 
                    true
                else if a = qstr then
                    false
                else
                (
                    if size a = 1 then 
                        true
                    else
                    (    
                        if String.sub(a,0) = quotes then
                        (
                            if String.sub(a,((size a) - 1)) = quotes then
                                if((num mod 2)=0) then true  
                                else false
                            else
                                if((num mod 2)=0) then
                                (   
                                    print(Int.toString(!numfield+1));
                                    print(Int.toString(!curr+1));
                                    raise doubleQuotesError
                                )
                                else false
                        )
                        else
                            if(num>0) then raise fieldNotEnclosed
                            else true
                    )
                )
            
            (*function to check whether the field is already enclosed within
            brackets*)
            fun correct (a,present) =
                if present then 
                (
                    if String.sub(a,0) = quotes then a
                    else (qstr ^ a ^ qstr)
                )
                else a

            (*ducntion to do the scanning and exchanging the delimiter1
            with delimiter2 and escape delimiter1, newline if present inside
            the field*)
            fun scan istrm = 
                case TextIO.input1 istrm of
                    SOME c      =>
                        (
                            if c = quotes then
                            (   numquote := !numquote + 1;
                                field := !field ^ qstr;
                                scan istrm
                            )
                            else if c = delim1 then
                            (
                                if check1 (!field,!numquote) then
                                (
                                    field := correct (!field,!flag);
                                    out := !field ^ sdelim2;
                                    field := "";
                                    numfield := !numfield + 1;
                                    TextIO.output(ostrm,!out);
                                    out := "";
                                    numquote := 0;
                                    flag := false
                                )
                                else
                                (
                                    field := !field ^ sdelim1
                                );
                                scan istrm
                            )
                            else if c = delim2 then
                            (   
                                flag := true;
                                field := !field ^ sdelim2;
                                scan istrm
                            )
                            else if c = newline then
                            (
                                if check1 (!field,!numquote) then
                                (   
                                    numfield := !numfield + 1;
                                    if !curr <> 0 then
                                    (
                                        if !prev <> !numfield then raise UnevenFields(!curr,!numfield,!prev) 
                                        else curr := !curr + 1
                                    )
                                    else
                                    (
                                        curr := 1
                                    );
                                    prev := !numfield;
                                    numfield := 0;
                                    field := correct (!field, !flag);
                                    out := !field ^ snewline;
                                    field := "" ;
                                    TextIO.output(ostrm,!out);
                                    out := "";
                                    numquote := 0;
                                    flag := false
                                )
                                else
                                (
                                    field := !field ^ snewline
                                );
                                scan istrm
                            )
                            else
                            (
                                field := !field ^ String.str(c);
                                scan istrm
                            )
                        )
                |   NONE        => 
                        (
                            if !curr = 1 andalso !prev = 0 then raise emptyInputFile
                            else curr := 0;
                            TextIO.closeOut ostrm
                        )
        in
            scan istrm before TextIO.closeIn istrm
        end
        handle UnevenFields(line1,field1,field2) => 
        print("Expected: "^(Int.toString(field2))^" fields , Present: "^(Int.toString(field1))^" fields on Line "^(Int.toString(line1+1))^"\n")

fun csv2tsv(infilename, outfilename)=
    let 
        val delimiter1 = #","
        val delimiter2 = #"\t"
    in
        convertDelimiters(infilename, delimiter1, outfilename, delimiter2)
    end

fun tsv2csv(incilename, outfilename)=
    let
        val delimiter1 = #"\t"
        val delimiter2 = #","
    in
        convertDelimiters(incilename, delimiter1, outfilename, delimiter2)
    end 
 
(*
fun convertNewlines(infilename, newline1, outfilename, newline2)=
    let 
        val is = TextIO.openIn infilename
        val os = TextIO.openOut outfilename

        val lennl1 = size newline1
        val quote = chr 34
        val squote = String.str(quote)
        val cur = ref 0
        val lf = #"\n"
        val slf = String.str(lf)        
        val cr = #";"
        val scr = String.str(cr)
        val record = ref ""
        val newline = ref ""
        val numquote = ref 0

        fun scan is = 
            case TextIO.input1 is of
                SOME c  =>
                    (
                        if c = lf then
                        (   newline := !newline ^ slf;
                            if (((!numquote) mod 2) = 0) then 
                            (                                
                                if !newline = newline1 then 
                                (
                                    TextIO.output(os,!record);
                                    record := "";
                                    TextIO.output(os,newline2);
                                    newline := ""; 
                                    numquote := 0  
                                )
                                else
                                (
                                    if lennl1 <= (size (!newline)) then raise IncorrectNewline
                                    else ()
                                )
                            )
                            else
                            (
                                record := !record ^ !newline ;
                                newline := ""
                            );                            
                            scan is
                        )
                        else if c = cr then
                        (
                            newline := !newline ^ scr;
                            if (((!numquote) mod 2) = 0) then 
                            (                                
                                if !newline = newline1 then 
                                (
                                    TextIO.output(os,!record);
                                    record := "";
                                    TextIO.output(os,newline2);
                                    newline := "";
                                    numquote := 0 
                                )
                                else
                                (
                                    if lennl1 <= (size (!newline)) then raise IncorrectNewline
                                    else ()
                                )
                            )
                            else
                            (
                                record := !record ^ !newline ;
                                newline := ""
                            );                            
                            scan is
                        )
                        else
                        (   if c = quote then 
                            (
                                numquote := !numquote + 1;
                                record := !record ^ squote
                            )
                            else
                            (
                                record := !record ^ String.str(c) 
                            );
                            newline := "";
                            scan is
                        )
                    )
            |   NONE    =>TextIO.closeOut os
    
    in
        scan is before TextIO.closeIn is
    end

fun unix2dos(infilename, outfilename) =
    let
        val newline1 = "\n"
        val newline2 = "\r\n"
    in
        convertNewlines(infilename, newline1, outfilename, newline2)
    end

fun dos2unix(incilename, outfilename) = 
    let
        val newline1 = "\r\n"
        val newline2 = "\n"
    in
        convertNewlines(incilename, newline1, outfilename, newline2)
    end*)
