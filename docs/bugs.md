# Bug Report

Codes that will produce the bugs are marked.

## 1. Void Expressions

Some expressions in CLeuRoS should be void, according to the LRM. Examples are `exchange with` and array assignments. However, OCaml LLVM does not have a way to return void type. There are `Llvm.const_{int,float}`, but there is no `Llvm.const_void`. The workaround is using a constant int whose value is 0 in places of void.

```
L.const_int i32_t 0 (* Bug #1 *)
```



## 2. Array Literal

The type of array literal are supposed to be `Array arr_type` per our semantic checker. However, we do not find an appropriate place way to infer array literal's type. Workaround is the same as Bug #1: use a constant int whose values is 0 in place of generating LLVM IR for `SArrayLit`.



## 3. Strings

String support is EXTREMELY limited right now. We only support string literals, no assignments, no binary operations such as concatenation, no others!

That is, only this works:

```
PRINT("xyz")
```

This does not work:

```
s := "xyz" # LLVM will allocate a pointer to i32_t, instead of a pointer to a pointer to i8_t, for s, which is awful
PRINT(s)
```

Workaround: let the compiler complain when this happens



## 4. String Literal

The String literal in scanner is flawed as its regex uses an inclusive pattern (letter OR punctuation OR number OR ...) instead of an exclusive one (everything but \ and ""). Some patterns cannot be recognized. We currently just avoid printing those patterns.



## 5. Type Casting

Type casting should be supported rigorously as defined in the LRM, but we failed to complete any of them. We did have an implementation for float to int automatic casting. However, the IR generation has bug for stored float, so it has been removed.

