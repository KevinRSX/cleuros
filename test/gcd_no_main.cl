int FOO(a be int, b be int)
	while a != b
		if (b < a)
			a := a - b
		else
			b := b - a
	return a

int BAR()
	return FOO(12, 16)
