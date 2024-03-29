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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; vvvv Begin, IF, Quote Functions vvvv ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; vvvv Lambda and Define functions vvvv ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
; Example usage -->
;(define proc1 (lambda-procedure 'foo '(x) '((+ x 1)) global-env))
;(proc1 'call global-env -3)
(define (lambda-procedure name formals body parent-env)
  (lambda (message . args)  
    (cond
          ((eq? message 'call)
            ; (frame parent-env) <---- Extend the definition environment with a new frame.
            (procedure-helper args (frame parent-env) formals body name)  
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
; Example Usage -->
; (define proc4 (scheme-lambda global-env '(x) '(+ x 1)))
; (assert-equal (proc4 'call global-env -3) -2)
; (assert-equal (proc4 'call global-env 'x) 4)
(define (scheme-lambda env . args)
  (cond 
    ((has-dup (car args))
      (error "has duplicates in args")
    )
    (
      else (lambda-procedure '<lambda> (car args) (cdr args) env)
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
; Example usage -->
; (define proc4 (scheme-lambda global-env '(x) '(+ x 1)))
; (scheme-define global-env '(func x z) '(+ x (- y z)))
(define (scheme-define env . args)
      (cond
        ((list? (car args)) ; case 2: (define (<variable> <formals>) <body>)
          (cond 
            ((all-symbols? (car args)) ;; checks to make sure formals and name are all symbols
              (let ((name (car (car args)))
                    (body (cdr args))
                    (formals (cdr (car args))))
                
                (env 'insert name (apply scheme-lambda env formals body))
                name
              )
            )
            (else (error "invalid"))
          )
        )
        (else ; case 1: (define <variable> <expresson>)
          (cond
            ((and (symbol? (car args)) (= (length args) 2))
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; vvvv Helper functions vvvv ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; Helper function to hold shared functionality between mu-procedure and lambda-procedure
(define (procedure-helper args extended-env formals body name)
  (let ((given-env (car args)) (unevaluated-args (cdr args)))
    (cond
      ((= (length unevaluated-args) (length formals)) ;Check whether the given number of arguments matches the expected number
          ;(map (lambda (z) (scheme-eval z (car args))) (cdr args)); 2) Evaluate the arguments in the given (dynamic) environment.
          ;(map (lambda (x y) (env 'insert x y)) formals args) ;3. Bind the formal parameters to the argument values in the new frame.
          (map (lambda (formal-params arg-vals) (extended-env 'insert formal-params arg-vals)) formals (map (lambda (x) (scheme-eval x given-env)) unevaluated-args)) ; steps 2 & 3 combined
          (apply scheme-begin (append (list extended-env) body)) ; Evaluate the body expressions in the new environment. 
      )
      (else 
        (arity-error name (length formals) (length unevaluated-args))
      )
    )
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; vvvv MU implementation vvvv ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Implement the mu form here.
; Start by implementing an analogue of lambda-procedure for procedures with dynamic scope. As always, avoid repeating code, refactoring if necessary.
(define (mu-procedure name formals body parent-env)
 (lambda (message . args)  
    (cond
          ((eq? message 'call)
              ; (frame (car args)) <---- Extend the given environment with a new frame.
              (procedure-helper args (frame (car args)) formals body name)  
          )
          ((eq? message 'to-string)
            (string-append (string-append "[mu procedure " (symbol->string name)) "]")
          )
        )
  )
)

; Second, implement a scheme-mu procedure that handles evaluation of a mu expression, resulting in a newly created procedure object.
; Example usage
; scm> (define y 5)
; y
; scm> (define foo (mu (x)
;                    (+ x y)
;                  ))
; foo
; scm> (foo 3)
; 8
; scm> ((mu (y)
;         (foo -3)
;       )
;       2
;      )
; -1
(define (scheme-mu env . args)
  (cond 
    ((has-dup (car args))
      (error "has duplicates in args")
    )
    (
      else (mu-procedure '<mu> (car args) (cdr args) env)
    )
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; vvvv Special Form functions vvvv ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
  (env 'insert 'mu (special-form 'mu scheme-mu))
  ; Insert the mu form here.
  env
)
