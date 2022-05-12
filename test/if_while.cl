int FOO(b be int, x be bool)
	a := 3
	while b > 0
		if x
			a := a + 1
		else
			a := a - 1
		b := b - 1
	return a

int BAR()
	return FOO(1, TRUE)

MAIN()
	val := BAR()
	PRINT(val)
