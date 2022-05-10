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
all-versions           3.4  3.5  3.6  3.7  3.8  3.9  4.0.0  5.0.0  6.0.0  7.0.0  8.0.0  9.0.0  10.0.0  11.0.0
                       12.0.1  13.0.0

<><> Version-specific details <><><><><><><><><><><><><><><><><><><><><><><>  🐫
version      13.0.0
repository   default
url.src      "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.xz"
url.checksum "sha256=408d11708643ea826f519ff79761fcdfc12d641a2510229eec459e72f8163020"
homepage     "http://llvm.moe"
doc          "http://llvm.moe/ocaml"
bug-reports  "http://llvm.org/bugs/"
dev-repo     "git+http://llvm.org/git/llvm.git"
authors      "whitequark <whitequark@whitequark.org>" "The LLVM team"
maintainer   "Kate <kit.ty.kate@disroot.org>"
license      "MIT"
depends      "ocaml" {>= "4.00.0"}
             "ctypes" {>= "0.4"}
             "ounit" {with-test}
             "ocamlfind" {build}
             "conf-llvm" {build & = version}
             "conf-python-3" {build}
             "conf-cmake" {build}
conflicts    "base-nnp" "ocaml-option-nnpchecker"
synopsis     The OCaml bindings distributed with LLVM
description  Note: LLVM should be installed first.
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

