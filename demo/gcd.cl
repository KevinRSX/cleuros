int GCD(a be int, b be int)
	while a != b
		if (b < a)
			a := a - b
		else
			b := b - a
	return a

MAIN()
	a := [12, 14, 28, 256]
	b := [16, 7, 32, 1024]
	for i := 0 to a.length - 1
		PRINT("GCD:")
		k := GCD(a[i], b[i])
		PRINT(k)
