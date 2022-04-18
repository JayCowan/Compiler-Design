default:
	clear
	jflex src/ToY/toy.l --verbose
	bison src/ToY/ToYParser.y -v --report=all
	mv ToYParser.java ./src/ToY/
	mv ToYParser.output ./src/ToY/
	javac src/ToY/*.java
test:
	java -cp ToY
lex:
	java Yylex ../input.txt
clean:
	rm src/ToY/*.class src/ToY/*.java src/ToY/*.java~ src/ToY/*.output
