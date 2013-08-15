cat /proc/uptime # Commands are just Functions created for you from
                 # your `PATH` environment variable.

exit, stdout, stderr = cat /proc/uptime # Commands returns three values, the first
                                        # being the exit code, the second stdout, and
                                        # and the last is the stderr.
                                        # Note: Exit codes > `0` are usually failures.

uptime = /proc/up#{echo "t"}ime # Commands called in Pattern or String interpolations
                                # are special cases where just the stdout is returned.

# Though this example is redudant as it just calls the `cat` command anyway, but illustrates
# the puprose well. Command Functions can be overwritten, but the original command
# can still be accessed by the `cmd` built-in Function.
cat(file) {
  cmd cat file
}

# When calling commands before starting the process, the arguments given are converted
# to Strings, since that's the only value they support.

# When you update the `PATH` environmental variable in your program the built in commands
# are updated as well.
