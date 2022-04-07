.PHONY : all test clean

build: ast.ml parser.mly scanner.mll cleuros.ml test_helper.ml
	ocamlbuild cleuros.native && ./cleuros.native ../test/whitespace.cl

semant:
	ocamlbuild cleuros.native && ./cleuros.native ../test/semant.cl

gcd:
	ocamlbuild cleuros.native && ./cleuros.native ../test/gcd.cl	

clean:
	rm -rf _build/ *.native
