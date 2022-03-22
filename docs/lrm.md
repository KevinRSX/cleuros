# CLeuRoS Language Reference Manual
Yuki Guo, Samuel Meshoyrer, Brian Paick, Kaiwen Xue


---

# 1. Introduction
This language reference manual contains the specification which can be used to develop the compiler for CLeuRos. The document introduces some of the lexical conventions, types, memory models, function calls, control flow, and I/O.

# 2. Lexical Conventions
## 2.1 Tokens

White space such as space and blanks are ignored. The new-line character `\n` is used to delimit statements.

Comments begins with the pound character `#`. 

Additionally, the variable scope is limited by the tab character `\t`. That is, indentation must be done using `\t` and will change the variable scope. For example:
```
x = 3
    y = 1
x = y # this is an error
```

## 2.2 Identifiers
An variable identifier must start with a lower case letter, followed by either upper or lower case letters, digits, or underscores.  That is, all the letters used as identifiers in CLeuRoS are case sensitive, and the first character of an identifier cannot be a number, an underscore, or an uppercase letter. An identifier may not be the same as an existing keyword (see Section 2.3).

A function identifier must also start with a letter followed by letters, digits, or underscores. However, all letters in function identifiers must be capped. e.g., `GCD()`, `PARTITION()`, or `QUICK_SORT()`. 
## 2.3 Keywords
Keywords are specific identifiers. They may not be used to name user-defined functions or variables.
* Types
    * `int`
    * `string`
    * `bool`
    * `TRUE` and `FALSE`
    * `NULL`
* Declaration and initialization
    * `is`
    * `let`, `be`, and `of`
    * `array`
* Operators
    * Arithmetic operators: `+`, `-`, `*`, `/`, `^`, and `%`
    * Logical operators: `and`, `or`, `xor`, `not`
    * Unary operators
        * `+` and `-`
* Control flow
    * `if` and `else`
    * `for` and `while`
    * `break` and `continue`
    * `return`
* `exchange ... with ...` 
* `print()`
* `of`
* `is`
* Type 
    * `typeof()`

## 2.4 Literals
Literals are sequences of characters, which include the following types:
* Integer
* String
* Boolean
## 2.5 Operators

Operators are lexical elements which show the relationship between variables. Separators divide statements. 
* Logical operators include `or`, `and`, and `not`.
* Calculation operators include `+`, `-`, and `&`.
* Equivalence operators include `>`, `==`, and `<=`.
* Separators include `.`.


# 3. Types
In CLeuRoS, there are two kinds of types, primitive and non-primitive. For the primitive types, the compiler will infer the type information dynamically. For the non-primitive types, the user must explicitly declare the type information along with the declaration of variables using the `let` keyword.

## 3.1 Primitives
By the nature of pseudo code, CLeuRoS supports and only needs to support 32-bit integers and single precision floating point numbers.

### 3.1.1 Boolean type 
Boolean type represents a simple one-bit variable. It cannot be inferred by integer type.
```
myBool = TRUE
```

### 3.1.2 `int` type
CLeuRoS uses 32 bits signed integers. Larger numbers are not supported and will cause overflow.
```
myInt = 5
```

### 3.1.3 `float` type
`float` conforms to IEEE 754 single precision.
```
myFloat = 1.2
```

### 3.1.4 String type 
Strings can be assigned using the usual assignment, and like any primitive types, it does not require explicit declaration.
``` str1 = "hello"```
Two strings can be concatenated using the `concat ... with ...` keyword:
```
str2 = concat "hello" with ", world"
```
Note that `concat ... with ...` keyword can be used multiple times:
```
str3 = concat "Is" with " Prof." with " Gu" with " Haojun?"
# str is "Is Prof. Gu Haojun?"
```
Strings can be accessed using the `[]` operator:
```
str3[1] == "s" # TRUE
```
Out-of-bound access returns an error at runtime. That is, the compiler should retain a value recording the length of the string.

The user should also be able to access the length using the keyword `length`: `<stringname>.length` is an integer representing the length of the string. 




## 3.2 Non-Primitives

### 3.2.1 Array type
Arrays will be of dynamic length. All elements of an array must be of the same type. To declare an empty array:
```
let arr1 be array of bool
```

It is possible to assign values to an array directly after declaring it:
```
let arr2 = [TRUE, FALSE, TRUE]
let arr3 = [FALSE, FALSE, FALSE]
```

As with `string`s, the following operations are valid:
* The keyword `length`, used as `<arrayName>.length`, can be used to return an integer representing the length.
* The operator `[]` can be used to access elements.
* To concatenate two arrays, use the keywords `concat ... with ...`; they can be used several times:
```
let arr4 = [1, 2, 3]
let arr5 = [4, 5, 6]
let arr6 = concat arr1 with arr2
# arr6 is [1,2,3,4,5,6]
let arr7 = concat arr4 with arr5 with [7]
# arr7 is [1,2,3,4,5,6,7]
```
To add an element to the end of an array, use keyword `append ... to ...`:
```
let arr8 be array of bool
append TRUE to arr8
append FALSE to arr8
# arr8 is [TRUE, FALSE]
```
To remove the last element from the array, use keyword `removeLast`, which returns the item removed; this item may or may not be used.
```
let arr9 = [TRUE, FALSE, TRUE]
removeLast arr9
# arr9 is [TRUE, FALSE]
myBool = removeLast arr9 # myBool is FALSE
```



## 3.3 Custom Types
The user may define custom types called `newtype`. The custom type is similar to `struct` in C. Each member of the custom type, no matter whether they are primitive, must be explicitly declared. The members must be indented.
```
newtype student:
    let name be string
    let age be int
    let gpa be float
    let society be array of string
```
Custom types are considered to be non-primitive, so they must be declared before use:
```
let s1 be student
```
Members can be accessed and assigned using the `.` operator:
```
s1.name = "Jae"
```
Custom types can also be initialized using indentation:
```
let s2 be student:
    name = "Stephen A. Edwards"
    age = "21"
    gpa = "4.33"
    society = ["rpi board development", "McDonald's Taiwan"]
```

## 3.4 Type Conversion
A special keyword `typeof()` will return a string representing the type of the variable inside the parentheses.
```
typeof("hello") # "string"
typeof([1,2,3]) # "array of int"
```

The `int()` function will attempt to convert a given string into an int. 
The `string()` function will convert a variable to string. 

```
x = 123
y = string(x)  # y = "123"
z = int(y)   # z = 123
```


### 3.4.1 Implicit Conversion
Implicit conversion is only allowed from `float` to `int`.
```
a = 1
x = a + 1.2
print(x) # 2.2
print(typeof(x)) # float
```

### 3.4.2 Explicit Casting
The keyword `cint` (cast int), `cfloat`, `cstring` represent explicit castings.

Only the following explicit castings are allowed:
 - `float` to `int`: the compiler should atomically convert the floating point number to the largest integer smaller or equal to it, e.g.,  `int(-1.3) == -2, int(1.3) == 1`.
 - `int` to `float`: this simply changes the precision of the number.
 -  `bool`, `int`, `float`, and `array` to `string`: converting variables to corresponding strings. Specifically, `float`s will be converted to the string containing the number of non-zero digits (up to 7) after the floating point. `array`s will have each literal converted to using `cstring`:
```
cstring([1,2]) == "[1,2]"
cstring([TRUE, FALSE]) == "[TRUE, FALSE]"
cstring([1.10293801928, 2.4]) == "[1.102938, 2.4]"
let arr be array of int
cstring(arr) == "[]"
```
 - Note that `bool` cannot be explicitly converted from/to either `int` or `float`, or any other types, because the pseudo language requires a strict separation between the use of boolean and normal numbers.
 - Conversions for the custom types are not allowed.

## 3.5 Memory Model
All the primitive types will be placed on the stack, whereas non-primitive types will be placed on the heap. The references to non-primitive variables are simply "references" of the variables.
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


# 4. Operators


## 4.1 Arithmetic
The binary arithemetic operators are `+`, `-`, `*`, `/`, `^` (exponentiation),  and `%` (modulo). Prededence follows PE(MD)(AS); the modulo operator has equal precedence as multiplication and division.
```
myInt = (1+5)*2 # myInt is 12
```

## 4.2 Bitwise
Bitwise operators include `&`, `|`, `~`, `<<`, and `>>`, with their corresponding assignment operations, e.g. `&=` and `|=`.

## 4.3 Assignment
Assignment is right associative and done with the `=` operator or the `is` keyword. Types must remain constant for the scope of a variable. 
```
myInt = 5 
myInt is 6
myInt = "test"  # this is an error 
```

## 4.4 Comparison
All comparison will be performed by value; operators return ```TRUE``` if true and ```FALSE``` if false. Strings and arrays will be compared element-by-element.
Comparison of values can be done using the symbols `<`, `<=`, `>`, `>=`, `==`, and `!=`.

## 4.5 Logical
Logical operators include `and`, `or`, `xor`, and `not`.
```
if (a_valid and b_valid)
if (c_valid or b_valid)
if (not valid)
```
## 4.6 Element Access
Element access is a binary operation. Indexing begins at 0, and is performed using `[]`.
```
A = [1,2,3]
x = A[0]    # x is 1
```
## 4.7 Miscellaneous Unary
Unary operators include `+` and `-`, which represent the positive or negative of an integer or Boolean value; the plus sign will usually be unnecessary with integers. Applied to a variable, the operator will be a no-op if the types are identical and flip the sign if the types are different. 
```
p = 10 # + is unnecessary
q = -5
r = +p # r is 10
s = -p # s is -10
```

# 5. Statements and Expressions

## 5.1 Declarations
Declarations have the format of identifier followed by initial value. All values have to be initialized at declaration. Once an identifier has been bound to a type, its type cannot change. 

```
x = 5 
y = "test"
```
## 5.2 Literal expressions
Literal expressions take one of 4 forms: 
* an integer: `myInt = 5`
* a float: `myFloat = 1.0`
* a string: `myString  = "Hello"`
* a boolean: `myBool = TRUE`

## 5.3 List expressions
* a list of integers:
`
a = [1,2,3]
`
* a list of strings:
`alpha = ["a","bc","def"]`
`let beta be an array of bool`

## 5.4 Function calls
Function calls are performed by first writing a function and then calling it by name. The function's name must be all capped, followed by parantheses without a space in between. A return type must be associated with the function. Not putting a type means the function will not return anything.

Parameters should be placed in the paranthesis as `<name> be <type>`, regardless of whether the type is primitive or not. The function body is indented using the correct level of indentation:
```
array PARTITION(a be array of int, pivot be int)
    let ret be array of int
    ...
    return ret
```
Primitive arguments will be passed by **values**, whereas non-primitive arguments will be passed by **reference**:
```
MUT(a be int, b be array of int)
    a = a + 1
    b[0] = 1

a = 1
let b be array of int
b = [0,2,3]
MUT(a, b) # a is 1, b is [1,2,3]
```
Only primitive and non-primitive types can be used as arguments to the function, meaning that function pointers or lambdas are not supported.

## 5.5 Control flow

The scope of all control-flow statements is determined by the tab character `\t`.
* `if ... else` 

The syntax for an if statement is `if` followed by a condition and then zero or more statements (the "then" block). Optionally, you can follow the block with an `else` and zero or more statements. 

The `if` statement contains a statement which must be true to enter the "then" block. The condition is usually a boolean condition. 
The `elif` statement is used when the previous `if` statement is not fulfilled. This will also be followed by another boolean condition. 
If there are other cases that are not covered by the previous `if` and `elif` statements, the `else` expression may be used to handle them.

```
if a < b 
    c = 2 + d
else 
    d = 5 + f 
```

```
if b > a 
    c = 3 * d 
    d = 4 / e
```
In addition, `if` and `elif` cannot be followed by a non-boolean statement.

```
if ("Hello") # Error 
```

* `while`

The `while` loop begins with a boolean loop condition expression. This will loop the expression(s) in the block until the expression is evaluated to FALSE.

```
while <expr>
    block
```

* `for`

The `for` loop has special syntax. Following the keyword `for` should be a variable declaration such as `i=0..10` signaling that the for loop will run for values of `i = 0, 2, 3 ... to 9`. 

The start and end values can be any integers, variables or literals. The increment will always be +1. 

```
for i=0..10
    print(i) # prints numbers 0-9
```

* `continue/break`

A `continue` expression terminates the current iteration of a loop and returns the control to the loop head.
A `break` expression immediatly stops the loop and continues with the first statement outside the loop.

## 5.6 `exchange ... with ...`
The `exchange ... with ...` statement performs a "shallow" exchange of all the information in place. This is included because it is common to perform exchange-in-place operations in algorithms, such as sorting. Syntatically,
```
exchange a with b
```
where `a` and `b` should have the following properties:

 - `a` and `b` are of the same type
 ```
 x = 1
 y = "clrs"
 z = 2
 exchange x with z # x is 2, and z is 1
 exchange x with y # this is an error
 ```
 - `a` and `b` carries values stored in the memory, meaning that literals are not allowed
 ```
 exchange 1 with 2 # this is an error
 ```

## 5.7 Input/Output
The `print()` statement can only be followed by strings. If variables are to be printed, it should be converted to string using `cstring` first. The only exception is when one attempts to print a single value whose type is not `string` without concatenation.

```
print("My test string")  # prints "My test string"
x = 5 
print(x)    # prints "5"
a = [1,2,3]
print(a)   # prints "[1,2,3]"
print(concat a with x) # error because x is not string
y = 4
print(x + y) # prints 9
```
Custom types cannot be printed.

The `input()` function will take an input from the user and store it in the associated variable. `input()` will always store the value as a string. To convert the input to an appropriate type, you should use explicit casting.

```
y = input() # user enters "5"
x = cint(y)  # x is 5, y is "5"
```
