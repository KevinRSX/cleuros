# CLeuRoS Implementation Notes

## String

String should be implemented internally as a character array. 



## Types

Array is tricky, especially when called in functions.

```
array FUNC()
	return array # do you know if this should be array of int or char?
```

One way is to change to something like C++ template - `array<int>`, `array<bool>`, etc.



## Memory Model

All the primitive types will be placed on the stack, whereas non-primitive types will be placed on the heap. The references to non-primitive variables are simply "references" to the variables.

```
let s2 be student:
    name = "Stephen A. Edwards"
    age = "21"
    gpa = "4.33"
    society = ["rpi board development", "McDonald's Taiwan"]

print(s2.age) # 21

s1 = s2
s1.age = 22
print(s2.age) # 22
```

Automatic garbage collection is supported in the language. For example,

```
let a be student
a = NULL # a will be trashed
```



