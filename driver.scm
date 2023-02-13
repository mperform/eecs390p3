; Driver for metacircular evaluator. Implements the REPL.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(load "core.scm")

; Change this to #t if you want to use your P2 parser;
; distribution.scm, lexer.scm, and parser.scm must be in the local
; directory.
(define use-project-parser #f)

(define read-datum read)

(if use-project-parser
    (load "parser.scm")
)


;;;;;;;;;;;;;;;;;;;;;;;;
; Read-eval-print loop ;
;;;;;;;;;;;;;;;;;;;;;;;;

; Infer the interpreter's representation of an unspecified value, so
; that the REPL does not print it.
(define void-object (if #f #f))

(define (void? obj)
  (eq? obj void-object)
)

; The actual read-eval-print loop:
; 1) Uses call/cc to invoke error-setup, passing the REPL's
;    continuation to the latter, which stores it for error handling.
; 2) Prints an interpeter prompt.
; 3) (Read)s an expression from standard input.
; 4) (Eval)uates the expression in the global environment.
; 5) (Print)s the result, if it is not unspecified.
; 6) Tail-recursively calls itself.
; The loop exists upon receiving an end-of-file.
(define (read-eval-print-loop env)
  (call-with-current-continuation error-setup)
  (display "scm> ")
  (flush-output)  ; non-standard plt-r5rs procedure
  (let ((datum (read-datum)))                      ; read
    (if (not (eof-object? datum))
        (let ((result (scheme-eval datum env)))    ; eval
          (cond ((not (void? result))
                 (scheme-write result)             ; print
                 (newline)
                )
          )
          (read-eval-print-loop env)  ; move to next iteration
        )
        (newline)  ; exit, printing a newline on the way out
    )
  )
)


;;;;;;;;;;;;;
; Bootstrap ;
;;;;;;;;;;;;;

; Create a global environent and install the built-ins.
(define (scheme-make-environment)
  (add-primitives (add-special-forms (frame '())))
)

; Start the REPL.
(define (start)
  (display "Welcome to the metacircular evaluator!")
  (newline)
  (read-eval-print-loop (scheme-make-environment))
  (display "Bye.")
  (newline)
)

(start)
