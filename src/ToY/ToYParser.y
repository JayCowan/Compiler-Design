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
    import java.util.*;
}

%code {
    public static void main(String[] args) throws IOException {
        ToYLexer l = new ToYLexer(System.in);
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
STRING              { $$ = $1; }
;
printf:
STRING
| "printf" printf ';'   { $$ = new Token($1.val().toString(), TokenType.Type_String); }     
;
%%
class Struct {
    String name;
    List<Map<String,String>> fields;
    public Struct (String name, List<Map<String, String>> fields) {
        this.name = name;
        this.fields = fields;
    }
}
class Function {
    String name;
    String returnType;
    List<Map<String, String>> parameters;
    List<Map<String, String>> variables;
    public Function (String name, String returnType, List<Map<String, String>> parameters, List<Map<String, String>> variables) {
        this.name = name;
        this.returnType = returnType;
        this.parameters = parameters;
        this.variables = variables;
    }

}
class SymbolTable {
    public HashMap<String, Function> functionSymbolTable;
    public HashMap<String, Struct> structSymbolTable;
    public HashMap<String, String> variableSymbolTable;

   public SymbolTable () {
        functionSymbolTable = new HashMap<String, Function>();
        structSymbolTable = new HashMap<String, Struct>();
        variableSymbolTable = new HashMap<String, String>();
    }

    public void addFunction(Function function) {
        functionSymbolTable.put(function.name, function);
    }

    public void addStruct(Struct struct) {
        structSymbolTable.put(struct.name, struct);
    }
    public void addVariable(String name, String type) {
        variableSymbolTable.put(name, type);
    }
    public String getVariable(String name) {
        return variableSymbolTable.get(name);
    }
    public Function getFunction(String name) {
        return functionSymbolTable.get(name);
    }

    public Struct getStruct(String name) {
        return structSymbolTable.get(name);
    }
}
class ToYLexer implements ToYParser.Lexer {
    InputStreamReader it;
    Yylex yylex;
    SymbolTable symbols;

    public ToYLexer(InputStream is) {
        
        it = new InputStreamReader(is);
        yylex = new Yylex(it);
        symbols = new SymbolTable();
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
