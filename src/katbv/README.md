# KAT + BV ("KAT plus Boolean vectors")
This is an instantiation of `('act, 'test) Ast.exp` where the elements are thought
of as Boolean vectors and `'act` corresponds to modifying some bits of a Boolean
vector and `'test` can correspond to either testing if a Boolean vector lies in
some range (when interpreted as an integer) or testing that some specific bits
of the Boolean vector match specified values.

Note that internally Boolean vectors are represented as sets of integers which
denote the indices on which the Boolean vector is 1. As a consequence, there is
no fixed dimension. Hence a test of the form `x=1` will match all `v` such that
`v_0=1`. 

## Parser syntax
A Boolean vector is a string s<sub>1</sub>s<sub>2</sub>...s<sub>n</sub> where 
s<sub>i</sub> is either 0 or 1. The vector is interpreted as a binary number 
with the rightmost bit as the low bit at the leftmost bit as the top bit. Thus
the Boolean vector 110 is interpreted as 6. In particular the index of s<sub>i</sub>
is n-i.

The parser recognizes the following syntax for KAT+BV Boolean expressions
- `T` `F` -- "True" "False" respectively
- `x=[mask]` where `[mask]` is a string of `{1,0,?}` indicating which bits are 
tested. For example `x=??1?` matches all bit vectors which have a `1` in the 
second bit position.
- `[a]<=x<=[b]` tests that `x` is in the range `[a,b]` where `[a]` and `[b]` are
binary numbers. One can also simply write `x<=[b]` which is parsed as `0<=x<=[b]`.
- `p+q` `p;q` `~p` -- Boolean "disjunction" "conjunction" "negation" respectively

The parser recognizes the following syntax for KAT+BV expressions
- `[Boolean expression]`
- `x:=[mask]` where `[mask]` is a string of `{1,0,?}` indicating which bits to 
update in `x`. For example `x:=0???` updates the fourth bit to be a 0.
- `p+q` `p;q` `p*` -- union sequence Kleene star respectively
- `if [Boolean expression] then [expression] else [expression]` -- 
`if b then e1 else e2` is parsed as `b;e1+~b;e2`.


## Command line interface
A given KAT+BV expression can be compiled into a corresponding IDD through the 
command line via the command
```
dune exec -- katbv idd --stdin "[KAT+BV expression]"
```
Alternatively one can test equivalence via
```
dune exec -- katbv equiv --stdin "[KAT+BV expression]" "[KAT+BV expression]"
```
For example
```
dune exec -- katbv idd --stdin "0<=x<=100;x:=010+x:=0"
```

## REPL
Start the KAT+BV REPL with
```
dune exec -- katbv repl
```
To see the available commands type `help` in the REPL.
