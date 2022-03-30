# cleuros

First, change to the lib directory `cd lib`


To build `cleuros.native`: `make` or `make build` 

To test semantically-checked program:`./cleuros.native path/to/source` after building:

- current test files are under `test/`
- to run the two provided sample tests for the hello world deliverable, `make semant` and `make gcd`

To remove compilation artifacts: `make clean`



## Hello World Submission

In this submission, we completed scanning, parsing, and semantic checking of most of our supported syntax. `cleuros.native` will take a source file and print the semantic AST (SAST) of the file. You may see `test/semant.output` for an example of the printed SAST.

For the detail of our current work and todo list, please see `docs/dev.md`. For the most updated version of the language manual, please see `docs/lrm.md`.

We provide two test source files:

1. `semant.cl`: almost if not all of the syntax we currently support
2. `gcd.cl`: demo of a GCD program

To see the results of either tests, `make semant` or `make gcd`. We have also stored the expected output of these tests in their corresponding `.output` files.



