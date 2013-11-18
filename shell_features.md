- Pattern expressions yielding a string or array, going through multiple expansions passes just
like the bash expansions.
- Undefined identifiers are pattern expressions, unless the expression is only the identifier in
which case it's a function call.
- `PATH` array var that updates command functions when it's changed, leaving overwritten commands
functions alone.
- Signal string variables are declared to be used in trap statements.
- Environmental variables are defined as string variables in the global block.
- Variables are exported to commands unless they are declared with a `local` preidentifier, and
exported if given a `export` preidentifier.
- Trap statement that will wait for a signal to occur and then run a block.
- Exit statement exits the process with the given number or `0`.
- Predeclared `cmd()` function that will execute the command function that was created when `PATH`
was changed. Meaning if a command function was overwritten it'll run the original function.
- Functions declared for all binaries in `PATH` directories, may be overwritten but still accessed
by `cmd()`. Arguments may only be strings, if not a conversion occurs. Returns exit code.
- If statement has dash arguments immediately after `if` that will check for path existance in FS.
See [here](http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html) for examples.
- Process function in background by appending `&` at very end of function call. Returns `0`.
- Redirect a functions stdio to files or other stdio. Goes after the function calls arguments but
before any background delimiter. If `n` is given it may either be `1`(stdout) or `2`(stderr).
  - `> file` Overwrite `file` contents with stdout.
  - `>> file` Append stdout to `file`.
  - `n>` Overwrite `file` with contents from `n` file descriptor.
  - `n>>` Append `n` file descriptor contents to `file`.
  - `n>n` Copy contents from one file descriptor to another.
  - `&>` Overwrite `file` contents with stdout and stderr.
  - `&>>` Append stdout and stderr to `file` contents.
  - `< file` Redirect `file` contents to function as stdin.
  - `| function` Write stdout to the stdin of the `function` call running both at the same time.
  - `&| function` Write stderr to the stdin of the `function` call running both at the same time.
