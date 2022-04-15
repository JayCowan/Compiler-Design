default:
	clear
<<<<<<< HEAD
	bison ToYParser.y -L java
=======
	jflex toy.l
	bison ToYParser.y -v
>>>>>>> fde78ccb6447d3f0f26c38b5e25884356ace3e12
	javac *.java
	java ToYParser input.txt
test:
	java -cp toy
clean:
	rm ToYParser.java *.class Lexer.java Lexer.java~