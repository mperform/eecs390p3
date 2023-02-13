; test.scm -- load this file to test the internal workings of the
; interpreter.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(load "core.scm")
(load "assert.scm")

; Setup

(call-with-current-continuation error-setup)
; we're not reading input from stdin, so overwrite this to do nothing
(define (clear-line) #t)
(define global-env (add-primitives (add-special-forms (frame '()))))
