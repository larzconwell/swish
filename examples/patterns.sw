path = /some/path # Simple example of a Pattern using the directory seperator

uptime version = /proc/{uptime version} # Brace expansion, expands the pattern to multiple patterns
                                        # each with the same sequence before and after the braces.
                                        # Also patterns may expand to multiple Strings, as seen here.

home = ~ # Tilde expands to your `HOME` environment variable.
desktop = ~Desktop # If no directory seperator is between the tilde and another character, then
                   # it'll expand to the subdirectory of the sequence given in your `HOME` directory.

user = 'user'
home = /home/#{user} # Value expansion evalutes the expression in the `#{}` sequence and replaces
                     # it with the returned value. If multiple values are returned it expands in
                     # the same fashion as the brace expansion.

desktop = ~/* # `*` is a wildcard that matches any file that exists and matches the full pattern
              # value so far.

home = ./user # `.` is expanded to the current working directory. It's only replaced if the next
              # character sequence is a directory seperator or if no sequence is next.

root = ../ # `..` expands to one directory above the current working directory. The number of `.`
           # depict how many directorys to traverse up to. The sequence is only replaced if the next
           # sequence is a directory seperator or no seperator.
