# let-plus.el
let*, cl-labels, and seq-let all in one package.

## Use
```
(let+ (x 0
       (a b c d) [1 2 3 4]
       plus ((&rest NUMS) (apply #'+ NUMS)))
  (plus x a b c d))
=> 10
```
