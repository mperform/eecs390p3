; core.scm -- implements evaluation as well as special forms.
;
; Uses the error procedure defined in driver.scm and arity-error
; defined in primitives.scm. May also use other procedures defined in
; primitives.scm.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(load "env.scm")
(load "error.scm")
(load "primitives.scm")

; Evaluates the given expression in the given environment.
(define (scheme-eval datum env)
  (cond ((or (number? datum)     ; self-evaluating objects
             (boolean? datum)
             (char? datum)
             (string? datum)
             (procedure? datum)
         )
         datum
        )
        ((and (pair? datum) (list? datum))  ; combinations
        ; The result of evaluating the first element must be a host
        ; procedure, representing either a client procedure or
        ; special form. Use procedure? to check this. Send the 'call
        ; message to the host procedure, along with the necessary
        ; arguments, to invoke it.
        ; scheme-eval (first element)
          (let* ((first (scheme-eval (car datum) env)))
            (apply first 'call env (cdr datum))
            ; (cond
            ;   ((procedure? first)
            ;     (display "here\n")
            ;     (apply first 'call env (cdr datum))
            ;   )
            ; )
          )
          ; (cond
          ;   ((procedure? (symbol->procedure (car datum))) ; checks if first element is callable
          ;     (let ((proced (symbol->procedure (car datum))))
          ;       ((primitive-procedure (car datum) 1 proced) 'call 'not #t)
          ;     )
          ;   )
          ; )
        )
        ((symbol? datum)
          (cond
            (((add-primitives env) 'contains datum)
             ((env 'get datum) 'to-string)
             )
            (else (error "unknown identifier"))
          )
        )
        ; Add a case for symbols (identifiers) here.
        (else (error "cannot evaluate" datum))
  )
)

(define (symbol->procedure sym)
  (lambda (args)
    (apply sym args)
  )
)
; Implements the begin form, which consists of a sequence of
; expressions.
(define (scheme-begin env . args)
  '()  ; replace with your solution
)


; Implements a conditional, with a test, a then expression, and an
; optional else expression.
(define (scheme-if env . args)
  '()  ; replace with your solution
)


; Implements the quote form.
(define (scheme-quote env . args)
  '()  ; replace with your solution
)


; Returns an object representing a user-defined lambda procedure with
; the given name, formal parameters, list of body expressions, and
; definition environment.
;
; The returned object should accept a message and any number of
; arguments.
;
; For the 'call message, it should:
; 1) Check whether the given number of arguments matches the expected
;    number (plus the initial environment argument). Use arity-error
;    to signal an error.
; 2) Evaluate the arguments in the given (dynamic) environment.
; 3) Extend the definition environment with a new frame.
; 4) Bind the formal parameters to the argument values in the new
;    frame.
; 5) Evaluate the body expressions in the new environment.
;
; For the 'to-string message, it should produce a string with the
; following format:
;   [lambda procedure <name>]
; where <name> is the name passed in to primitive-procedure.
(define (lambda-procedure name formals body parent-env)
  '()  ; replace with your solution
)


; Implements the lambda form. Returns the newly created procedure.
;
; You are only required to support a fixed (non-variadic) number of
; arguments. You may choose to support other forms or signal an error.
;
; Use lambda-procedure to create the actual representation of the
; procedure.
(define (scheme-lambda env . args)
  '()  ; replace with your solution
)


; Implements the define form. Returns the symbol being defined.
;
; You must support both variable and procedure definitions.
; For procedure definitions, you are only required to support a fixed
; (non-variadic) number of arguments. You may choose to support other
; forms or signal an error.
;
; For procedure definitions, use lambda-procedure to create the actual
; representation of the procedure.
(define (scheme-define env . args)
  '()  ; replace with your solution
)


; Implement the mu form here.


; Returns an object respresenting the given library implementation for
; a special form.
;
; The returned object should accept a message and any number of
; arguments.
;
; For the 'call message, it should:
; 1) Invoke the library implementation on the arguments.
;
; For the 'to-string message, it should produce a string with the
; following format:
;   [syntax <name>]
; where <name> is the name passed in to primitive-procedure.
(define (special-form name native-impl)
  '()  ; replace with your solution
)


; Adds special forms to the given environment and returns the
; environment.
(define (add-special-forms env)
  (env 'insert 'begin (special-form 'begin scheme-begin))
  (env 'insert 'if (special-form 'if scheme-if))
  (env 'insert 'quote (special-form 'quote scheme-quote))
  (env 'insert 'lambda (special-form 'lambda scheme-lambda))
  (env 'insert 'define (special-form 'define scheme-define))
  ; Insert the mu form here.
  env
)
