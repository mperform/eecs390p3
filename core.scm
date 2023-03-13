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
            (cond
              ((procedure? first)
                (apply first 'call env (cdr datum))
              )
              (else 

                (error "not a host procedure")
              )
            )
          )
        )
        ((symbol? datum)
          (cond
            (((add-primitives env) 'contains datum)
              ; ((env 'get datum) 'to-string)
              (env 'get datum)
             )
            (else (error "unknown identifier"))
          )
        )
        ; Add a case for symbols (identifiers) here.
        (else (error "cannot evaluate" datum))
  )
)

; Implements the begin form, which consists of a sequence of
; expressions.
(define (scheme-begin env . args)

  (cond
    ((null? args)
      (error "zero args passed")
    )
    ((= (length args) 1)
      (scheme-eval (car args) env)
    )
    (else
        (begin 
          (scheme-eval (car args) env)
          ; (1 2 3 4 5) scheme eval 5 
          (apply scheme-begin (append (list env) (cdr args)))
        )
    ) 
  )
)


; Implements a conditional, with a test, a then expression, and an
; optional else expression.
(define (scheme-if env . args)
  (cond 
    ((eq? (length args) 2) ;; 2 args provided --> no optional else expression
      (cond 
        ((scheme-eval (car args) env) ;test
        
          (scheme-eval (cadr args) env);expression
        )
      )
    )
    (
      (eq? (length args) 3) ;; 3 args provided --> optional else expression
      (cond 
        ((scheme-eval (car args) env) ;test
          (scheme-eval (cadr args) env);expression
        )
        (else
          (scheme-eval (cadr (cdr args)) env) ;else
        )
      )
    )
    (
      else (error "wrong number of args")
    )
  )
  
)


; Implements the quote form.
(define (scheme-quote env . args)
(cond
  ((eq? (length args) 1)
    (car args)
  )
  (
    else (error "wrong number of args supplied - only accepts one arg")
  )

)
  
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
; Example usage -->
;(define proc1 (lambda-procedure 'foo '(x) '((+ x 1)) global-env))
;(proc1 'call global-env -3)
  ;(display formals)
  ;(newline)
  (lambda (message . args)  
    ;(display args)
    ;(newline)
    (cond
          ((eq? message 'call)
            (cond
              ((= (length (cdr args)) (length formals)) ;Check whether the given number of arguments matches the expected number
                (let 
                  ((env (frame parent-env))) ;1. Extend the definition environment with a new frame.

                  ;(map (lambda (z) (scheme-eval z (car args))) (cdr args)); 2) Evaluate the arguments in the given (dynamic) environment.
                  ;(map (lambda (x y) (env 'insert x y)) formals args) ;3. Bind the formal parameters to the argument values in the new frame.
                  (map (lambda (x y) (env 'insert x y)) formals (map (lambda (z) (scheme-eval z (car args))) (cdr args))) ; steps 2 & 3 combined
                  (apply scheme-begin (append (list env) body)) ; Evaluate the body expressions in the new environment. 
                )
              )
              (else 
                
                (arity-error name (length args) (length (cdr args)))
              )
            )  
          )
          ((eq? message 'to-string)
            (string-append (string-append "[lambda procedure " (symbol->string name)) "]")
          )
        )
  )
)


; Implements the lambda form. Returns the newly created procedure.
;
; You are only required to support a fixed (non-variadic) number of
; arguments. You may choose to support other forms or signal an error.
;
; Use lambda-procedure to create the actual representation of the
; procedure.
(define (scheme-lambda env . args)
  ; Example Usage -->
  ; (define proc4 (scheme-lambda global-env '(x) '(+ x 1)))
  ; (assert-equal (proc4 'call global-env -3) -2)
  ; (assert-equal (proc4 'call global-env 'x) 4)
  (cond 
    ((has-dup (car args))
      (error "has duplicates in args\n")
    )
    (
      else (lambda-procedure '<lambda> (car args) (cdr args) env)
    )
  )
  

)

;; Checks for duplicates
;; returns #t if list contains duplicates
;; returns #f if list doesn't contain duplicates
;; example usage:
;; (has-dup '(1 2 3)) --> #f
;; (has-dup '(1 2 3 3)) --> #t
(define (has-dup lst)
  (cond 
    ((null? lst)
      #f
    )
    ((eq? (member (car lst) (cdr lst)) #f)
      (has-dup (cdr lst))
    )
    (else
      #t
    )
  )
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
  (cond 
    ((= (length args) 2)
      (cond
        ; (define proc4 (scheme-lambda global-env '(x) '(+ x 1)))
        ; (scheme-define global-env '(func x z) '(+ x (- y z)))
        ((list? (car args)) ; case 2: (define (<variable> <formals>) <body>)
          (cond 
            ((all-symbols? (car args)) ;; checks to make sure formals and name are all symbols
              ; (env 'insert name (scheme-lambda formals body))
              (env 'insert (car (car args)) (scheme-lambda env (cdr (car args)) (car (cdr args))))
              (car (car args))
            )
            (else (error "invalid"))
          )
        )
        (else ; case 1: (define <variable> <expresson>)
          (cond
            ((symbol? (car args))
              (env 'insert (car args) (scheme-eval (cadr args) env))
              (car args)
            )
            (else
              (error "<variable> is not a symbol")
            )
          )
        )
      )
    )

    (else (error "too many args provided"))
  )
)

;; Checks to make sure list contains all symbols
;; List contains non symbol --> return false
;; List only contains symbols --> return true
(define (all-symbols? lst)
  (cond
    ((null? lst)
      #t
    )
    ((symbol? (car lst))
      (all-symbols? (cdr lst))
    )
    (else 
      #f
    )
  )
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
  (lambda (message . args)  
    (cond
          ((eq? message 'call)
            (apply native-impl args) 
          )
          ((eq? message 'to-string)
            (string-append (string-append "[syntax " (symbol->string name)) "]")
          )
    )
  )
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
