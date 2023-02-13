;;; Internal test cases for Phase 2.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(load "test.scm")

; setup

(global-env 'insert 'x 3)
(global-env 'insert 'y -1)

; primitive-procedure to-string tests

(display "Running primitive-procedure to-string tests...")
(newline)

(define proc1 (primitive-procedure 'cons 2 cons))
(assert-equal (proc1 'to-string) "[primitive procedure cons]")

(define proc2 (primitive-procedure 'foo 1 (lambda (x) (- x 1))))
(assert-equal (proc2 'to-string) "[primitive procedure foo]")

(define proc3 (primitive-procedure 'car 1 car))
(assert-equal (proc3 'to-string) "[primitive procedure car]")

; primitive-procedure tests with literal arguments

(display "Running primitive-procedure tests with literal arguments...")
(newline)

(assert-equal (proc1 'call global-env 3 4) '(3 . 4))
(assert-equal (proc2 'call global-env 3) 2)
(assert-equal (proc3 'call global-env (list proc1 3 4)) 3)

; scheme-eval symbol tests

(display "Running scheme-eval tests on symbols...")
(newline)

(assert-equal (scheme-eval 'x global-env) 3)
(assert-equal (scheme-eval 'y global-env) -1)

; primitive-procedure tests with symbol arguments

(display "Running primitive-procedure tests with symbol arguments...")
(newline)

(assert-equal (proc1 'call global-env 'x 'y) '(3 . -1))
(assert-equal (proc2 'call global-env 'y) -2)

; scheme-eval call-expression tests

(display "Running scheme-eval tests with call expressions...")
(newline)

(assert-equal (scheme-eval (list proc1 3 4) global-env) '(3 . 4))
(assert-equal (scheme-eval (list proc1 'x 'y) global-env) '(3 . -1))
(assert-equal (scheme-eval (list proc2 3) global-env) 2)
(assert-equal (scheme-eval (list proc2 'y) global-env) -2)
(assert-equal
  (scheme-eval (list proc1 (list proc2 3) 4) global-env)
  '(2 . 4)
)
(assert-equal
  (scheme-eval (list proc1 (list proc2 'x) 'y) global-env)
  '(2 . -1)
)
(assert-equal
  (scheme-eval (list (list proc3 (list proc1 proc2 3)) 5) global-env)
  4
)

; divide-checked tests

(display "Running divide-checked tests...")
(newline)

(define proc3 (divide-checked '/ 2 integer? 'integer /))
(assert-equal (proc3 'call global-env 3 4) (/ 3 4))
(assert-equal (proc3 'call global-env 'x 'y) (/ 3 -1))
(assert-error (proc3 'call global-env 1 0))  ; divide by zero

(display "Done.")
(newline)
