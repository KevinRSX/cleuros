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



In `lib`, you can generate and run an `*.out` LLVM bitcode for source program`<source.cl>` placed in `test/` using

```
$ ./tester.sh source
$ lli source.out
```



You can manually compare the result to the expected result using

```
$ diff ../test/expected/<source>.expected <(lli <source>.out)
```



Example session

```
*[main][~/Desktop/repo/cleuros]$ llvm version
zsh: command not found: llvm
*[main][~/Desktop/repo/cleuros]$ lli --version
Homebrew LLVM version 13.0.1
  Optimized build.
  Default target: arm64-apple-darwin21.4.0
  Host CPU: cyclone
*[main][~/Desktop/repo/cleuros]$ opam show llvm

<><> llvm: information on all versions ><><><><><><><><><><><><><><><><><><>  🐫
name                   llvm
all-installed-versions 13.0.0 [default]
... (truncated)

<><> Version-specific details <><><><><><><><><><><><><><><><><><><><><><><>  🐫
version      13.0.0
... (truncated)

*[main][~/Desktop/repo/cleuros]$ cd lib
*[main][~/Desktop/repo/cleuros/lib]$ ./tester.sh array_loop
+ TEST_PATH=../test/array_loop.cl
+ make
ocamlbuild -pkg llvm cleuros.native
Finished, 28 targets (28 cached) in 00:00:00.
+ ./cleuros.native -l ../test/array_loop.cl
*[main][~/Desktop/repo/cleuros/lib]$ lli array_loop.out
81
64
49
36
25
16
9
4
100
0
```

