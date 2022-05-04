# Ryan's MSDScript
This project allow you to run arithmetic calculation as expressions with the additional functionality such as algebraic
find and replace (such as replace `x` with `99`), JavaScript style functions, and if-then-else statements.  The main
purpose of this program is in the building of expressions which then can be calculated and returns a result.  An
expression can be as simple as `5 + 10` which returns `15`, or a bit more complex such as `_if 5 + 10 == 15 _then
50 _else 100` which would return `50`.

This documentation will walk you through how to build and run this script through the command line, where you can then
run expression and get results directly from the command line.  Also, how to integrate this project into your own existing
project allowing you to run calculations directly in your very own C++ project.

## Build Instructions

From the command line run `make`.  Here is an example of running `make` then running the program:
```
$ make
$ ./msdscript --interp
```
**Note:** This allows you to run this library from the command line.  If you are wanting to integrate this library into
an existing project, see [API Documentation](#api-documentation).

## Running MSDScript

### Script Modes
There are several modes that MSDScript can be run in.

* `--help` will print the same list seen here.
* `--test` runs script test to make sure all classes, functions and methods are working correctly.
* `--interp` allows you to input expressions and the script will return a result.
* `--print` prints out the inputted expression in simple format (e.g. `2+2` will return `(2+2)`).
* `--pretty-print` prints out the inputted expression in a formatted prettier.

#### Command Line Examples
```
$ ./msdscript --interp
2+2
Result: 4

$ ./msdscript --print
2+2
Result: (2+2)

$ ./msdscript --pretty-print
2+2
Result: 2 + 2
```

### Running an .msd File
Adding ` < filename.msd`, after declaring your mode, will allow you to run an .msd file through the program.

#### MSD File Example
The following is an example of a factorial function placed inside a `.msd` file.  Here is the command for interpreting
the function placed inside the file:

`$ ./msdscript --interp < factorial.msd`

MSD file content:
```
_let factrl = _fun (factrl)
                _fun (x)
                  _if x == 1
                  _then 1
                  _else x * factrl(factrl)(x + -1)
_in  factrl(factrl)(10)
```

### Syntax

#### Grammar
To understand the inner workings of this program it is important to first break down and understand the syntax grammar
used to build an expression.  The heart of this program is in the building of expressions, thus understanding the following
outline will enable you to understand how to build your very own expressions.

```javascript
<expr> = <number>
       | <boolean>
       | <expr> == <expr>
       | <expr> + <expr>
       | <expr> * <expr>
       | <expr> ( <expr> )
       | <variable>
       | _let <variable> = <expr> _in <expr>
       | _if <expr> _then <expr> _else <expr>
       | _fun ( <variable> ) <expr>
```

##### Breakdown of grammar
* `<expr>` This is the parent container for an expression.  Note that an expression can have many children which themselves can be expressions.
* `<number` A representation of a simple integer value, can be either negative or positive.
* `<boolean>` A representation of a boolean value, `_true` for true and `_false` for false.
* `<varialbe>` A representation of a string value, such as x, y, or z.
* `<expr> == <expr>` This will compare each expression and return `_true` if the interpreted expressions are equal or
`_false` if they are not.
* `<expr> + <expr>` This will add the two expressions.
* `<expr> * <expr>` This will multiply the two expressions.
* `<expr> ( <expr> )` This will call the expression inside the parenthesis onto the one outside the parenthesis.
* `_let <variable> = <expr> _in <expr>` Refer to [_let Expression](#_let-expression) section.
* `_if <expr> _then <expr> _else <expr>` This is simpler to an if-then-else statement.  This will evaluate the first
  expression, if that returns `_true` then it will return the value of the first expression else it will return the value
  of the second expression.
* `_fun ( <variable> ) <expr>` Refer to [_fun Expression](#_fun-expression) section.

#### _let Expression
The `_let` expression is a very powerful expression which enables computing more complex expressions.  The core of this
expression is its substation property.  In the following example, we substitute the `x` in `1 + x` with `2`.:
```
_let x = 2
_in 1 + x
```
We search the `<expr>` following the `_in` for variables matching the first `<variable>` (x in this example).  We then
replace those variables with the `<expr>` following the `=`.

It is important to understand how nested `let` expressions work.  In the following example `x` is used in the parent `_let`
expression and also in the child `_let` expression:
```
_let x = 1
_in _let x = 2
    _in x + 3
Result: 5
```
The `x` in `x + 3` does not equal `1`, it equals `2`.  When interperting we start at the base of the nested `_let`
expression and work up the chain.  So we first start with the second `_let` expression, interpret it, then move up to the
parent `_let` expression.

Here is a slightly more complex nested `_let` expression:
```
_let x = 1
_in _let y = 2
    _in x + 3
Result: 4
```
In this example the second `_let` expression we changed `x` to `y` from the previous example. In this example we first
interpret the second `_let` expression, which since there is no `y` in `x+3` we return `x+3`.  Now the expression reads:
```
_let x = 1
_in x + 3
```
We finish by simply substituting `1` for `x` in `x + 3`, returning `4`.

#### _fun Expression
The `_fun` expression is another very powerful expression which enables computing more complex expressions.  This
expression returns a value, not simply an expression or a number.  The following example is a basic `_fun` expression:
```
_fun (x) x + 1
```
This expression is comparable to the following JavaScript function:
```javascript
function (x) { return x + 1; }
```
The expression `x + 1` is what is returned when this expression is interpreted.  We can add a call expression with this
`_let` expression to return a number:
```
(_fun (x) x + 1)(2)
Result: 3
```
Now we are calling `2` onto our `_fun` expression, so the interpretation becomes `2 + 1`.

#### White Space
When writing out an expression to be executed it is important to understand white space.  White space does not affect
the syntax nor does having multiple lines for on expression.  For example, the following two expression are equal:
```
1+2*3
==
1    + 2
   *3
```

#### Allowed Syntax
It is important to understand what syntax is allowed and what syntax may throw an error.  MSD Script can only interpret
numbers `0-9`, floating point number (or decimals) are not allowed.  Also, variables can be used for computing number
or function substation, as part of the `_fun` and `_let` expressions.  Variables can only contain characters `A-Z` and
`a-z`.

There is a distinction between an expression and a value.  Expressions are as previous labeled, containers of additional
expressions, whereas values are considered the base of the expression, such as a number, boolean, or function value.
Furthermore, when using the `==` expression you can compare different types of values.  When using `+` or `*` you cannot
compute numbers against booleans.

See [Possible Errors](#possible-errors) section for more about syntax errors and error examples.

#### MSD Script Examples
Here are several examples to better understand how `--interp` works.
```
1 == 1 -> <number> == <number> = <boolean> // returns _true
2 + 2 -> <number> + <number>  = <number> // returns 4
3 * 3 -> <number> * <number> = <number> // reutrns 9
```

The following expression looks in `5 * x` and replaces `x` with `3 + 2`, the expression will return with `25`.
```
_let x = 3 + 2
_in 5 * x
Result: 25
```

The following expression will calculate if `6 == 7`, this will result in `_false` so the expression will return `0`.
```
_if 6 == 7
_then 1
_else 0
Result: 0
```

The following is a more complex expression that demonstrates the ability to stack expressions together.  Note that on
the second `_then` the following expression is `_false + 6`.  Normally this would cause an error to be thrown, however
in this case since the second `_if` statement returns `_false` the `_then` (or true) expression is never executed.
```
6 + _if _true
    _then _if 6 == 7
          _then _false + 6
          _else _let y = 40
                _in 6 * (3 + y)
    _else 70
Result: 264
```

### Possible Errors
#### Expression Errors
* There are many common errors that will be thrown if expressions aren't able to be interpreted.  An example of a common
error would be if you tried to add a `5` to `_false`, since your cannot add number to a boolean this will result in
an error.
* Subtraction and division are not currently supported.  To subtract simply convert your right-hand number into a negative.
For example change `2 - 2` to `2 + -2`.

#### Parsing Errors
* Be aware when building an expression string that you need to close out parenthesis.  For example `5 + ( 2 * 2` will throw
an error.

#### Error Examples
Here is a list of some errors that may be triggered do to incorrect syntax.
```
10*(10+10         -> missing close parenthesis
5+?               -> invalid input
_lt x=1 _in x+2"  -> invalid expression
_let ?=1 _in x+2  -> invalid variable
_let x 1 _in x+2  -> invalid expression
_let x=1 _i x+2   -> invalid expression
5 =+ 5            -> invalid '==' expression
```


## API Documentation
This will outline how to integrate this library into your own project.
* Delete the file `main.cpp` from this library.
* Add the library files to your project.
* Add `#include "msdscript.h"` to the top your C++ files that are going to be using this script.
* Call `MSDInterp( "your expression" )`, insert your expression as a string, this function will also return a string value.

## Support Expectations
Feel free to submit any bugs to this GitHub repo's issues tab! [https://github.com/tomryan33/msdscript/issues](https://github.com/tomryan33/msdscript/issues)