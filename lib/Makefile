.PHONY : all test clean

build: test.native
	ocamlbuild cleuros.native

semant: ast.ml parser.mly scanner.mll cleuros.ml test_helper.ml
	ocamlbuild cleuros.native && ./cleuros.native ../test/semant.cl

gcd: ast.ml parser.mly scanner.mll cleuros.ml test_helper.ml
	ocamlbuild cleuros.native && ./cleuros.native ../test/gcd.cl

clean:
	rm -rf _build/ *.native
