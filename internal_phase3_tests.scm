;;; Internal test cases for Phase 3.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(load "test.scm")

; setup

(global-env 'insert 'x 3)
(global-env 'insert 'y -1)

; special-form tests

(display "Running special-form tests...")
(newline)

(define form1 (special-form 'qux +))
(assert-equal (form1 'call 3 -5) -2)
(assert-equal (form1 'call 3 4 5) 12)
(assert-equal (form1 'to-string) "[syntax qux]")

; scheme-begin, scheme-if, scheme-quote tests

(display "Running scheme-begin tests...")
(newline)

(assert-equal (scheme-begin global-env 3 4) 4)
(assert-equal (scheme-begin global-env 'x 'y) -1)

(display "Running scheme-if tests...")
(newline)

(assert-equal (scheme-if global-env 3 4) 4)
(assert-equal (scheme-if global-env 3 4 5) 4)
(assert-equal (scheme-if global-env #f 'x 'y) -1)

(display "Running scheme-quote tests...")
(newline)

(assert-equal (scheme-quote global-env 'x) 'x)
(assert-equal (scheme-quote global-env '(x y)) '(x y))

; lambda-procedure tests

(display "Running lambda-procedure tests...")
(newline)

(define proc1 (lambda-procedure 'foo '(x) '((+ x 1)) global-env))
(assert-equal (proc1 'call global-env -3) -2)
(assert-equal (proc1 'call global-env 'x) 4)

(define proc2 (lambda-procedure 'bar '(x z) '((+ x (- y z))) global-env))
(assert-equal (proc2 'call global-env -3 4) -8)
(assert-equal (proc2 'call global-env 'y 'x) -5)

(define proc3 (lambda-procedure 'baz '(x) '(x y) global-env))
(assert-equal (proc3 'call global-env -3) -1)

(assert-equal (proc1 'to-string) "[lambda procedure foo]")
(assert-equal (proc2 'to-string) "[lambda procedure bar]")
(assert-equal (proc3 'to-string) "[lambda procedure baz]")

; scheme-lambda tests

(display "Running scheme-lambda tests...")
(newline)

(define proc4 (scheme-lambda global-env '(x) '(+ x 1)))
(assert-equal (proc4 'call global-env -3) -2)
(assert-equal (proc4 'call global-env 'x) 4)

(define proc5 (scheme-lambda global-env '(x z) '(+ x (- y z))))
(assert-equal (proc5 'call global-env -3 4) -8)
(assert-equal (proc5 'call global-env 'y 'x) -5)

(define proc6 (scheme-lambda global-env '(x) 'x 'y))
(assert-equal (proc6 'call global-env -3) -1)

; scheme-define tests

(display "Running scheme-define tests...")
(newline)

(scheme-define global-env 'x -7)
(assert-equal (global-env 'get 'x) -7)
(scheme-define global-env '(func x z) '(+ x (- y z)))
(assert-equal (scheme-eval '(func -3 4) global-env) -8)

; error tests

(display "Running error tests...")
(newline)

(assert-error (scheme-define global-env 'x 3 4))
(assert-error (scheme-define global-env 3 4))
(assert-error (scheme-lambda global-env '(x y x) 3))
(assert-error (scheme-if global-env #t))

(display "Done.")
(newline)
