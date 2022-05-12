def FOO(b, x):
	a = 3
	while b > 0:
		if x == True:
			a = a + 1
		else:
			a = a - 1
		b = b - 1
	return a

def BAR():
	return FOO(1, True)

def main():
	val = BAR()
	print(val)

main()
