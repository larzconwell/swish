cat /proc/uptime >> /tmp/uptime # `>>` sends the stdout of the Function on the left to the
                                # file on the right, overwriting contents.

cat /proc/uptime >>> /tmp/uptime # `>>` sends the stdout of the Function on the left to the
                                 # file on the right, appending contents.

cat /proc/uptime 2>>> /tmp/uptime # `n>>` sends the file descriptors contents to the file on the
                                  # right, the descriptor can only be 0-2. The same format is
                                  # used for appending but uses `n>>>`.

cat /proc/uptime 2>>1 # `n>>n` sends the contents of one file descriptor to another. The file
                      # descriptors must be between `0` and `2`.

cat /proc/uptime &>> # `&>>` sends both stdout and stderr to the file on the right, overwriting
                     # contents. The appending varient is the same format, `&>>>`.

cat << /proc/uptime # The `<<` operator reads the file contents of the path on the right
                    # and sends it to the Function as stdin on the left.

cat /proc/uptime | cat # `|` sends the stdout from one Function to the stdin of another Function.

cat /proc/uptime &| cat # `|` sends the stderr from one Function to the stdin of another Function.
