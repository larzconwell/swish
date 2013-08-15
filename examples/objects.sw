users = {
  'larzconwell': {'id': 1 'contributor': 1}
  'someoneelse' = {'id' = 2 'contributor' = 0}
}
# Object pairs are seperated by spaces or commas, and keys and values are seperated by
# equals or colons. Objects keys must be Strings, values can be of any type.

user, ok = users['larzconwell'] # Indexing Objects are similar to Arrays except you use Strings
                                # instead of Numbers, and you cannot do range indexing.

user, ok = users['somecontributor'] # Just as Arrays, indexing nonexisting Object keys will
                                    # yield `nil`, and an `0` "ok" value.

users['somecontributor'] = {'id' = 3 'contributor' = 1} # To add a item to an Object just
                                                        # Set the value for the given key.
append users 'anothercontributor' {'id' = 4 'contributor' = 1} # Or use the built-in `append`
                                                               # Function.
