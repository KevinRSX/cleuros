def FOO(b):
	a = 0
	while b > 0:
		a = a + 1
		b = b - 1
	return a

def BAR():
	return FOO(100)

def main():
	val = BAR()
	print(val)

main()
