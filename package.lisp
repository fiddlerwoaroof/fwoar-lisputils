;;;; package.lisp

(defpackage :fwoar.counter
  (:use :cl))

(defpackage #:fwoar.lisputils
  (:use #:cl #:alexandria)
  (:nicknames #:fw.lu)
  (:import-from #:serapeum #:op)
  (:shadow #:with)
  (:export #:lambda-if #:lambda-cond #:alambda #:rollup-list
           #:ensure-mapping #:alist-string-hash-table #:make-pairs
           #:copy-slots #:transform-alist #:%json-pair-transform
           #:%default-pair-transform #:default-when
           #:transform-result #:slots-to-pairs #:normalize-html
           #:destructuring-lambda #:let-each #:let-first #:let-second
           #:neither #:neither-null #:m-lambda #:sets #:defparameters
           #:setfs #:prog1-let #:if-let* #:with #:aconsf #:ensure-list #:pick
           #:vector-destructuring-bind #:with-accessors*
           #:skip-values #:limit-values #:substitute-values
           #:op
	   #:pick/r
	   #:pick-error))

