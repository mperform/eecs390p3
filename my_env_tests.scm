;;; Test cases for Scheme, Phase 1.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9




(load "env.scm")
(load "assert.scm")

; dictionary tests

(display "Running dictionary tests...")
(newline)

(define dict1 (dictionary))
(assert-equal (dict1 'length) 0)
(assert-false (dict1 'contains 3))

(dict1 'insert 3 5)
(assert-equal (dict1 'length) 1)
(assert-true (dict1 'contains 3))
(assert-equal (dict1 'get 3) 5)

(dict1 'insert 'a 3)
(assert-equal (dict1 'length) 2)
(assert-true (dict1 'contains 3))
(assert-true (dict1 'contains 'a))
(assert-equal (dict1 'get 3) 5)
(assert-equal (dict1 'get 'a) 3)

; frame tests

(display "Running frame tests...")
(newline)

(define env (frame '()))
(assert-false (env 'contains 'x))

(env 'insert 'x 3)
(env 'insert 'lst (list 4))
(assert-true (env 'contains 'x))

(assert-equal (env 'get 'x) 3)

(define subenv1 (frame env))
(assert-equal (subenv1 'get 'x) 3)

(assert-equal (subenv1 'get 'lst) '(4))

(subenv1 'insert 'y 5)
(assert-false (env 'contains 'y))
(assert-true (subenv1 'contains 'y))

(subenv1 'insert 'w 5)

(define subenv2 (frame env))
(assert-false (subenv2 'contains 'y))

(subenv2 'insert 'y 6)
(assert-equal (subenv1 'get 'y) 5)
(assert-equal (subenv2 'get 'y) 6)

(define subenv3 (frame subenv2))
(assert-equal (subenv3 'get 'x) 3)
(assert-equal (subenv3 'get 'y) 6)

(subenv3 'insert 'z 7)
(assert-false (env 'contains 'z))
(assert-false (subenv1 'contains 'z))
(assert-false (subenv2 'contains 'z))
(assert-true (subenv3 'contains 'z))

(subenv3 'insert 'y 8)
(assert-equal (subenv1 'get 'y) 5)
(assert-equal (subenv2 'get 'y) 6)
(assert-equal (subenv3 'get 'y) 8)

(subenv3 'insert 'y 9)
(assert-equal (subenv1 'get 'y) 5)
(assert-equal (subenv2 'get 'y) 6)
(assert-equal (subenv3 'get 'y) 9)

(assert-false (subenv3 'contains 'w))

(display "Done.")
(newline)
