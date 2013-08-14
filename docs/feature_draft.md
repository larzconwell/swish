# Swish

### Comments
```
# Single-line comments

##
  Multi-line comments
##
```
Comments with a single `#` continue until the end of the line. Comments with `##` continue until
another `##` sequence is encountered. Comments do not nest.

### Function Declarations
```
name(arg ...arg2, arg3) {
  # Function body
}
```
Functions can have any number of arguments, and they are all optional. If the body doesn't have an
explicit return statement at the end then it returns nil. Argument names are seperated by spaces
or commas. Arguments that weren't given values, are set to nil. Functions also define a variable
called `arguments` and it's an object of the argument names and values. Arguments may be variadic,
these arguments are prepended with `...` and any arguments until the next argument are joined
together into an array.

### Calling Functions
```
name(arg1 arg2_0, arg2_1, arg3)

# OR

name arg1 arg2_0, arg2_1, arg3
```
When calling functions the parenthesis are optional. Arguments may be seperated by spaces or
commas. Values that don't belong to another type are assumed to be function calls.

### Types

#### Nil
Nil is a type and the only value implementing that type is `nil`. This value is used to notify
when something wasn't given. `nil` is considered a falsey value.

#### Number
```
1        # Integer
1.0      # Float
0xBADa55 # Hexidecimal
0600     # Octal
.42e-5   # Float with an exponent
```
Numbers are a blanket type for integers, octals, hexidecimals, floats, etc. The size of the
numbers grow automatically when they overflow. `0` is the only falsey number value.

#### String
```
"text"

# OR

'text'
```
Strings are immutable byte sequences. Strings are block strings by default preserving new lines
and spacing. If a sequence of `\` is encountered before a newline it switches to standard strings
and ignores newlines for the line and any spacing after the newline until the next newline or `\`.
Strings do interpretation for sequences inside the following sequence in the string `#{}`. This
will interpret the body and replace it with whatever it returns. Strings have the same indexing
rules as arrays. To concact strings together use the addition operator.

#### Pattern
```
/some/path
# -> "/some/path"

a{,a v}e
# -> "ae", "aae", "ave"

~/some/path
# -> "/home/user/some/path"

~some
# -> "/home/user/some"

/some/#{variable}
# -> "/some/path"

/some/#{ls ~some}
# -> "/some/path.json", "/some/path1.json"

/some/*.json
# -> "/some/path.json", "/some/path1.json"

./some/path
# -> "/home/user/some/path"

../some/path
# -> "/home/some/path"

.../some/path
# -> "/some/path"
```
Patterns are temporary types that are parsed using the following rules and then output a abitrary
number of strings.
1. Values with directory seperators are considered as patterns.
2. Brace expansion: `a{a b, c}e`
  - The items inside the `{}` sequence are expanded to create the number of items inside. The
    items created prepend and append the text surrounding the sequence. Items can be seperated by
    spaces or commas.
3. Tilde expansion: `~`, `~Desktop`
  - The tilde expands to the directory of your home. If a value is given immediately after the
    tilde with no spaces or directory seperators then it expands to the subdirectory of the value
    inside the home directory.
4. Value expansion: `#{}`
  - Value expansion interprets the body inside the sequence and replaces it with the returned
    value(s). If the sequence returns multiple values it will expand in the same fashion as the
    brace expansion.
5. File expansion: `*`, `.`, `.[...]`
  - These expansion rules are aware of the current working directory and the file system. The `*`
    sequence is a wildcard matching any character for a file that exists and matches the rest of
    the current pattern value. The `.` sequence denotes the current working directory and only
    replaces if there's no sequence after or the next sequence is a directory seperator. The
    `.[...]` matches any number of `.` sequences in a row greater than 1, the number of periods
    denotes how many parent directories to traverse. The sequence is only replaced if there's no
    sequence after or the following sequence is a directory seperator.

#### Array
```
['item', /some/path 1.0]
```
Arrays are a reference type, and can have any number of values with any type. Array values are
seperated by spaces or commas. Arrays of numbers can quickly be created with the range delimiter,
to create a range array do `[s:e]` where `s` is the starting number and `e` is the ending number.
Array items can be indexed with the sequence `[n]` following the array literal or identifier, `n`
is the index starting from `0`; the sequence can also be a range, where either the starting or
ending value is optional, and if not given will use `0` or the max index. Indexing does not
overflow, if the index number/range is greater than the number of items in the array, the items
after the last will be replaced with `nil`. When indexing, two values are returned, the first
being the value of the item at the given index, the second being an "okay" value to check if the
item exists or was an overflow. Arrays can be destructed into multiple values(for example to give
a function multiple arguments, or to return mutiple values from a function) using the `...`
delimiter after the identifier. To add array items you can use the built-in `append` function or
by setting the value from an overflowing index(e.g. `identifier[10000] = "value"`).

#### Object
```
{'key': 'value' 'key2'= 1.0}
```
Objects are a reference type and are unsorted and can have any number of key/value pairs with
string keys and values of any type. Pairs are seperated by spaces or commas, and keys and values
are seperated by colons or `=`. Indexing objects are similar to arrays, except instead of numbers
to get a index, you give a string. Just as indexing overflowing array items, indexing object keys
that don't exist will return nil with a falsey "okay" second value. Indexing objects doesn't allow
ranges. To add new items to the object simply use the format similar to variables
`identifier["key"] = "value"`, or you can use the built-in `append` function.

### Semicolons
Semicolons are used to terminate a statement or expression. Most Swish programs may omit them
following the given rules.
1. When the input is broken into tokens, a semicolon is automatically inserted into the line if
   the last token is
  - an identifier
  - an literal
  - one of the keywords `break`, `continue`, `return`, and `exit`
  - one of the operators and delimiters `++`, `--`, `)`, `]` `}`, or `&`
2. To allow complex statements to occupy a single line, a semicolon may be omitted before a
   closing `)` or `}`.

### Predeclared Identifiers
```
nil
append() copy() delete()
len() typeof() cmd()
```
Other variable identifiers include the Unix signals in all caps. Details of the predeclared
functions are discussed later.

### Keywords
```
until for in break continue
switch case default
local export
if else
return exit
trap
```
Keywords are reserved and may not be used as identifiers.

### Operators and Delimiters
```
! ++ --
&& || == != < <= > >=
= += -= *= /= %= ||= &&=
( ) [ ] { } , ; ... . ~ :
+ - * / %
& >> >>> &>> &>>> << | |&
```

### Variables
```
name = "value"
path path1 = /some/*
```
By default variables are exported identifiers. Exported identifiers are added to the environment
for commands that are called in the current and child scopes. To create a variable that's not
exported as an environmental variable use the `local` preidentifier before the identifier name. You
can also explicitly set the variable to export with the `export` preidentifier. Multiple values
can be assigned at the same time(e.g. a function returning multiple values) using the following
syntax: `name, name2 = expression` where identifiers are seperated by spaces or commas, if a
preidentifier is given all the variables use it.

### Scope
Scopes are seperated by blocks(i.e. `{ [body] }`), and the current scope always inherits parent
scopes, but takes precendence over them. So exported variables in a parent scope will still be
exported to a command you call in the current scope; but can be overwritten for the current scope.

### Statements

#### Conditionals
```
if expression {
  # 1
} else {
  # 0
}
```
Nothing to surprising about conditional statements, most notably is the lack of parenthesis around
the testing expression.

#### Loops
```
for index value in identifier {
 # loop body
}

until expression {
  # loop body
}
```
There are two kinds of loops in Swish, the first is the standard for loop. This loop isn't as
expressive as most languages, it is only used in conjunction with the `in` keyword to loop over a
set of items. The for loop goes through the items in the given identifier and gives two values,
the first is the index/key and the second being the value for the index/key; they're seperated by
spaces or commas.
The next loop is the until loop, it is more general and should be used for number looping. The loop
body is executed until the expression is truthy.

#### Switch
```
switch expression {
  case "value":
    break
  case "value" ~:
    break
  default:
    # something
}
```
Nothing to special about switch..case statements, case statements fallthrough as usual, a default
statement is allowed for no matching case statement, etc. One notable feature is a case statement
can have multiple values seperated by commas or spaces.

#### Trap
```
trap identifier {
  # trap body
}
```
Trap will register a function body to call when the given signal is caught for the program.

### Predeclared Functions

#### Return
```
return "value" 1.0
```
When returning from functions, if no values are given `nil` is returned. Multiple values can be
returned, and are seperated by spaces or commas. If returning at the global level, return can
only return numbers(integers specifically), defaulting to `0` after which exits the process with
the given return number.

#### Exit
```
exit 1
```
Exit will exit the process with the given number as the exit code, defaulting to `0` if none are
given.

#### Append
```
append(array value)

append object key, value
```
Append adds a new item to an array or object. This is preferred to the syntactic version of adding
items where you assign a value to a nonexistent key/index.

#### Copy
```
copy(array/object, identifier)
```
Copy will create a shallow copy of the given array or object to a identifier.

#### Delete
```
delete(object, key)
```
Delete removes a key/value pair from the given object. It returns the value for the pair(nil if
it didn't exist), and an "okay" value to determine if the key existed.

#### Len
```
len(array/object/string)
```
Len gets the length of the given value and returns it.

#### Typeof
```
typeof(value)
```
Typeof returns the type of the value as a lowercase string.

#### Cmd
```
cmd(command, ...args)
```
Cmd calls the original version of the command given, this is for commands that have been rewritten
as functions. It returns the same arguments as calling commands do.

### Shell Features

#### Commands
When a Swish program is ran it creates special functions for commands in the PATH exported variable.
These functions are called exactly the same as functions, but only strings are allowed as arguments.
Commands all return three values, the first is the exit code, then the stdout, and finally the
stderr. One special feature about commands is that when called in a string or pattern value
expansion block, it only returns the stdout value. Commands can be overwritten with functions
and the original command can be called from the built-in function `cmd`. When the PATH exported
variable is called in the Swish program, the commands are updated.

#### Background Processing
```
function() &
```
Functions(including commands) can run in the background and ignore the return values by appending
the `&` character after the function. The function immediately return and continue the rest of the
program. The `&` operator goes after any function redirections.

#### Function Redirection
```
function() redirection
```
Redirection identifiers redirect the output of a function in different ways. The following
operators direct various ways to redirect output.
- `>>` Redirects stdout to the path given on the right overwriting contents.
- `>>>` Redirect stdout to the path given on the right appending contents.
- `n>>` Redirects the contents from `n`; a file descriptor from 1-2 to the path on the right
  overwriting contents.
- `n>>>` Redirects the contents from `n`; a file descriptor from 1-2 to the path on the right
  appending contents.
- `n>>n` Redirects the contents from one file descriptor to another, the descriptors must be from 1-2.
- `&>>` Redirects stdout and stderr to the path given on the right overwriting contents.
- `&>>>` Redirects stdout and stderr to the path given on the right appending contents.
- `<<` Redirects the contents from the path on the right to the stdin of the function.
- `|` Redirects the stdout of a left command to another on the right.
- `|&` Redirects the stderr of a left command to another on the right.
