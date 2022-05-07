int GCD(a be int, b be int)
	while a = b
		if (b < a)
			a = a - b
		else
			b = b - a
	return a

int MAIN()
	a := 12
	b := 16
	GCD(a, a / 2)
