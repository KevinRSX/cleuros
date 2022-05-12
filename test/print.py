def FOO():
	print("3")

def BAR():
	FOO()
	return 0

def main():
	k = BAR()

main()
