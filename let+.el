;;; let+.el --- Let everything -*- lexical-binding: t -*-
(mapc #'require [cl-macs seq])

(defmacro let+ (BINDINGS &rest BODY)
  "Imagine BINDINGS as a big `setf' body that does the right thing with lists, functions, etc.

Example:
\(let+ ((a b) '(1 2)
       \foo ((x y) (+ x y)))
  \(foo a b))
=> 3"
  (declare (indent 1))
  (cl-labels
      ((sublet (var val)
        (cond
         ((sequencep var); Pattern-match sequence.
          `(seq-let ,var ,val))
         ((and (consp val)
               (listp (car val)); Bind procedure.
           `(cl-labels ((,var . ,val)))))
         (t; Bind variable.
          `(let ((,var ,val))))))

       (combind (bindings)
        (if bindings
            (seq-let (var val &rest brest) bindings
              (let ((sublet (sublet var val)))
                (append sublet `(,(combind brest)))))
          `(progn . ,BODY))))
    (combind BINDINGS)))

(provide 'let+)
