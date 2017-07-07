;;; let+.el --- Let everything -*- lexical-binding: t -*-
(mapc #'require [cl-macs seq])

(defmacro let+ (BINDINGS &rest BODY)
  "Imagine BINDINGS as a big `setf' body that does the right thing with lists, functions, etc."
  (cl-labels
      ((let-helper
        (BINDINGS)
        (if BINDINGS
            (seq-let (var val &rest bs) BINDINGS
               (cond
                ((sequencep var)
                 ;; Pattern-match sequence.
                 `(seq-let ,var ,val
                    ,(let-helper bs)))
                ((and (consp val)
                      (listp (car val))
                  ;; Bind procedure.
                  `(cl-labels ((,var . ,val))
                     ,(let-helper bs)))
                 (t
                  ;; Bind as usual.
                  `(let ((,var ,val))
                       ,(let-helper bs))))))
            `(progn . ,BODY))))
    (let-helper BINDINGS)))

(provide 'let+)
