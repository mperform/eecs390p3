;;; Our test cases for Phase 2 


;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(load "test.scm")

;inserting variables 

(global-env 'insert 'neg1 -1)
(global-env 'insert 'one 1)
(global-env 'insert 'five 5)
(global-env 'insert 'f #f)

; primitive-procedure to-string tests

(display "Running primitive-procedure to-string tests...")
(newline)

(define pp1 (type-checked 'cdr 1 pair? 'pair cdr))
(define pp2 (type-checked 'car 1 pair? 'pair car))
(define sign (primitive-procedure 'plus 2 +))
(define pp3 (primitive-procedure 'not 1 not))
(define pp4 (primitive-procedure 'list 0 list))

(assert-equal (pp1 'to-string) "[primitive procedure cdr]")
(assert-equal (pp2 'to-string) "[primitive procedure car]")
(assert-equal (sign 'to-string) "[primitive procedure plus]")

(display "Running primitive-procedure tests...")
(newline)

(assert-equal (pp1 'call global-env '(cons 1 2)) 2)
(assert-equal (pp2 'call global-env '(cons 1 2)) 1)
(assert-equal (sign 'call global-env 'neg1 'one) 0)
(assert-equal (pp3 'call global-env 'f) #t)
(assert-equal (pp4 'call global-env) '())
(assert-equal (pp1 'call global-env '(cons 'five 'one)) 'one)

(define pp5 (primitive-procedure 'square 1 (lambda (x) (* x x))))

(assert-equal (pp5 'call global-env 'five) 25)

;error checkings 

(assert-error (pp1 'call global-env '(1 2))); not a host procedure 
(assert-error (pp1 'call global-env 1 2)) ; incorrect number of arguments arity error 


