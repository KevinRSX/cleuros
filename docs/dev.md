# Development

## Remaining work for frontend

As of the submission of hello-world deliverable.

### Delimitation

- Too complicated to support newline-delimited statements and indentation-based code blocks as in the LRM. So temporarily switched to semicolon-delimited statements and brace-based code blocks

### Not-yet-implemented features

Tokens:

```
binops: >=, <=, !=, and, or, exponential
literals: char, string, array, custom type literals
built-in: concat ... with ...
control flow: for loop
```

Other features:

- Declaration of char, string, array, and custom type
- Mandate the existence of `MAIN()`
- Scope **inside** functions
- Built-in functions, including type checking, type casting, and I/O. This may also mean we need to support function overloading. Should we implement them in code generation or a standard library?