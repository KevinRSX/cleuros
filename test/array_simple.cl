MAIN()
	arr := [1, 2, 3]
	a := arr[1]
	PRINT(arr[0])
	PRINT(a)
	PRINT(arr[a])

	arr[0] := 6
	arr[arr[0] - 5] := arr[2] + 2
	arr[a] := 4
	PRINT(arr[0])
	PRINT(arr[1])
	PRINT(arr[2])
