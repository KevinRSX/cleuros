# valid
int MAIN()
{
	a := 0;
	GCD(a, a / 2);
}

int GCD(a be int, b be int)
{
	if a < b
		return GCD(b, a);
	else {
		if b = 0
			return a;
		else
			return GCD(b, a % b);
	}
}
