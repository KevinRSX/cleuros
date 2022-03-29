# valid
int MAIN()
{
	x; # SVar
	3; # SLit
	a = TRUE; # SBLit
	y = x + 1; # SAsn

	if x > y {
		x = 1;
	}
	else {
		y = STUB();
		y = 1;
	}

	exchange x with y; # SSwap
	BLOCK(x, 2, 3); # SCall

	while x > 0 {
		x = 1;
		y = 9;
	}
	return z;
}

int STUB()
{
	return 0;
}

BLOCK()
{
	x = 3;
	{
		y = 2;
		z = 1;
	}
}
