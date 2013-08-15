str = "Strings can have double or single quotes, both act exactly the same."

str = str + ' Appending strings can be done with the addition operator.'

str = "Strings are multi-line by default
and preserve spacing and newlines."

str = "Multi-line strings can be disabled by using a \
       at the end of the line, the text after used in \
       place until the next newline or \\ character"

chars = "#{len str}" # Strings support interpolation, and replace the sequence
                     # with the first value the expression returns.

str = "string"
char = str[0] # Strings can be indexed in the same fashion as Arrays, except range indexing.
