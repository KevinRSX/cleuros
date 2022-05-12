def main():
	a = 0
	arr = [1, 2, 3]
	for i in range(len(arr)):
		if i != 1:
			a = a + arr[i]
	print(a)

	for i in range(len(arr)-1, -1, -1):
		if i != 1:
			a = a - arr[i]
	print(a)

main()
