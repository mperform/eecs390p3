; primitives.scm -- implements primitive procedures, including error
; checking.
;
; Uses the error procedure defined in error.scm. May also use
; procedures defined in core.scm.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

; We don't need to load env.scm or error.scm -- this file is only
; tested in conjunction with core.scm, which itself loads those two
; files.

; Reports an error that the number of arguments to a procedure call
; does not match the expected count. name is the name of the
; procedure, expected is a number or string representing the expected
; number of arguments. actual is a number corresponding to the actual
; number of arguments provided.
(define (arity-error name expected actual)
  (error (string-append "incorrect number of arguments to "
                        (symbol->string name)
                        ": expected "
                        (if (number? expected)
                            (number->string expected)
                            expected
                        )
                        ", got "
                        (number->string actual)
         ))
)


; Reports a type error for the argument at the given index. name is
; the name of the invoked procedure, expected is a symbol representing
; the expected type, and value is the offending argument value.
(define (type-error index name expected value)
  (error (string-append "incorrect type for argument "
                        (number->string index)
                        " of "
                        (symbol->string name)
                        ": expected "
                        (symbol->string expected)
                        ", got"
         )
         value
  )
)


; Checks that all the argument values in values meet the given test.
; name is the name of the invoked procedure, typename is a symbol
; representing the expected type, and index is the index of the first
; argument in values.
(define (check-arg-types name test typename values index)
  (cond ((null? values) #t)
        ((test (car values))
         (check-arg-types name test typename (cdr values) (+ index 1)))
        (else (type-error index name typename (car values)))
  )
)


; Returns an object representing the given name, expected number of
; arguments, and library implementation for a primitive procedure.
;
; The returned object should accept a message and any number of
; arguments.
;
; For the 'call message, it should:
; 1) Check whether the given number of arguments matches the expected
;    number (plus the initial environment argument). Use arity-error
;    to signal an error.
; 2) Evaluate the arguments in the given environment.
; 3) Invoke the library implementation on the argument values.
;
; For the 'to-string message, it should produce a string with the
; following format:
;   [primitive procedure <name>]
; where <name> is the name passed in to primitive-procedure.
(define (primitive-procedure name arg-count native-impl)
  (lambda (message . args)  
    (cond
          ((eq? message 'call)
            (cond
              (
                (eq? (length (cdr args)) arg-count)
                (apply native-impl (map (lambda (x) (scheme-eval x (car args))) (cdr args)))

              )
              (else (arity-error name arg-count (length (cdr args))))
            )  
          )
          ((eq? message 'to-string)
            (string-append (string-append "[primitive procedure " (symbol->string name)) "]")
          )
        )
  )
)


; Returns a procedure representing the given name, expected number of
; arguments, and library implementation. The returned procedure checks
; that the arguments all meet the given test, reporting an error if
; one does not. typename is a symbol representing the expected type.
(define (type-checked name arg-count test typename impl)
  (primitive-procedure name arg-count
                       (lambda args
                         (check-arg-types name test typename args 1)
                         (apply impl args)
                       ))
)


; Returns a procedure representing the given name, expected number of
; arguments, and library implementation. The returned procedure checks
; that the arguments all meet the given type test, reporting an error
; if one does not. typename is a symbol representing the expected
; type. The returned procedure also checks that the arguments have
; valid values for a division-like operation.
(define (divide-checked name arg-count test typename impl)
   (primitive-procedure name arg-count
                       (lambda args
                         (check-arg-types name test typename args 1)
                         (check-arg-types name (lambda (x) (not (eq? x 0))) typename args 2)
                         (apply impl args)
                       ))
)


; Displays a Scheme value to standard out.
(define (scheme-display value)
  (display (if (procedure? value)
               (value 'to-string)
               value
           ))
)


; Writes a Scheme value to standard out. This differs from display on
; how it handles strings.
(define (scheme-write value)
  (if (procedure? value)
      (display (value 'to-string))
      (write value)
  )
)


; Adds primitive procedures to the given environment and returns the
; environment.
(define (add-primitives env)
  (env 'insert '+ (type-checked '+ 2 number? 'number +))
  (env 'insert '- (type-checked '- 2 number? 'number -))
  (env 'insert '* (type-checked '* 2 number? 'number *))
  (env 'insert '/ (divide-checked '/ 2 number? 'number /))
  (env 'insert 'quotient
       (divide-checked 'quotient 2 integer? 'integer quotient))
  (env 'insert 'modulo
       (divide-checked 'modulo 2 integer? 'integer modulo))
  (env 'insert 'remainder
       (divide-checked 'remainder 2 integer? 'integer remainder))
  (env 'insert '= (type-checked '= 2 number? 'number =))
  (env 'insert '< (type-checked '< 2 number? 'number <))
  (env 'insert '<= (type-checked '<= 2 number? 'number <=))
  (env 'insert '> (type-checked '> 2 number? 'number >))
  (env 'insert '>= (type-checked '>= 2 number? 'number >=))
  (env 'insert 'not (primitive-procedure 'not 1 not))
  (env 'insert 'car (type-checked 'car 1 pair? 'pair car))
  (env 'insert 'cdr (type-checked 'cdr 1 pair? 'pair cdr))
  (env 'insert 'cons (primitive-procedure 'cons 2 cons))
  (env 'insert 'list (primitive-procedure 'list 0 list))
  (env 'insert 'length (type-checked 'length 1 list? 'list length))
  (env 'insert 'null? (primitive-procedure 'null? 1 null?))
  (env 'insert 'pair? (primitive-procedure 'null? 1 pair?))
  (env 'insert 'list? (primitive-procedure 'list? 1 list?))
  (env 'insert 'number? (primitive-procedure 'number? 1 number?))
  (env 'insert 'boolean? (primitive-procedure 'boolean? 1 boolean?))
  (env 'insert 'equal? (primitive-procedure 'equal? 2 equal?))
  (env 'insert 'zero? (primitive-procedure 'zero? 1 zero?))
  (env 'insert 'display (primitive-procedure 'display 1 scheme-display))
  (env 'insert 'write (primitive-procedure 'write 1 scheme-write))
  (env 'insert 'newline (primitive-procedure 'newline 0 newline))
  env
)
