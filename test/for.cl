MAIN()
	a := 0
	arr := [1, 2, 3]
	for i := 0 to arr.length - 1
		if i != 1
			a := a + arr[i]
	PRINT(a)

	for i := arr.length - 1 downto 0
		if i != 1
			a := a - arr[i]
	PRINT(a)
