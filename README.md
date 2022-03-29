# cleuros

------------------------
First, change to the lib directory `cd lib`


To build: `make` 

To test:`make run`

To clean: `make clean`

## Current State
Indentation level calculation is too complicated, so we decided to defer it until we finish all the other parts of the front end. For now, we use the following syntax:
```
{
    stmt1
    stmt2
}
```
wherever we need indentations, including meaningless code blocks, if-else, while, for, function calls, custom type definition
