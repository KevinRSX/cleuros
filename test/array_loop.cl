MAIN()
	b := 1
	a := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	i := 0
	while i < 10
		a[i] := i * i
		i := i + 1
	while i > 0
		PRINT(a[i - 1])
		i := i - 1
