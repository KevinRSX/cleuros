.PHONY : all test clean

test: ast.ml cleuros.ml parser.mly scanner.mll test.ml test_helper.ml
	ocamlbuild test.native

run: test.native
	ocamlbuild test.native && ./test.native 

clean:
	rm -rf _build/ test.native
