def GCD(a, b):
	while a != b:
		if b < a:
			a = a - b
		else:
			b = b - a
	
	return a

def main():
	a = 12
	b = 16
	k = GCD(a, b)
	print(k)

main()
