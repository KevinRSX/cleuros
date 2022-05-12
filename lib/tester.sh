#!/bin/bash

set -x
TEST_PATH="../demo/$1.cl"

make
./cleuros.native -l $TEST_PATH > "$1.out"

