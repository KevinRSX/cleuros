newtype MyCustomType
	let a be a int
	let b be a bool

newtype MyOtherCustomType
	let xyz be a int 
	let abc be a int 
	let mybool be a bool

MAIN()
	let a be MyCustomType  # SCustDecl
	let myother be MyOtherCustomType
	myother.abc := 3 + 5
	myother.mybool := TRUE
	a.b := myother.mybool
