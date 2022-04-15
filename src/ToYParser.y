%language "Java"

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
}

%code {
    public static void main(String[] args) throws IOException {
        ToYLexer l = new ToYLexer(System.in);
        ToYParser p = new ToYParser(l);
        if (!p.parse()) System.out.println("INVALID");
    }
}

%token <Integer> NUM
%type <Integer> exp
%precedence NEG 
%left '-' '+'
%left '*' '/'
%right '^'        /* exponentiation */

%%
input: line | input line;

line: '\n'
| exp '\n'  {System.out.println($exp);}
| error '\n'
;
exp: 
<<<<<<< HEAD
NUM            
| '-' exp %prec NEG { $$ = -$2; }
| '!'               { $$ = 0; return YYERROR; }
=======
NUM
| '!'               { $$ = 0; return YYERROR; }
| '-' error         { $$ = 0; return YYERROR; }
| '-' exp %prec NEG { $$ = -$2; }
>>>>>>> fde78ccb6447d3f0f26c38b5e25884356ace3e12
| exp '+' exp       { $$ = $1 + $3; }
| exp '-' exp       { $$ = $1 - $3; }
| exp '^' exp       { $$ = (int) Math.pow($1, $3); }
| exp '*' exp       { $$ = $1 * $3; }
| exp '/' exp       { $$ = $1 / $3; }
<<<<<<< HEAD
| exp '^' exp %prec NEG { $$ = (int) Math.pow($1, $3); }
| exp '=' exp %prec NEG { if ($1.intValue() != $3.intValue()) yyerror("calc: error: " + $1 + " != " + $3); }
| '(' exp ')'       { $$ = $2; }
| '(' error ')'     { $$ = 1111; }
| '-' error         { $$ = 0; return YYERROR; }
=======
| exp '=' exp       { if ($1.intValue() != $3.intValue()) yyerror("calc: error: " + $1 + " != " + $3); }
| '(' exp ')'       { $$ = $2; }
| '(' error ')'     { $$ = 1111; }
>>>>>>> fde78ccb6447d3f0f26c38b5e25884356ace3e12
;

%%
class ToYLexer implements Lexer {
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
    public Object getLVal() {
        return yylval;
    }

    @Override
    public int yylex () throws IOException {
        return yylex.yylex();
    }
}
