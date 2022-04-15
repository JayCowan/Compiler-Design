default:
	clear
	jflex toy.l
	bison ToYParser.y -v
	javac *.java
	java ToYParser input.txt
test:
	java -cp toy
clean:
	rm ToYParser.java *.class Lexer.java Lexer.java~