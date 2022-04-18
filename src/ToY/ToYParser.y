%language "Java"
%define api.package { ToY }
%define api.parser.class { ToYParser }
%define api.value.type { Token }
%define api.parser.public
%define parse.error verbose


%code imports {
    import java.io.IOException;
    import java.io.InputStream;
    import java.io.InputStreamReader;
    import java.io.Reader;
    import java.io.StreamTokenizer;
    import java.io.*;
}

%code {
    public static void main(String[] args) throws IOException {
        System.out.println("Start");
        ToYLexer l = new ToYLexer(System.in);
        System.out.println("Lexer Created");
        ToYParser p = new ToYParser(l);
        if (!p.parse()) System.out.println("ERROR");
        System.out.println("VALID");
    }
}

%token NUM STRING
%type exp printf

%precedence NEG 
%left '-' '+'
%left '*' '/'
%right '^'        /* exponentiation */
%nonassoc '='


%%
input: line | input line;

line: '\n'
| printf '\n' {System.out.println($printf);}
| exp '\n'  {System.out.println($exp);}
| error '\n'
;
exp:
NUM                 { $$ = $1;}
| '!'               { return YYERROR; }
| '-' error         { return YYERROR; }
| '-' exp %prec NEG { $$ = new Token((-($2.parseInt())), TokenType.Type_Integer); }
| exp '+' exp       { $$ = new Token($1.parseInt() + $3.parseInt(), TokenType.Type_Integer); }
| exp '-' exp       { $$ = new Token($1.parseInt() - $3.parseInt(), TokenType.Type_Integer); }
| exp '^' exp       { $$ = new Token((int) Math.pow($1.parseInt(), $3.parseInt()), TokenType.Type_Integer); }
| exp '*' exp       { $$ = new Token($1.parseInt() * $3.parseInt(), TokenType.Type_Integer); }
| exp '/' exp       { $$ = new Token((int) ($1.parseInt() / $3.parseInt()), TokenType.Type_Integer); }
| exp '=' exp %prec NEG { if ($1.parseInt() != $3.parseInt()) yyerror("calc: error: " + $1.toString() + " != " + $3.toString()); }
| '(' exp ')'       { $$ = new Token($2.parseInt(), TokenType.Type_Integer);; }
| '(' error ')'     { return YYERROR; }
;
printf:
STRING
| "printf" printf ';'   { $$ = new Token($1.val().toString(), TokenType.Type_String); }     
;
%%
class ToYLexer implements ToYParser.Lexer {
    InputStreamReader it;
    Yylex yylex;

    public ToYLexer(InputStream is) {
        
        it = new InputStreamReader(is);
        yylex = new Yylex(it);
    }

    @Override
    public void yyerror (String s) {
        System.err.println(s);
    }

    Token yylval;
    @Override 
    public Token getLVal() {
        return yylval;
    }

    @Override
    public int yylex () throws IOException {
        return yylex.yylex().typeToInt();
    }
}
