# Bug Report

Codes that will produce the bugs are marked.

## 1. Void Expressions

Some expressions in CLeuRoS should be void, according to the LRM. Examples are `exchange with` and array assignments. However, OCaml LLVM does not have a way to return void type. There are `Llvm.const_{int,float}`, but there is no `Llvm.const_void`. The workaround is using a constant int whose value is 0 in places of void.

```
L.const_int i32_t 0 (* Bug #1 *)
```



## 2. Array Literal

The type of array literal are supposed to be `Array arr_type` per our semantic checker. However, we do not find an appropriate place way to infer array literal's type. Workaround is the same as Bug #1: use a constant int whose values is 0 in place of generating LLVM IR for `SArrayLit`.