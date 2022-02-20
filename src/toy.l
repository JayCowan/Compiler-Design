class Token {
    String text;
    Token(String t){
        text = t;
    }
}
%%

%unicode

%{
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

Digit = [0 - 9]
Letter = =[A - Z, a - z]
Others = [0 - 9 & .]
WhiteSpace = [\040\ n]

// Tell JLex to have yylex() return a Token
%type Token

// Tell JLex to name the generated class `Lexer`
%class Lexer

%eofval {
    return new Token(null); %
eofval}

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