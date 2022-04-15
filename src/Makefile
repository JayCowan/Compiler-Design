default:
	clear
	bison ToYParser.y -L java
	javac *.java
	java ToYParser input.txt
test:
	java -cp toy
clean:
	rm ToYParser.java *.class Lexer.java Lexer.java~