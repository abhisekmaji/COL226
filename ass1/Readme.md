# pl-ass1
## File Format Conversion

csv2dsv.sml is the main file
it contains the function **convertDelimiters** which
does the conversion from `one delimiter` separated file to `another delimiter` separated file.

Some errors that were taken care of:
* It also takes care of emptyInputfile and UnevenField exceptions. 
* Apart from these it also raises error if a field containing double quotes is not enclosed within double quotation.
* Also it raises error if field containing the delimiter is not enclosed within double quotation.

The above things were kept in mind when converting the delimiter to another so that the converted file is legal.

Also the file contains two other functions which uses the
above function to convert csv file to tsv file and vise-versa.
