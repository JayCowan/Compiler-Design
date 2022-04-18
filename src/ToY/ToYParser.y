%language "Java"
%define api.package { ToY }
%define api.parser.class { ToYParser }
//%define api.value.type { Token }
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
        
        ToYParser p = new ToYParser(l);
        if (!p.parse()) System.out.println("ERROR");
        System.out.println("VALID");
        return;
    }
}

%token <Integer> NUM 
%token <String> STRING
%type <Integer> exp 
%type <String> printf
%precedence NEG 
%left '-' '+'
%left '*' '/'
%right '^'        /* exponentiation */
%left '='


%%
input: line | input line;

line: '\n'
| printf '\n' 
| exp '\n'  {System.out.println($exp);}
| error '\n'
;
exp:
NUM                 { $$ = $1;}
| '!'               { $$ = 0; return YYERROR; }
| '-' error         { $$ = 0; return YYERROR; }
| '-' exp %prec NEG { $$ = -$2; }
| exp '+' exp       { $$ = $1 + $3; }
| exp '-' exp       { $$ = $1 - $3; }
| exp '^' exp       { $$ = (int) Math.pow($1, $3); }
| exp '*' exp       { $$ = $1 * $3; }
| exp '/' exp       { $$ = $1 / $3; }
| exp '=' exp %prec NEG { if ($1.intValue() != $3.intValue()) yyerror("calc: error: " + $1 + " != " + $3); }
| '(' exp ')'       { $$ = $2; }
| '(' error ')'     { $$ = 1111; return YYERROR; }
;
printf:
STRING                  { $$ = $1; }
| "printf" printf ';'   { System.out.println($2);}     
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
    public Object getLVal() {
        return yylval.typeToInt();
    }

    @Override
    public int yylex () throws IOException {
        return yylex.yylex().typeToInt();
    }
}
