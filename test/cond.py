def FOO(b):
	if b:
		a = 1
	else:
		a = 0
	return a

def BAR():
	return FOO(False)

def main():
	k = BAR()
	print(k)

main()
