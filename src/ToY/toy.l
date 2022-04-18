package ToY;

import java.io.*;
import java.util.*;

class Token {
    String text;
    TokenType type;

    Token(String text, TokenType type){
        this.text = text;
        this.type = type;
    }
    public String text() {
        return this.text;
    }
    public String toString() {
        return String.format("%s %s", type, text);
    }
    int typeToInt() {
            return this.type.ordinal();
    }
}

enum TokenType {
    Type_Null,
    //Type_Input,
    Type_Letter,
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
public static void main(String[] args) throws FileNotFoundException, IOException {
    List<Token> tokens = new ArrayList<Token>();
    System.out.println("Start Lexer");
    FileReader yyinput = new FileReader(args[0]);
    Yylex yylex = new Yylex(yyinput);
    Token token;
    while ((token = yylex.yylex()).text != null) {
        tokens.add(token);
        System.out.println(token.toString());
    }
    System.out.println(tokens.toString());
    System.out.println("End Lexer");
}

%}

Integer = [0 - 9]
Letter = [A - Z, a - z]
Other = [0 - 9 & .]
Keyword = ("bool" | "int" | "true" | "false" | "void" | "string" | "struct" | "if" | "then" | "else" | "for" | "return")
ReservedFunction = ("printf")
//Input = [^\r\n]
Terminator = \r|\n|\r\n
WhiteSpace = {Terminator} | [ \t\f] | [\040\ n]
Bracket = [{}()]
Semicolon = (";")
Operator = ("++" | "--" | "**" | "<=" | ">=" | "!=" | "%" | "=" | "<" | ">" | "!" | "." | "+" | "-" | "/" | "*" | "&&" | "||")
Identifier = [[:jletter:]&&[:jletterdigit:]]

%state STRING

// Tell JLex to have yylex() return a Token
%type Token

%char
%line
%column
%eofval{ 
    return new Token(null, TokenType.Type_Null); 
%eofval}

%%
<YYINITIAL> {
{ReservedFunction}+ {
    return new Token(yytext(), TokenType.Type_Reserved_Function);
}
{Keyword}+ {
    return new Token(yytext(), TokenType.Type_Keyword);
}
{Bracket}+ {
    return new Token(yytext(), TokenType.Type_Bracket);
}
{Operator}+ {
    return new Token(yytext(), TokenType.Type_Operator);
}
{Identifier}+ {
    return new Token(yytext(), TokenType.Type_Identifier);
}
{Integer}+ {
    return new Token(yytext(), TokenType.Type_Integer);
}
{WhiteSpace}+ {
    return new Token(yytext(), TokenType.Type_White_Space);
}
\" {
    string.setLength(0);
    yybegin(STRING);
}
{Letter}+ {
    return new Token(yytext(), TokenType.Type_Letter);
}
{Other}+ {
    return new Token(yytext(), TokenType.Type_Other);
}
{Semicolon}+ {
    return new Token(yytext(), TokenType.Type_Semicolon);
}
//{Input}+ {
//   return new Token(yytext(), TokenType.Type_Input);
//}
}

<STRING> {
\" {
    yytext();
    yybegin(YYINITIAL);
    return new Token(string.toString(), TokenType.Type_String);
}
[^\n\r\"\\]+ {
    string.append(yytext());
}
\\t {
    string.append('\t');
}
\\n {
    string.append('\n');
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