; assert.scm -- assertion procedures for internal testing.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

; Assert that x and y are the same according to equal?.
(define (assert-equal x y)
  (if (not (equal? x y))
      (begin (display "Error: ")
             (write x)
             (display " not equal? to ")
             (write y)
             (newline)
      )
      (display "pass\n")
  )
)

; Assert that x has a true value.
(define (assert-true x)
  (if (not x)
      (begin (display "Error: ")
             (write x)
             (display " not true")
             (newline)
      )
      (display "pass\n")
  )
)

; Assert that x has a false value.
(define (assert-false x)
  (if x
      (begin (display "Error: ")
             (write x)
             (display " not false")
             (newline)
      )
      (display "pass\n")
  )
)

; Helper procedure used in assert-error.
(define (expected-error message . args)
  (display "pass\n")
  (repl-continuation (if #f #f))
)

; Assert that the given expression signals an error.
(define-syntax assert-error
  (syntax-rules ()
    ((assert-error expr)
     (let ((old-error error)
           (result '()))
       (dynamic-wind (lambda () (set! error expected-error))
                     (lambda () (set! result expr))
                     (lambda () (set! error old-error))
       )
       (display "Error: expected error, but no error was signaled; ")
       (display "result of expression: ")
       (write result)
       (newline)
     ))
  )
)
