def FOO(a, b):
	a = a + 1
	return a

def BAR():
	return FOO(1, True)

def main():
	k = BAR()
	print(str(k))

main()
