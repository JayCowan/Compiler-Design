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
    Type_Letter;
    Type_Integer;
    Type_Others;
    Type_Keywords;
    Type_Reserved_Functions;
    Type_Input;
    Type_Terminator;
    Type_White_Space;
    Type_Brackets;
    Type_Symbols;
    Type_Operators;
    Type_Identifiers;
}
%%

%unicode

%{
import java.io.*

StringBuffer buffer = new StringBuffer();

public static void main(String[] args) throws FileNotFoundException, IOException {
    FileReader yyinput = new FileReader(args[0]);
    Yylex yylex = new Yylex(yyinput);
    Token token;
    while ((token = yylex.yylex()) != null) {
        System.out.println(token.text);
    }
}

%}

Integers = [0 - 9]
Letter = [A - Z, a - z]
Others = [0 - 9 & .]
Keywords = ("bool" | "int" | "true" | "false" | "void" | "string" | "struct" | "if" | "then" | "else" | "for" | "return")
ReservedFunctions = ("printf")
Input = [^\r\n]
Terminator = \r|\n|\r\n
WhiteSpace = {Terminator} | [ \t\f] | [\040\ n]
Brackets = [{}()]*
Symbols = (";")*
Operators = ( "++" | "--" | "**" | "<=" | ">=" | "!=" | "%" | "=" | "<" | ">" | "!" | "." | "+" | "-" | "/" | "*")*
Identifiers = [:jletter:] [:jletterdigit:]*

%state STRING

// Tell JLex to have yylex() return a Token
%type Token

// Tell JLex to name the generated class `Lexer`
%class Lexer

%eofval {
    return new Token(null); %
eofval }

%%
{Digit}+ {
    return new Token(yytext());
}
{WhiteSpace}+ {
    // Handle WhiteSpace
}
. {
    throw new Error("Illegal character <"+yytext()+">");
}