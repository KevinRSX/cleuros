MAIN()
	a := 0
	arr := [4, 5, 2, 1]
	for i := 0 to arr.length - 2
		for j := arr.length - 1 downto i + 1
			if arr[j] < arr[j - 1]
				exchange arr[j] with arr[j - 1]

	for i := 0 to arr.length -1
		PRINT(arr[i])
