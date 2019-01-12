(in-package :fwoar.anonymous-gf)

(fw.lu:defun-ct get-specializers (specialized-lambda-list)
  (flet ((get-specializer (specializer)
           (etypecase specializer
             (symbol (find-class specializer))
             (cons (ecase (car specializer)
                     ('eql (closer-mop:intern-eql-specializer (cdr specializer))))))))
    (mapcar (lambda (specialized-arg)
              (if (listp specialized-arg)
                  (get-specializer (cadr specialized-arg))
                  (find-class t)))
            specialized-lambda-list)))

(fw.lu:defun-ct make-anonymous-generic-function (lambda-list methods)
  (declare (optimize (debug 3)))
  (let* ((gf (make-instance 'standard-generic-function
                            :lambda-list lambda-list))
         (mc (closer-mop:generic-function-method-class gf)))
    (prog1 gf
      (loop for (specializers qualifiers body) in methods
         for (method-lambda initargs) = (multiple-value-list (closer-mop:make-method-lambda gf (closer-mop:class-prototype mc)
                                                                                            `(lambda ,lambda-list
                                                                                               ,@body)
                                                                                            nil))
         do
           (add-method gf
                       (apply #'make-instance mc
                              :function (compile nil method-lambda)
                              :specializers (get-specializers specializers)
                              :qualifiers qualifiers
                              :lambda-list lambda-list
                              initargs))))))

(fw.lu:defun-ct take-until (pred list)
  (loop for (item . rest) on list
     until (funcall pred item)
     collect item into items
     finally
       (return (values items
                       (cons item rest)))))

(fw.lu:defun-ct get-methods (method-definition-list)
  (loop for (keyword . rest) in method-definition-list
     unless (eq keyword :method) do
       (error "method definitions must begin with the :METHOD keyword")
     collect
       (multiple-value-bind (qualifiers rest) (take-until #'listp rest)
         (list (car rest)
               qualifiers
               (cdr rest)))))

(defmacro glambda ((&rest lambda-list) &body methods)
  (let ((methods (get-methods methods)))
    `(make-anonymous-generic-function ',lambda-list ',methods)))

#+null
(glambda (a b)
  (:method ((a integer) (b integer)) (+ a b))
  (:method (a b) 2)
  (:method :after (a b) (format t "~&~d ~d~%" a b)))
