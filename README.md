# Swish
Swish is a language designed for shell scripting and command line integration. It's heavily inspired by Go, but takes several features from classic shell scripting languages syntax so it's easier to write in interactive environments.

### Goals
- Small language syntax
- Easy to learn and write
- Embeddable

### Install
Use the Go tool to install swish.
```
go get github.com/larzconwell/swish
```

### Usage
To run a swish script, simply pass it in as an argument.
```
swish script.sw
```

Or you can run it as an executable, using the shebang method on Unix.
```
#!/usr/bin/env swish

##
  Some code here
##
```

### License
This implementation of Swish is MIT licensed, see [here](https://raw.github.com/larzconwell/swish/master/LICENSE).
