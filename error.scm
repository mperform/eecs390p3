; Error-handling for metacircular evaluator.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

; Remove all characters from standard input up to and including the
; next newline.
(define (clear-line)
  (let ((next-char (read-char)))
    (if (not (or (eof-object? next-char)
                 (char=? next-char #\newline)
             ))
        (clear-line)
    )
  )
)

; We store the REPL's continuation so that it can be invoked from the
; error procedure.
(define repl-continuation '())

(define (error-setup cont)
  (set! repl-continuation cont)
)

; Prints an error message and writes a representation of the remaining
; arguments, if any. Discards the remainder of the input line and
; invokes the REPL's continuation.
(define (error message . args)
  (display "Error: ")
  (display message)
  (cond ((not (null? args))
         (display " ")
         (write (if (= (length args) 1)
                    (car args)
                    args
                )
         ))
  )
  (newline)
  (clear-line)
  (repl-continuation (if #f #f))
)
