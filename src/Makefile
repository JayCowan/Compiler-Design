default:
	clear
	jflex toy.l
	bison toy.y -L java
	javac *.java
	java Lexer input.txt
test:
	java -cp toy
clean:
	rm toy.java *.class Yylex.java Yylex.java\~