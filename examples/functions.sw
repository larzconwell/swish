# Function argument identifiers are optional, if an argument is not
# set its value is `nil`.
add(num1 num2) {
  if (num1 == nil || num2 == nil) {
    return nil
  }

  return num1 + num2
}

# The `return` statement can take any number of arguments of any value.
# These arguments can of course be sperated by commas or spaces. If no
# arguments are given it only returns `nil`.

# Functions include a variable called `arguments` which is an Object with
# the argument names and values.
add(num1 num2) {
  num = 0

  for (i v in arguments) {
    num += v
  }

  return num
}

# Function arguments may be variadic, gathering all the arguments for it
# into an Array of values.
add(...nums) {
  num = 0

  for (i in nums) {
    num += i
  }

  return num
}

# When calling Functions the parenthesis are optional. Arguments are seperated
# by spaces or commas.
add(10, 15, 1.0)
add 10 15 1.0
