rm -f result.txt;
for f in *.cl; do
    NAME="$(basename $f .cl)";
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<< $f >>>>>>>>>>>>>>>>>>>>>>>>";
    OUT=".out";
    FULLOUT="$NAME$OUT";
    RESULT=".result";
	PY=".py";
	PYRESULT=".pyresult";
    FULLRESULT="$NAME$RESULT";
	PYVERSION="$NAME$PY";
	CORRECTRESULT="$NAME$PYRESULT";
    cd ../lib/;
    ./tester.sh $NAME > /dev/null 2>&1 && lli $FULLOUT > ../test/result/$FULLRESULT;
	cd ../test;
	if test -f "$PYVERSION"; then
		python $PYVERSION > result/$CORRECTRESULT;
		CORRECTRESULTLOC="result/$CORRECTRESULT";
		CLRSRESULTLOC="result/$FULLRESULT";
		DIFF=$(cmp $CORRECTRESULTLOC $CLRSRESULTLOC);
		if [ "$DIFF" == "" ]
		then
			echo "$NAME successful" >> result.txt
		else
			echo "$NAME failed" >> result.txt
		fi
	fi
done
