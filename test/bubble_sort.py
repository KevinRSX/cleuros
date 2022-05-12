def main():
	a = 0
	arr = [3, 2, 1]
	for i in range(len(arr) - 1):
		for j in range(len(arr) - 1, i, -1):
			if arr[j] < arr[j - 1]:
				temp = arr[j]
				arr[j] = arr[j-1]
				arr[j-1] = temp
	print(arr[0])
	print(arr[1])
	print(arr[2])

main()
