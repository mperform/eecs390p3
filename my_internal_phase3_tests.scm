(load "test.scm")


(global-env 'insert 'x 3)
(global-env 'insert 'y -1)
(global-env 'insert 'z 2)
(global-env 'insert 'a -2)

(display "Running special-form tests...")
(newline)

(define form1 (special-form 'min -))
(assert-equal (form1 'call 3 -5) 8)
(assert-equal (form1 'call 3 4 5) -6)
(assert-equal (form1 'to-string) "[syntax min]")

(display "Running scheme-begin tests")
(newline)

(assert-equal (scheme-begin global-env 3 4 'x) 3)
(assert-equal (scheme-begin global-env 3 4 'x #f) #f)

(display "Running scheme-if tests...")
(newline)


(assert-equal (scheme-if global-env 'x 'y 5) -1)
(assert-equal (scheme-if global-env #f #t #t) #t)


(display "Running scheme-quote tests...")
(newline)

(assert-equal (scheme-quote global-env 'y) 'y)
(assert-equal (scheme-quote global-env '(+ x y)) '(+ x y))
(assert-equal (scheme-quote global-env "hello" ) "hello")

(display "Running lambda-procedure tests...")
(newline)

(define proc1 (lambda-procedure 'foo '(x) '((* x x)) global-env)) ;square
(assert-equal (proc1 'call global-env -3) 9)
(assert-equal (proc1 'call global-env 'y) 1)

(define proc1 (lambda-procedure 'foo '(x) '((cons x x)) global-env)) ;cons
(assert-equal (proc1 'call global-env -3) '(-3 . -3))

(define proc1 (lambda-procedure 'foo '(x y z a) '(car (cons z a) (cons x y)) global-env)) ;cons
(assert-equal (proc1 'call global-env 'x 'y 'z 'a) '(3 . -1))

(display "Running scheme-define tests...")
(newline)

(scheme-define global-env 'x -7)
(assert-equal (global-env 'get 'x) -7)


(display "Running error tests...")
(newline)

(assert-error (scheme-begin global-env))
(assert-error (scheme-if global-env 'x))
(assert-error (scheme-quote global-env 'x 'y))
(assert-error (scheme-lambda global-env '(x x) '(+ x 1)))
(assert-error (scheme-define global-env 3))