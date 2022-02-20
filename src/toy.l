import java.io.*;

class Token {
    String text;
    TokenType type;

    Token(String text, TokenType type){
        this.text = text;
        this.type = type;
    }

    public String toString() {
        return String.format("%s %s", type, text);
    }
}

enum TokenType {
    Type_Null,
    Type_Letter,
    Type_Integer,
    Type_Other,
    Type_Keyword,
    Type_Reserved_Function,
    Type_Input,
    Type_Terminator,
    Type_White_Space,
    Type_Bracket,
    Type_Symbol,
    Type_Operator,
    Type_Identifier
}
%%

%unicode

%{

StringBuffer buffer = new StringBuffer();

public static void main(String[] args) throws FileNotFoundException, IOException {
    FileReader yyinput = new FileReader(args[0]);
    Lexer yylex = new Lexer(yyinput);
    Token token;
    while ((token = yylex.yylex()) != null) {
        System.out.println(token.text);
    }
}

%}

Integer = [0 - 9]
Letter = [A - Z, a - z]
Other = [0 - 9 & .]
Keyword = ("bool" | "int" | "true" | "false" | "void" | "string" | "struct" | "if" | "then" | "else" | "for" | "return")
ReservedFunction = ("printf")
Input = [^\r\n]
Terminator = \r|\n|\r\n
WhiteSpace = {Terminator} | [ \t\f] | [\040\ n]
Bracket = [{}()]*
Symbol = (";")*
Operator = ( "++" | "--" | "**" | "<=" | ">=" | "!=" | "%" | "=" | "<" | ">" | "!" | "." | "+" | "-" | "/" | "*")*
Identifier = [:jletter:] [:jletterdigit:]*

%state STRING

// Tell JLex to have yylex() return a Token
%type Token

// Tell JLex to name the generated class `Lexer`
%class Lexer

%eofval{ 
    return new Token(null, TokenType.Type_Null); 
%eofval}

%%
{Integer}+ {
    return new Token(yytext(), TokenType.Type_Integer);
}
{WhiteSpace}+ {
    return new Token(yytext(), TokenType.Type_White_Space);
}
. {
    throw new Error("Illegal character <"+yytext()+">");
}