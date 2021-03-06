;;; let+.el --- Let everything -*- lexical-binding: t -*-
(mapc #'require
      [cl-macs ; `cl-labels'
       seq]) ; `seq-let'

;;; NOTE: Normally you should use this with (eval-when-compile (require 'let+)).

(defmacro let+ (BINDINGS &rest BODY)
  "Locally bind variables and procedures and pattern-match sequences, then evaluate BODY.
Imagine BINDINGS as a big `setf' body that does the right thing with lists, functions, etc.

Example:
\(let+ ((a b) [1 2]
       \foo ((x y) (+ x y)))
  \(foo a b))
;=> 3"
  (declare (indent 1))
  (cl-labels
      ((sublet (var val)
        ;; Pattern-match to make the right kind of binding.
        (cond
         ;; Sequence
         ((sequencep var)
          `(seq-let ,var ,val))
         ;; Procedure
         ((and (consp val)
               (listp (car val))
           `(cl-labels ((,var . ,val)))))
         ;; Variable
         (t
          `(let ((,var ,val))))))

       (combind (bindings)
        ;; String all the bindings together.
        (if bindings
            (seq-let (var val &rest brest) bindings
              (let ((sublet (sublet var val)))
                (append sublet `(,(combind brest)))))
          `(progn . ,BODY))))
    (combind BINDINGS)))

(provide 'let+)
