# Spring 2021 MOCK FINAL [75 points]

**Released:** THIS IS A MOCK FINAL

**Due:** THIS IS A MOCK FINAL

- You **may** consult any course material (lecture notes, assignments, past exams, etc)
- You **may** ask for clarifications on Piazza via a private message to instructors
- You **may not** communicate with other students or ask for anyone's help
- You **may not** search help forums (StackOverflow) and the Internet for a solution

## Overview

The exam is in the files:

- [Fib.lc](./src/Fib.hs)
- [FileSystem.hs](./src/FileSystem.hs)
- [Logging.hs](./src/Logging.hs)

As before `Test.hs` has some sample tests, and testing code that
you can use to check your solution before submitting.

### Testing and Evaluation

Most of the points, will be awarded automatically, by
**evaluating your functions against a given test suite**.

[Tests.hs](./tests/Test.hs) contains a very small suite
of tests which gives you a flavor of of these tests.
When you run

```shell
$ make test
```

Your last lines should have

```
All N tests passed (...)
```

**or**

```
K out of N tests failed
```

**If your output does not have one of the above your code will receive a zero**

If for some problem, you cannot get the code to compile,
leave it as is with the `error ...` with your partial
solution enclosed below as a comment.

The other lines will give you a readout for each test.
You are encouraged to try to understand the testing code,
but you will not be graded on this.

### Submission Instructions

Submit your code via the `final` assignment on Gradescope.
You must submit a single zip file containing a single directory with your repository inside.
A simple way to create this zip file is:

- Run `git push` to push your local changes to your private fork of the assignment repository
- Navigate to your private fork on github and download source code as a zip

Please *do not* include the `.stack-work` or the `_MACOSX` folder into the submission.

Upon submission to Gradescope, the auto-grader will only test your code on the public test suite,
so you can get no more than 20 points.
After the deadline, we will re-test your code on the private test suite.



## Q1: Lambda Calculus: Fibonacci [10 pts]

Your task is to implement the function `FIB` in lambda calculus,
which computes the `n`-th Fibonacci number.
Recall that the *Fibonacci numbers* is a sequence of natural numbers 
`0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...`
such that each number (except the 0th and 1st) is the sum of the two preceding ones.

Your implementation should satisfy the following test cases:

```haskell
eval fib0 :    eval fib1 :    eval fib2 :    eval fib5 :
  FIB ZERO       FIB ONE        FIB TWO        FIB FIVE
  =~> ZERO       =~> ONE        =~> ONE        =~> FIVE
```

You can use any function defined in the "Lambda Calculus Cheat Sheet"
at the end of this exam.

*Hint:* There are two solution: one uses `FIX`, and the other one does not.
We encourage you to implement the latter, using an auxiliary function `STEP`
that takes as input a pair of numbers and returns a pair of numbers.


## Q2. Datatypes and Recursion: Files and Directories [35 pts]

Recall the Haskell representation of files and directories from the midterm.
We can represent a directory structure using the following Haskell datatype:

```haskell
data Entry = 
    File String Int     -- file: name and size
  | Dir String [Entry]  -- directory: name and child entries 
```

For example, the value:

```haskell
homedir = Dir "home" 
            [ File "todo" 256
            , Dir  "HW0" [ File "Makefile" 575 ]
            , Dir  "HW1" [ File "Makefile" 845, File "HW1.hs" 3007]
            ]
```

represents the following directory structure:

```
home
 |---todo (256 bytes)
 |
 |---HW0
 |     |---Makefile (575  bytes)
 |
 |---HW1      
       |---Makefile (845  bytes)
       |---HW1.hs   (3007 bytes)
```

In your solutions you can use any library functions on integers
(e.g. arithmetic operators),
but **only the following** functions on lists:

```haskell
(==)   :: String -> String -> Bool       -- equality on strings
(++)   :: [a] -> [a] -> [a]              -- append on any lists
map    :: (a -> b) -> [a] -> [b]         -- map
filter :: (a -> Bool) -> [a] -> [a]      -- filter
foldr  :: (a -> b -> b) -> b -> [a] -> b -- fold right
foldl  :: (b -> a -> b) -> b -> [a] -> b -- fold left
```

### 2.1 Tail-Recursive Size [15 pts]

Implement a *tail-recursive* version of the function `size`,
which computes the total size of an entry in bytes,
using a helper function `loop` with the signature provided below.
*Hint:* the second argument of loop is a list of entries yet to be processed.

Your implementation must satisfy the following test cases

```haskell
size (File "todo" 256)  
  ==> 256
size (Dir "haskell-jokes" [])  
  ==> 0
size homedir
  ==> 4683    -- 256 + 575 + 845 + 3007
```

### 2.2 Remove [15 pts]

Implement the *higher-order* function `remove p e`,
which recursively traverses all the sub-entries inside `e`
and removes those that satisfy the predicate `p`.

Your implementation must satisfy the following test cases
(here `nameOf` is a function that returns the name of an entry):

```haskell
remove (\e -> nameOf e == "Makefile") homedir
  ==> Dir "home" 
            [ File "todo" 256
            , Dir  "HW0" []
            , Dir  "HW1" [File "HW1.hs" 3007]
            ]
            
remove (\e -> nameOf e == "HW1") homedir
  ==> Dir "home" 
            [ File "todo" 256
            , Dir  "HW0" [ File "Makefile" 575 ]
            ]            
            
remove (\e -> nameOf e == "home") homedir
  -- the current directory is never removed (only sub-entries),
  -- so return homedir unchanged:
  ==> Dir "home" 
            [ File "todo" 256
            , Dir  "HW0" [ File "Makefile" 575 ]
            , Dir  "HW1" [ File "Makefile" 845, File "HW1.hs" 3007]
            ]
```

### 2.3 Clean up [5 pts]

Using `remove` from 2.2, implement the function `cleanup e`
that removes all empty subdirectories of `e`.
Your implementation must satisfy the following test cases:

```haskell
cleanup (Dir "temp" [Dir "drafts" [], File "todo" 256])  
  ==> Dir "temp" [File "todo" 256]
cleanup (File "todo" 256)  
  ==> File "todo" 256  
cleanup (Dir "drafts" [])  
  -- the current directory is never removed (only sub-dirs):
  ==> Dir "drafts" []
```

## Q3: Monads and Interpreters: Logging [30 pts]

In this task we will add logging (debug output) to our Nano interpreter.
It should work similar to the `trace` function in Haskell.
More specifically we want to be able to write a Nano program like this:

```haskell
log "I saw 2" 2   +   log "I saw 3" 3
```

and have the interpreter print out all the log messages in the order they have been evaluated,
followed by the result of evaluation, i.e.:

```
I saw 2
I saw 3
5
```

### Datatypes

For this task, we will used a stripped-down version of Nano that only has constants, addition, and the logging directives:

```haskell
data Expr = EInt Int          -- Constant
          | EPlus Expr Expr   -- Addition
          | ELog String Expr  -- Log a message and then evaluate the inner expression
```

For example, here are three versions of `2 + 3` in this representation with different amounts of logging:

```haskell
e1 = EPlus (EInt 2)                    -- No logging
           (EInt 3)
e2 = EPlus (ELog "I saw 2" (EInt 2))   -- Only log 2 
           (EInt 3)
e3 = EPlus (ELog "I saw 2" (EInt 2))   -- Log both 2 and 3 
           (ELog "I saw 3" (EInt 3))
```

To represent an evaluation result that contains both a value and a log,
we introduce the following type `Logging a`:

```haskell
-- | A logging computation contains a log (a list of messages) and a value
data Logging a = Logging [String] a
```

The overall idea is to make `Logging` a monad, 
so that we can write our `eval` function in a monadic way,
and not worry about composing logs e.g. when evaluating addition.

### 3.1 Monad Instance for Logging [10 pts]

Define an instance of `Monad` for `Logging`,
i.e. implement methods `return` and `(>>=)`
to achieve the following behavior:

- When two logging computations are sequenced, their logs are concatenated together (in order) 

Your implementation must satisfy the following tests cases:

```haskell
ret3 :: Logging Int
ret3 = return 3

...

λ> do x <- ret3 ; return (x + 5)
8

λ> do x <- Logging "hello" 3 ; Logging "goodbye" (x + 5)
"hello"
"goodbye"
8
```

### 3.2 The Logging API [10 pts]

Implement the function `log :: String -> Logging ()`
that takes a message as an argument and returns a logging computation
that simply logs the provided message and does nothing else.

Your implementation must satisfy the following tests cases:

```haskell
λ> do log "hello" ; return 3
"hello"
3

λ> do log "hello" ; log "goodbye" ; return 3
"hello"
"goodbye"
3
```

### 3.3 The Evaluator [10 pts]

Using the `log`, `return`, and `(>>=)` from previous tasks,
implement the function `eval :: Expr -> Logging Int`
which evaluates expressions with logging directives.

Your implementation must satisfy the following tests cases
(where the expressions `e1`, `e2`, and `e3` are defined above).

```haskell
λ> eval e1
5

λ> eval e2
"I saw 2"
5

λ> eval e3
"I saw 2"
"I saw 3"
5
```
