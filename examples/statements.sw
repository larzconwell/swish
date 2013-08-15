# if...else, for...in, until, switch...case, and trap statements all have a common feature,
# none of them have parenthesis around the expression.

if 1 {
  echo "1 is true"
}

if 0 {
  echo "0 is true" # doesn't execute
} else {
  echo "0 is false"
}

# the `for...in` loop is used to loop over Arrays and Objects.
items = ['somestr' 1.0 42.0e-4]
for index value in items {
  echo index value
}

obj = {'user': 1 'user2': 2}
for key value in obj {
  echo key value
}
# the `in` keyword returns two values for every loop evaluation,
# the first is the key or index, the second; the value. The value
# are seperated by spaces or commas, and you can ignore the second.

# The `until` is used to do looping a number of times.
i = 0
until i >= 5 {
  i++
}

# Multiple case values can be given in one statement, typically this is done by making two
# case statement and letting one fallthrough. The values can be seperated by spaces or commas.
switch i {
  case 2:
    echo "i is 2"
    break
  case 3 4:
    echo "i is either 3 or 4"
    break
  case 5:
    echo "i is 5"
    break
  default:
    echo "i is unknown"
}

# You can trap Unix signals, and perform tasks when they happen. The Unix signals are all
# predeclared identifiers in Swish.
trap SIGINT {
    echo "Caught SIGINT"
}
