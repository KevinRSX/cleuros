def main():
	arr = [1, 2, 3]
	print(arr[0])
	print(arr[1])
	temp = arr[0]
	arr[0] = arr[1]
	arr[1] = temp
	print(arr[0])
	print(arr[1])

main()
