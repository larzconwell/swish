paths = [/some/path, /proc] # Values can be seperatd by spaces or commas.

numbers = [0:9] # Create ranges of numbers quickly with the range operator.

proc = paths[1] # Index Array items starting from `0`.

oneThroughFive = numbers[1:5] # Get a subset of Array items with the range operator as the index.

fiveThroughNine = numbers[5:]
zeroThroughFive = numbers[:5] # Leaving either range operator out in an index operation will
                              # set the ungiven value to the extreme on the side missing. So index
                              # `0` if the left isn't given and the length as the index if the
                              # right isn't given.

outOfBounds = numbers[10000] # Indexing out of the array bounds doesn't cause an error as usual,
                             # instead it returns `nil`.

number, ok = numbers[0] # Indexing returns two values, the first the value of the index or `nil`,
                        # and the second is a "ok" value to indicate if the index exists; it
                        # returns `1` if found, `0` otherwise.

path, proc = paths... # You can destructure Arrays into multiple values, to use as multiple function
                      # arguments, etc.

paths[2] = /dev # You can append items by setting a value to an out of bounds index.
append(paths, /home) # Or you can use the built-in `append` function for you.
