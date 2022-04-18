package ToY;

import java.io.*;
import java.util.*;

class Token {
    Object val;
    TokenType type;

    Token(Object val, TokenType type){
        this.val = val;
        this.type = type;
    }

    public Object val() {
        return this.val;
    }
    public Integer parseInt() {
        return Integer.parseInt(this.val.toString());
    }
    public String toString() {
        return String.format("%s %s", type, val.toString());
    }
    public int typeToInt() {
            return this.type.ordinal();
    }
}

enum TokenType {
    Type_Null,
    //Type_Input,
    //Type_Letter,
    Type_Integer,
    Type_Other,
    Type_Keyword,
    Type_Reserved_Function,
    Type_Terminator,
    Type_White_Space,
    Type_Bracket,
    Type_Operator,
    Type_Identifier,
    Type_String,
    Type_Semicolon,
}
%%

%unicode

%{
StringBuffer string = new StringBuffer();
List<Token> tokens = new ArrayList<Token>();
%}

Int = [0-9] 
Decimal = [0-9]{Int}*
NegDec = [-]({Int}|{Decimal})
Integer = ({NegDec}|{Decimal}|{Int})
//Letter = [A-Z, a-z]
Other = [0-9&.]
Keyword = ("bool" | "int" | "true" | "false" | "void" | "string" | "struct" | "if" | "then" | "else" | "for" | "return")
ReservedFunction = "printf"
//Input = [^\r\n]
Terminator = \r|\n|\r\n
WhiteSpace = {Terminator} | [ \t\f] | [\040\ n] | (" ")
Bracket = [{}()]
Semicolon = (";")
Operator = ("++" | "--" | "**" | "<=" | ">=" | "!=" | "%" | "=" | "<" | ">" | "!" | "." | "+" | "-" | "/" | "*" | "&&" | "||")
Identifier = [[:jletter:]&&[:jletterdigit:]]

%state STRING

// Tell JLex to have yylex() return a Token
%type Token
%debug
%char
%line
%column
%eofval{ 
    return new Token(null, TokenType.Type_Null); 
%eofval}
%eof{
try {
    System.out.println(tokens);
} catch (Exception e) {
    System.out.println("Error");
}
%eof}

%%
<YYINITIAL> {
{ReservedFunction}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Reserved_Function));
}
{Keyword}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Keyword));
}
{Bracket}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Bracket));
}
{Operator}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Operator));
}
{Identifier}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Identifier));
}
{WhiteSpace}+ {
    tokens.add(new Token(yytext(), TokenType.Type_White_Space));
}
{Integer}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Integer));
}
\" {
    string.setLength(0);
    yybegin(STRING);
}
//{Letter}+ {
//    return new Token(yytext(), TokenType.Type_Letter);
//}
{Other}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Other));
}
{Semicolon}+ {
    tokens.add(new Token(yytext(), TokenType.Type_Semicolon));
}
//{Input}+ {
//   return new Token(yytext(), TokenType.Type_Input);
//}
}

<STRING> {
\" {
    yybegin(YYINITIAL);
    tokens.add(new Token(string.toString(), TokenType.Type_String));
}
[^\n\r\"\\]+ {
    string.append(yytext());
}
\\t {
    string.append('\t');
}
\\n {
    throw new Error("Bad string literal" + string.toString());
}
<<EOF>> {
    throw new Error("unexpected end of file");
}
\\r {
    string.append('\r');
}
\\\" {
    string.append('\"');
}
\\ {
    string.append('\\');
}
}
[^] {
    throw new Error("Illegal character <"+yytext()+">");
}
