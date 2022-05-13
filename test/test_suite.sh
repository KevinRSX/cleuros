#!/bin/bash

# set -x
NC='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

PYTHON="python3" 
rm -f result.txt
cd ../lib
make clean
cd ../test

for f in *.cl; do
  NAME="`basename $f .cl`"
  OUT=".out"
  FULLOUT="$NAME.out"
  RESULT=".result"
  PY=".py"
  PYRESULT=".pyresult"
  FULLRESULT="$NAME.result"
  PYSOURCE="$NAME$PY"
  CORRECTRESULT="$NAME$PYRESULT"

  echo "<<<<<<<<<<<<<<<<<<<<<<<<<< $f >>>>>>>>>>>>>>>>>>>>>>>>"

  cd ../lib/
  make
  ./cleuros.native -l ../test/$f > $FULLOUT # We need compiler's output
  lli $FULLOUT > ../test/result/$FULLRESULT

  cd ../test/
  if test -f "$PYSOURCE"; then
    $PYTHON $PYSOURCE > result/$CORRECTRESULT;
    CORRECTRESULTLOC="result/$CORRECTRESULT";
    CLRSRESULTLOC="result/$FULLRESULT";
    DIFF="`diff -B $CORRECTRESULTLOC $CLRSRESULTLOC`";
    if [ "$DIFF" == "" ]
    then
      echo -e "${GREEN}${NAME} successful ${NC}"
      echo "$NAME successful" >> result.txt
    else
      echo -e "${RED}${NAME} failed ${NC}"
      echo "$NAME failed" >> result.txt
    fi
  fi
done
