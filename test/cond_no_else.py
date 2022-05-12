def FOO(b):
	if b:
		a = 1
	return a

def BAR():
	return FOO(True)

def main():
	k = BAR()
	print(k)

main()
