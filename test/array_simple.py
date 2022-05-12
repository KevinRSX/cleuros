def main():
	arr = [1, 2, 3]
	a = arr[1]
	print(arr[0])
	print(a)
	print(arr[a])

	arr[0] = 6
	arr[arr[0] - 5] = arr[2] + 2
	arr[a] = 4
	print(arr[0])
	print(arr[1])
	print(arr[2])

	brr = [0, 0, 0, 0, 0]
	print(brr[0])
	brr[1] = 89
	print(brr[1])

main()
