# Swish


## Introduction
Swish is a dynamically typed language designed for shell scripting and command line integration.

The grammar is compact and designed in a way that should feel familiar with developers.


## Notation
The syntax in this document is specified using [Extended Backus-Naur Form(EBNF)](https://en.wikipedia.org/wiki/Extended_Backus-Naur_Form).

A few additions have been made to the standard form:

- A range of alternatives can be expressed with the form `"a" ... "b"`, which represents a set of
characters from `a` to `b` as alternatives.
- Repeating a value a number of times can be expressed with the form `value*n` where the value is
repeated `n` times.

Production rules starting with a capital letter are considered major language rules, while ones
starting with lower case letters are used to construct other rules.


## Source code representation
Source code is Unicode text encoded as UTF-8. Text is not canonicalized, so a single accented
code point is distinct from the same character constructed from combining an accent and a letter;
those are treated as two code points. This document refers to a Unicode code point as a _character_
in the source text.

Each character is distinct; for instance, upper and lower case letters are different characters.

### Characters
The following productions are used to denote specific Unicode character classes:
```
newline = (* Unicode code point U+000A *) ;
unicodeChar = (* Any Unicode code point except U+000A *) ;
unicodeLetter = (* Any Unicode code point in the categories Lu, Ll, Lt, Lm, and Lo *) ;
unicodeDigit = (* Any Unicode code point in the category Nd *) ;
```

The [Unicode Standard 6.2](http://www.unicode.org/versions/Unicode6.2.0/), Section 4.5
"General Category" defines the code point categories mentioned above.

### Letters and digits
```
letter = unicodeLetter | "_" ;
decimalDigit = "0" ... "9" ;
octalDigit = "0" ... "7" ;
hexDigit = "0" ... "9" | "A" ... "F" | "a" .... "f" ;
```

In Swish, the underscore character(U+005F) is considered a letter.


## Lexical elements
### Comments
There are two forms of comments:

1. _Line comments_ start with the character sequence `#` and stop at the end of the line.
2. _General comments_ start with the character sequence `##` and continue until the next `##`
character sequence.

### Tokens
There are four classes of tokens: _identifiers_, _keywords_, _operators and delimiters_, and
_literals_. _White space_, formed from spaces(U+0020), horizontal tabs(U+0009),
carriage returns(U+000D), and newlines(U+000A), are mostly ignored only being significant to
separate tokens that would otherwise combine into a single token. Spaces are an exception being
an optional way to seperate lists of items in place of commas(U+002C). Also, newlines or end of
file may trigger the insertion of a semicolon. While breaking input into tokens, the next token is
the longest sequence of characters that form a valid token.

### Semicolons
The formal grammar uses semicolons(U+003B) as terminators in a number of productions. Swish
programs may omit most semicolons using the following rules:

- When input is split into tokens, a semicolon is automatically inserted into the token stream at
the end of a non-blank line if the lines final token is
  - an identifier.
  - an number, string, array, or object literal.
  - one of the keywords `break`, `continue`, `fallthrough`, or `return`.
  - one of the operators and delimiters `++`, `--`, `...`, `)`, `]`, or `}`.
- To allow complex statements to occupy a single line, a semicolon may be omitted before a
closing `)` or `}`.

To reflect idiomatic use, code examples in this document elide semicolons using these rules.

### Identifiers
Identifiers name program entities such as variables and functions. An identifier is a sequence of
one or more letters and digits, though the first character must be a letter.
```
Identifier = letter , { letter | unicodeDigit } ;
```

_Examples:_
```
ä
argv
_x9
PATH
```

Some identifiers are predeclared and are described below.

### Keywords
The following keywords are reserved and may not be used as identifiers.
```
if      else   for       in
until   break  continue  fallthrough
switch  case   default   return
```

### Operators and Delimiters
The following character sequences represent operators, delimiters, and other special tokens:
```
!    ++  --   &&  ||  ==
!=   <   <=   >   >=  =
+=   -=  *=   /=  %=  ||=
&&=  (   )    [   ]   {
}    ,   ;    +   -   *
/    %   ...  :
```

### Number literals
A number literal is a sequence of characters describing integers and floating-point numbers.

For integers an optional prefix sets a non-decimal base: 0 for octal, and 0x or 0X for
hexadecimal. In hexadecimal literals, letters a-f and A-F represent values 10 through 15.

For floating-points there are different parts, including an integer part, decimal part, a
fractional part, and an exponent part. The integer and fractional parts comprise decimal digits;
the exponent part is an e or E followed by an optionally signed decimal exponent. One of the
integer part or the fractional part may be elided and one of the decimal point or the exponent may
be elided.
```
NumberLit = decimalLit | octalLit | hexLit | floatLit ;
decimalLit = ( "1" ... "9" ) , { decimalDigit } ;
octalLit = "0" , { octalDigit } ;
hexLit = "0" , ( "x" | "X" ) , hexDigit , { hexDigit } ;
floatLit = ( decimals , "." , [ decimals ] , [ exponent ] ) |
            ( decimals , exponent ) |
            ( "." , decimals , [ exponent ] ) ;
decimals = decimalDigit , { decimalDigit } ;
exponent = ( "e" | "E" ) , [ "+" | "-" ] , decimals ;
```

_Examples:_
```
42
0600
0xDEADBEEF
0.
65.40
4.e+0
20E6
.15e-5
```

### String literals
A string literal is a sequence of characters, there are three forms: raw string literals, and
double and single quoted interpreted string literals.

Raw string literals are character sequences between back quotes(U+0060). Within the quotes, any
character is valid except the back quote. The value of a raw string literal is the string of
uninterpreted UTF-8 encoded characters. The main differences from the interpreted string formats
are newlines are accepted and backslashes have no special meaning.

Interpreted string literals are character sequences between either double(U+0022) or single(U+0027)
quotes. The text in the quotes, which may not contain newlines, forms the value of the literal
after backslash escapes have been interpreted. Backslash escapes are detailed below.

Double quoted interpreted string literals also go through another interpretation step, which
interprets a given expression(which must be single valued) inside the brackets of the sequence
`${}` and replaces the sequence with the returned value represented as a string.

The following backslash values are escaped to the appropriate value:
```
\xHH - Where H is a hexadecimal digit
\uHHHH - Where H is a hexadecimal digit
\UHHHHHHHH - Where H is a hexadecimal digit
\OOO - Where O is an octal digit

\a U+0007 - Alert or bell
\b U+0008 - Backspace
\f U+000C - Form feed
\n U+000A - Line feed or newline
\r U+000D - Carriage return
\t U+0009 - Horizontal tab
\v U+000b - Vertical tab
\\ U+005c - Backslash
\' U+0027 - Single quote
\" U+0022 - Double quote
```

```
StringLit = rawStringLit | singleInterpretedStringLit | doubleInterpretedStringLit ;
rawStringLit = "`" , { unicodeChar | newline } , "`" ;
singleInterpretedStringLit = "'" , { unicodeValue | byteValue } , "'" ;
doubleInterpretedStringLit = '"' , { unicodeValue | byteValue | ( "${" , Expression , "}" ) } , '"' ;
unicodeValue = unicodeChar | littleUValue | bigUValue | escapedChar ;
byteValue = octalByteValue | hexByteValue ;
octalByteValue = "\" , octalDigit*3 ;
hexByteValue = "\x" , hexDigit*2 ;
littleUValue = "\u" , hexDigit*4 ;
bigUValue = "\U" , hexDigit*8 ;
escapedChar = "\" , ( "a" | "b" | "f" | "n" | "r" | "t" | "v" | "\" | "'" | '"' ) ;
```

_Examples:_
```
`abc`
`
  ` # Same as "\n "
"日本語"
"${value}" # Is "swish" if the identifier `value` is equal to "swish"
'\U000065e5\U0000672c\U00008a9e' # Explicit Unicode code points
'\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e' # Explicit UTF-8 bytes
```

### Array literals
Array literals create a new array type value with a list of values.
```
ArrayLit = "[" , [ expressionList | rangeLit ] , "]" ;
expressionList = Expression , [ "..." ] , { ( itemSeparator ) , Expression , [ "..." ] } , [ "," ] ;
rangeLit = [ Expression ] , ":" , Expression ;
itemSeparator = "," | " " ;
```

When creating a range array, the given expressions(which must be single valued) must yield a
positive number typed value. The left expression may be omitted, which uses `0`. The right
expression must be greater than or equal to the left expression(or `0`). An array of numbers are
created from the left expression(or `0`) to the right expression minus one.

_Examples:_
```
[]
["string"]
[5 "string", ["array"]]
[5,]
[10:100]
[:5]
```

### Object literals
Object literals create a new object type value. All values must have a key, and keys may only be of
string and number type.
```
ObjectLit = "{" , [ objectList ] , "}" ;
objectList = objectItem , { ( itemSeparator ) , objectItem } , [ "," ] ;
objectItem = Expression , ( keyValueSeparator ) , Expression ;
keyValueSeparator = ":" | "=" ;
```

_Examples:_
```
{}
{"key" = "value"}
{"key": "string" 5: {"key" = "value"},}
```


## Types
### Nil type
The nil type represents a non existing value, the only value using the nil type is the predeclared
`nil` identifier.

Values of `nil` type are falsey.

The predeclared nil type is `nil`.

### Number type
The number type represents integer and floating point values.

Number type values have arbitrary precision and do not overflow. A number value of `0` is falsey,
all other numbers are considered truthy.

The predeclared number type is `number`.

### String type
The string type represents a set of string values, a string value is a (possibly empty) sequence
of bytes, and are immutable; once created, it's impossible to change the strings contents.

The length of a string(it's size in bytes) can be discovered using the built-in `len()`. Individual
bytes can be accessed using index expressions.

The predeclared string type is `string`.

### Array type
The array type is a numbered sequence of elements of any type. Array values may be
multi-dimensional.

The length of an array can be discovered using the built-in `len()`. Individual elements may be
accessed using index expressions. Adding or assigning keys may done using assignments or with the
built-in `append()`.

The predeclared array type is `array`.

### Object type
The object type is an unordered group of elements of any type. Elements are indexed with a key of
either string or number type.

The length of an object may be discovered with the built-in `len()`. Accessing items can be done
with the index expressions, adding or assigning values can be done with assignments or the
built-in `append()`. Keys may be removed with the `delete()` built-in.

The predeclared array type is `object`.

### Function type
The function type is a type given to all function declarations. Function declarations are detailed
below.

The predeclared function type is `function`.

### Type identity
Two types are either identical or different.

Comparing values of different types are always different.
Values with the `nil` type are always identical.

Two values of the same type are identical following the given rules:

- Two numbers are identical if they're the same after conversions.
- Two strings are identical if the length is the same, and the characters match.
- Two arrays are identical if the values point to the same reference
- Two objects are identical if the values point to the same reference
- Two functions are identical if the values point to the same reference

### Evaluation strategy
When values are evaluated in expressions they are passed in different ways. The following rules
define how different types should be evaluated.

- String and number types are [pass by value](https://en.wikipedia.com/wiki/Evaluation_strategy#Call_by_value).
- Nil, array, object, and function types are implemented as [pass by sharing](https://en.wikipedia.com/wiki/Evaluation_strategy#Call_by_sharing).


## Blocks
A block is a possibly empty sequence of declarations and statements within brace brackets.
```
Block = "{" , statementList , "}" ;
statementList = { Statement , ";" } ;
```

In addition to the explicit blocks in source code, some implicit blocks exist:

- Global block, encompassing all source text
- Each `if`, `else`, `for`, and `switch` statement has their own block
- Each `case` and `default` clause in a `switch` statement have their own block

Blocks nest and influence scoping.


## Declarations and scope
A declaration binds a non-blank identifier to a variable or function. Every identifier in a
program must be declared. Identifiers may be overwritten.

```
Declaration = FunctionDecl ;
```

The scope of a declared identifier is the extent of source text in which the identifier denotes the
specified variable or function.

Swish is lexically scoped using blocks:

1. The scope of predeclared identifiers, and identifiers declared at top(that is, not in another
block) is the global block.
2. The scope of an identifier denoting a function parameter is the function body.
3. The scope of an identifier inside a function body ends at the end of the innermost containing
block.

An identifier declared in a block may be redeclared in an inner block. While the identifier of the
inner declaration is in scope, it denotes the value declared by the inner declaration.

### Blank identifier
The blank identifier, represented by the underscore character(U+005F), may be used in a
declaration like other identifiers but the declaration doesn't introduce a new binding.

### Arguments identifier
All Swish programs have a predeclared identifier called `argv`, it's an array of string arguments
given to the swish program.

### Predeclared identifiers
The following identifiers are implicitly declared in the global block:
```
Types:
  nil number string array object function
Values:
  nil
Functions:
  append copy delete len typeof
```

### Variable declarations
Variable declarations are part of assignments discussed below in the statements section.

### Function declarations
A function declaration binds an identifier to a function.
```
FunctionDecl = Identifier , functionSignature , Block ;
functionSignature = "(" , [ functionParamList ] , ")" ;
functionParamList = functionParam , { ( itemSeparator ) , functionParam } , [ "," ] ;
functionParam = [ "..." ] , Identifier ;
```

Within a list of parameters, some identifiers may not be given an argument; if that's the case
the value is `nil`.

At most one parameter may be prefixed with `...`, a function with such a parameter is called
variadic and may be invoked with zero or more arguments for the parameter. Variadic parameters are
never nil, and if no arguments are given for it, the length will be 0. Variadic parameters won't
assign more than one item to the list unless the parameters after it have been given a value.

The function body may omit any `return` statements, in which case `nil` would be returned.

All functions have a variable declared called `arguments` which is an object including all the
functions parameter names as the keys, with the values as the arguments given for the parameters.

_Examples:_
```
add() {}

add(num, num2,) { return num + num2 }

add(...nums final) {
  ans = 0

  for _, v in arguments {
    if typeof(v) === "array" {
      for _, n in v {
        ans += n
      }
    } else {
      ans += v
    }
  }

  return ans
}
```


## Expressions
An expression specifies the computation of a value by applying operators and functions to operands.

### Operands
Operands denote the elementary values in an expression. An operand may be a literal, a identifier
denoting a variable or function, or a parenthesized expression.
```
Operand = Literal | Identifier | "(" , Expression , ")" ;
Literal = NumberLit | StringLit | ArrayLit | ObjectLit ;
```

### Primary expressions
Primary expressions are the operands for unary and binary expressions.
```
PrimaryExpression = Operand | PrimaryExpression , ( Index | Range | Call ) ;
Index = "[" , Expression , "]" ;
Range = "[" , [ Expression ] , ":" , [ Expression ] , "]" ;
Call = "(" , [ expressionList ] , ")" ;
```

_Examples:_
```
x
2
"string"
(x + ".txt")
add(1, 3, 6)
a[1]
a[1:2]
a[:100]
o["key"]
{"key": 5}["key"]
```

### Index expressions
A primary expression of the form
```
a[x]
```
denotes the element of the array, string, or object indexed by `x`. The value `x` is called the
index or object key, respectively. The following rules apply when indexing:

- If `a` is an array or string type:
  - The index `x` must be an number.
  - The index `x` is in range if `0 <= x < len(a)`, otherwise it's out of range.
- If `a` is an array type:
  - `a[x]` is the array element at the index `x`.
- If `a` is a string type:
  - `a[x]` is the byte at index `x`.
  - `a[x]` may not be assigned to, because strings are immutable.
- If `a` is an object type:
  - The key `x` may be a string or number.
  - `a[x]` is the value in the object with a key equal to `x`.

Types not mentioned above may not be indexed.

An index expression returns two values the first being the value of the at the index or object key,
while the second being a number notifying if the index or object key exists.
```
value, exists = [""][0]
value, exists = ["" ][1]
```
The second value is `1` if the index or object key exists in the array or object, and `0` if out of
bounds or the key doesn't exist in the object.

### Ranges
A primary expressions of the form
```
a[low:high]
```
Retrieves a range of elements of the array or string starting from `low`(or `0` if not given) up to
`high-1`(or `len(a)-1` if not given).

The range is possible if `0 <= low <= high <= len(a)`, otherwise it's out of range and only gets
the items that are in the range, and if none are in range an empty array is returned.

The resulting array has the same reference as the array being ranged, and assignments to indexes
in the range will reflect in the original array.

```
arr = [1, 2, 3, 4, 5]
arr[:len(arr)] # [1, 2, 3, 4, 5]
arr[:] # [1, 2, 3, 4, 5]
arr[2:] # [3, 4, 5]
arr[4:5000] # [5]
```

### Calls
Given the expression
```
add(1, x, 5)
```

calls `add` with the arguments `1`, `x`, and `5`. Arguments may be multi-valued expressions and are
evaluated before the function is called. If a function call has multiple return values and is
called as an argument to another function call, the return values are used as arguments for the
outer call.

If the number of arguments given to the function aren't the same as the number when declared the
parameters that don't have a value are set to `nil`.

If a parameter is variadic, more than one value may be given to it, as long as any parameters after
it have been given a value as well.

### Passing arguments to variadic parameters
If a function has a variadic parameter, it's an array type. The length of the variadic parameter is
the number of arguments from the first for the parameter up to the item before the next parameter.

Given the function declaration and call
```
add(start, ...nums, final) { ## ... ## }
add(10, 1, 3, 6)
```

Within `add`, the `nums` variable will have the value `[1, 3]`. If there was no `final` parameter
the `nums` variables value would be `[1, 3, 6]`, but before items can be added to variadic
parameters, the parameters after it must have a value.

When calling a function you may add "..." to string and array arguments, this will destruct the
value into multiple values. Here's an example which yields the same results and parameter values
as the example above.
```
arr = [1, 3, 6]
add(10, arr...)
```
Note: the last value in the `arr` array was used for the final parameter to the `add` call.

### Destructuring values with ...
Expressions may be destructured into multiple values by appending "..." after it. Only expressions
yielding an array or string type may do this.

In some places destructuring isn't allowed, such as assignments left operands, and the for
statements expression assignments.

### Operators
Operators combine operands into expressions.
```
Expression = UnaryExpression | Expression , binaryOp , UnaryExpression ;
UnaryExpression = PrimaryExpression | unaryOp , UnaryExpression ;
binaryOp = "||" | "&&" | relOp | addOp | mulOp ;
relOp = "==" | "!=" | "<" | "<=" | ">" | ">=" ;
addOp = "+" | "-" ;
mulOp = "*" | "/" | "%" ;
unaryOp = "+" | "-" | "!" ;
```

The `++` and `--` operator form statements instead of expressions, so they fall outside the
operator hierarchy.

_Examples:_
```
5 == 5
10 != 5
"string" && 5
!1
-1
5e2 * (10 * 100)
10 + 5 >= 15
6 % 2 == 0
```

### Operator precedence
Unary operators have the highest precedence.

There are 5 precedence levels for binary operators. Multiplication operators bind the strongest,
followed by addition operators, comparison, etc.:
```
Precedence  Operator
5           *   /   %
4           +   -
3           ==  !=  <  <=  >  >=
2           &&
1           ||
```

Binary operators of the same precedence associate from left to right.

### Arithmetic operators
The `+` operator may be used on strings as well as number, all other arithmetic operators
(`-`, `*`, `/`, `%`) are restricted to numbers only.

Strings can be concatenated using the `+` operator or the `+=` assignment operator:
```
s = "string" + "s"
s += " are cool"
```
String addition creates a new string from the expression.

For two number values `x` and `y`, the number quotient `q = x / y` and remainder `r = x % y`
satisfy the following relationships:
```
x = q * y + r and |r| < |y|
```

with `x / y` [truncated towards zero](http://en.wikipedia.org/wiki/Modulo_operation).
```
 x    y   x/y  x%y
 5    3    1    2
-5    3   -1   -2
 5   -3   -1    2
-5   -3    1   -2
```

### Comparison operators
Comparison operators compare two operands and yield a number value of 1 or 0.

The equality operators `==` and `!=` apply to operands that are comparable. The ordering operators
`<`, `<=`, `>`, `>=` apply to operands that are ordered. If a comparison is not comparable or
if not ordered the resulting value will be 0. Comparing values of different types will always
yield 0. These terms and the result of the comparisons are defined as follows.

- Number values are comparable and ordered, in the usual way if integers, if floating point numbers
comparing is defined by the IEEE-754 standard.
- String values are comparable and ordered, lexically byte-wise.
- Array values are comparable and ordered, checking ordering by the length of the array, and
comparing by the arrays reference, that is two arrays are equal if they have the same reference.
- Object values are comparable, comparing by the objects references.
- Function values are comparable, comparing by the functions references.

### Logical operators
Logical AND `&&` returns the left expression if falsey, otherwise returns the right expression.

Logical OR `||` returns the left expression if truthy, otherwise returns the right expression.

Logical NOT `!` returns `0` if the expression is truthy, `1` otherwise.

### Conversions
Conversions are expressions that converts a value of one type to another.
```
Conversion = ( "string" | "number" | "int" | "float" ) , "(" , Expression , ")" ;
```

Only numbers and strings have conversions, and if a conversion fails(such as a type that can't be
converted, or the value can't be converted to the type) `nil` is returned.

The conversions `number()` and `int()` function the same and the `float()` conversion exists to
convert a value to a number with floating point precision.

### Order of evaluation
When evaluating the operands of an expression, assignment, or return statement, all function calls
are evaluated in lexical left-to-right order.


## Statements
Statements control execution.
```
Statement = Declaration | Assignment | Block | ReturnStatement |
            BreakStatement | FallthroughStatement ContinueStatement |
            IfStatement | SwitchStatement | ForStatement | UntilStatement |
            EmptyStatement | ExpressionStatement | IncDecStatement ;
```

### Terminating statements
A terminating statement is one of the following:

1. A `return` statement.
2. A block in which the statement list ends with a terminating statement.
3. An `if` statement in which:
  - the `else` branch is present, and
  - both branches are terminating statements.
4. An `for` statement in which:
  - there are no `break` statements referring to the `for` statement, and
  - the loop condition is absent.
5. An `until` statement in which:
  - there are no `break` statements referring to the `until` statement.
6. A `switch` statement in which:
  - there are no `break` statements referring to the `switch` statement,
  - there is a `default` case, and
  - the statement list in each case, including the `default`, end in a terminating statement, or
  a `fallthrough` statement.

All other statements are not terminating.

A statement list ends in a terminating statement if the list is not empty and the final statement
is terminating.

### Empty statements
The empty statement does nothing.
```
EmptyStatement = ;
```

### Expression statements
Function calls may appear in a statement context. Such statements may be parenthesized.
```
ExpressionStatement = Expression ;
```

### IncDec statements
The `++` and `--` statements increment or decrement their operands by the number `1`. Only operands
that are addressable described in assignments, and have the number type may use these statements.
```
IncDecStatement = Expression , ( "++" | "--" ) ;
```

### Assignments
```
Assignment = expressionList , assignOp , expressionList ;
assignOp = [ addOp | mulOp | "||" | "&&" ] , "=" ;
```

Each left operand must be addressable, that is; a variable, blank identifier, or index expression.
Operands may be parenthesized. Left operands may not have the "..." delimiter after the operand to
destructure its value.

If the number of left and right operands don't match, the left over operands on either side are
left alone.

If a left operand is an identifier and it hasn't been declared, a variable with the corresponding
value is declared. This variable may only be declared if it's a simple assignment with no optional
binary operators.

If assigning to an array index, you are able to assign a value to an index that's out-of-bounds.
The value at the new index is set, and any index before it that are not set are given `nil` as a
value.

An assignment operation `x op= y` where op is a binary operator is equivalent to `x = x op y` but
only evaluates `x` once. The `op=` construct is a single token.

_Examples:_
```
x = 1
a[1000] = 2
o["key"] = "value"
x, y *= 4, 2
n ||= "value"
```

### If statements
If statements specify the conditional execution of two branches according to the value of a
expression. If the expression(which must be single valued) evaluates to a truthy value(i.e. not
`nil` or `0`), the `if` branch is executed, otherwise if an `else` branch is given it's executed.
```
IfStatement = "if" , Expression , Block , [ "else" , ( IfStatement | Block ) ] ;
```

_Examples:_
```
if x < 20 {
  x = 20
}

if x <= 20 {
  x *= 2
} else if x > 20 {
  x = 20
} else {
  x += 2
}
```

### Switch statements
Switch statements provide multi-way execution. An expression(which must be single valued) is
compared to the cases inside the switch statements to determine which branch to execute. The first
case that equals the switch expression triggers the execution of it's statements.
```
SwitchStatement = "switch" , [ Expression ] , "{" , switchClause , "}" ;
switchClause = switchCase , ":" , statementList ;
switchCase = "case" , expressionList | "default" ;
```

In a case or default clause, the last non-empty statement may be a `fallthrough` statement to
indicate that the execution should continue on through the next clause. The fallthrough statement
may not appear in the last clause in a switch statement.

If no expression is given then the switch statement compares it's clauses with `1`.

_Examples:_
```
switch typeof(x) {
  case "string":
    fallthrough
  case "array":
    iterate()
  case "number":
    count()
  default:
    notValid()
}

switch {
  case 0 < 10:
    doSomething()
}
```

### For statements
A for statement specifies a repeated execution of a block for a collection of items or an infinite
loop.
```
ForStatement = "for" , [ forIterator ] , Block ;
forIterator = expressionList , "in" , Expression ;
```

If an empty for statement is given, it loops continuously until a break statement occurs.

A for statement with the `in` keyword given, iterates through a single-value expression. For each
item in the evaluated expression(of type `array`, `string`, or `object`) an iteration is done
which assigns the iteration values to the iteration variables on the left and executes the for
block. Expressions yielding an unsupported type will not execute the for block, and the expressions
on the left must be addressable as described in assignments. Left expressions may not have the
"..." delimiter after the operand to destructure it.

Function calls on the left used to make an assignment are evaluated once per iteration. For each
iteration two values are produced the first being an index/key and the second which may be ignored
is the value at the index/key. Either variable on the left may be a blank identifier to discard
the value. The values produced are as follows:
```
Iterator type  1st value  2nd value(if present)
array          index      value at index
string         index      see below
object         key        value at key
```

- For arrays, the iterations are done in increasing order starting from the element index 0.
- For strings, iterations are done for Unicode code points encoded as UTF-8, starting from index 0
and up. On successive iterations, the index value will be the index of the first byte of successive
UTF-8 encoded code points in the string, and the second value will be the corresponding code point.
If the iteration encounters an invalid UTF-8 sequence the value will be `0xFFFD`, the Unicode
replacement character, the next iteration will advance a single byte.
- For objects, the iteration order is not specified and is not guaranteed to the be the same over
multiple for loops of the same object.

_Examples:_
```
x = 0
for {
  x++
  if x > 5 {
    break
  }
}

a = [0, 1, 2, 3]
for i, v in a {
  if i != v {
    break
  }
}

s = "string, ä"
for _, c in a {
  if c == "ä" {
    break
  }
}

o = {"user": "name"}
for k, v in o {
  if k != "user" {
    break
  }

  saveUser(v)
}
```

### Until statements
A until statement specifies a repeated execution of a block until a condition is satisfied.
```
UntilStatement = "until" , Expression , Block ;
```

Until statements execute the block first then evaluate the condition expression(which must be
single valued) afterwards, if the resulting value is truthy then the block doesn't execute another
time.

### Return statements
A return statement in a function terminates the execution of the function, a return statement in
outside of a function will terminate the program.
```
ReturnStatement = "return" , [ expressionList ] ;
```

Within a function any number of values may be given for the result. If no values are given `nil` is
returned.

Outside of functions, only one number value may be given, this will be used as the return code for
the program. If no value is given, `0` will be the return code.

### Break statements
A break statement terminates execution of the innermost `for`, `until`, and `switch` statement.
```
BreakStatement = "break" ;
```

### Continue statements
A continue statement skips to the next iteration of a `for` or `until` statement.
```
ContinueStatement = "continue" ;
```

### Fallthrough statements
A fallthrough statement transfers the control of a `switch` statement to the next clause. It may
only be used as the final non-empty statement in a clause, and not the final clause.
```
FallthroughStatement = "fallthrough" ;
```


## Built-in functions
The built-in functions are predeclared identifiers. They are called like any other function.

### Append
The `append` function appends an item to an array, and assigns a key/value to a object.

When appending to an array, the first argument is the array, the second being a variadic argument
containing any number of items to add to the array.

When appending to a object, the first argument is the object, the second being the key, and finally
a value for the key. If the value for the key is not given, will be set to `nil`.

The return value of `append` is `nil`.

### Copy
The `copy` function creates a shallow copy of an array or object.

The first argument is the array or object to copy and the return value is a shallow copy of the
argument with the same type.

### Delete
The `delete` function removes a key/value from an object.

The first argument is the object, and the second is the key to remove. If the key doesn't exist
or the object is `nil` delete is a no-op.

The return value is `nil`.

### Len
The `len` function retrieves the length of types including `string`, `array`, and `object`.

The only argument is the value to get the length of. The length of different types is as follows:

- String length is the number of bytes.
- Array length is the number of elements.
- Object length is the number of keys.

The return value is a number.

### Typeof
The `typeof` function retrieves the type of a given expression.

The only argument is the value to get the type of. The return value is a string.
