default:
	clear
	jflex toy.l
	bison ToYParser.y -v --report=all
	javac *.java
test:
	java -cp toy
clean:
	rm ToYParser.java *.class Lexer.java Lexer.java~