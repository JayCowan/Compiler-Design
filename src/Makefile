default:
	clear
	jflex toy.l
	bison Parser.y -L java
	javac *.java
	java Lexer input.txt
test:
	java -cp toy
clean:
	rm Parser.java *.class Lexer.java Lexer.java~