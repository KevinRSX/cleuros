.PHONY : all test clean

build: ast.ml parser.mly scanner.mll irgen.ml cleuros.ml test_helper.ml
	ocamlbuild -pkg llvm cleuros.native

llvm: ast.ml parser.mly scanner.mll irgen.ml cleuros.ml test_helper.ml
	ocamlbuild -pkg llvm cleuros.native \
		&& ./cleuros.native -l ../test/whitespace.cl > whitespace.out

ast: ast.ml parser.mly scanner.mll irgen.ml cleuros.ml test_helper.ml
	ocamlbuild -pkg llvm cleuros.native && ./cleuros.native -a ../test/whitespace.cl

sast: ast.ml parser.mly scanner.mll irgen.ml cleuros.ml test_helper.ml
	ocamlbuild -pkg llvm cleuros.native && ./cleuros.native -s ../test/whitespace.cl

clean:
	rm -rf _build/ *.native parser.mli parser.ml parser.output *.out .out
