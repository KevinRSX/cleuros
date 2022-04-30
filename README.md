# cleuros

First, change to the lib directory `cd lib`


To build `cleuros.native`: `make` or `make build` 

```
Usage: ./cleuros.native [-a|-s|-l] <source.cl>
  -a Print the AST
  -s Print the SAST
  -l Print the generated LLVM IR
  -help  Display this list of options
  --help  Display this list of options
```

You can also `make llvm` or `make sast` or `make ast` to run specific test

To run the LLVM IR, `lli <generated_file>`.
