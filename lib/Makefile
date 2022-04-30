.PHONY : all test clean

build: ast.ml parser.mly scanner.mll irgen.ml cleuros.ml test_helper.ml
	ocamlbuild -pkg llvm cleuros.native && ./cleuros.native ../test/whitespace.cl

clean:
	rm -rf _build/ *.native
