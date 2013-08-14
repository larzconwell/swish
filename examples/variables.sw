# Swish is a dynamic language, so variables values can change types over time.

name = "swish"

local value = 1.0 # Variables are exported to commands by default, use the `local`
                  # preidentifier to make them local to the script.

export value = "new" # Or you can use the `export` preidentifier explicitly
                     # to export it to commands environments.
                     # note: In this case the identifier `value` is no longer
                     #       a local identifier and the value is `"new"`

name, years = "swish" 1 # You can set multiple values at one time, the
                        # identifiers and values can be seperated by
                        # either commas or spaces. This is a common
                        # feature in Swish, throughout you'll see that
                        # anything seperated by commas can also be seperated
                        # by spaces.

local int float = 1, 1.0 # If you include a preidentifier before an assignment
                         # with multiple values all identifiers use it.
