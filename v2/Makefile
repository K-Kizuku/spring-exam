build:
	flex brackets_with_text.l
	yacc -d brackets_with_text.y
	gcc lex.yy.c y.tab.c -o bracket_parser -ll

run: build
	./bracket_parser