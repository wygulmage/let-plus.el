# let+.el
`let*`, `cl-labels`, and `seq-let` all in one package.

## Use
```
(let+ (x 0
       (a b c d) [1 2 3 4]
       plus ((&rest NUMS) (apply #'+ NUMS)))
  (plus x a b c d))
=> 10
```

Bindings are made in order, like `let*`. Sequence bindings are recognized because they have a sequence on the left. Function bindings recognized by having the tail (`cdr`) of a `lambda` on the right.
