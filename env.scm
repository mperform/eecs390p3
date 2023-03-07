; env.scm -- provides a dictionary abstraction, as well as a frame ADT
; that represents an environment.
;
; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

; Returns a dictionary object that can be used by passing messages to
; it.
;
; Does not do any error checking.
;
; > (define d (dictionary))
; > (d 'contains 'x)
; #f
; > (d 'insert 'x 3)
; > (not (d 'contains 'x))
; #f
; > (d 'get 'x)
; 3
; > (d 'insert 'x 4)
; > (d 'get 'x)
; 4
; > (d 'length)
; 1
;
; You will need to use some subset of set!, set-car!, set-cdr!. You
; may find the assoc procedure useful.
(define (dictionary)
  (let ((dict '()))
    ;(let ((len 0))
      (lambda (message . args)  ; replace with your solution
        (cond
          ((eq? message 'contains)
            (contains (car args) dict)
          )
          ((eq? message 'insert)
            (set! dict (list (insert (car args) (cadr args) '() dict)))
            (display dict)
            (display \newline)
          )
          ((eq? message 'get)
            (get (car args) dict)
          )
          ((eq? message 'length)
            (length dict)
          )
        )
      )
    ; get, contain, length, insert
      ; a "chain" of pairs I assume? (key, value)
      ; not sure how to hash the key to the value tho, or we iterate to find the value according to the key
      ; insert: use cdr or car to recursively iterate, set to modify, etc
      ; length: iterate thru to find the length
    ;) ;let parentheses
  )
)
(define (len dict cnt)
  (display dict)
  (display "\n")
  (cond
    ((null? dict)
      cnt
    )
    (else
      (+ cnt 1)
      (set! dict (cdr dict))
      (len dict cnt)
    )
  )
)
(define (contains key dict)
  (cond
    ((null? dict)
      #f
    )
    ((eq? key (car (car dict))) ;;compare element to key of a key value pair in dict
      #t
    )
    (else
      (contains key (cdr dict))
    )
  )
)

(define (insert key val read-so-far dict)
  (cond 
    ((null? dict)
      (display (list read-so-far))
      (display "\n")
      (display (cons key val))
      (display "\n")
      (append read-so-far (cons key val))
    ); dict is empty
    ((eq? key (car (car dict))); key matches current key 
      (append read-so-far (set-car! dict (cons key  val)))
    )
    (else ;recurse
      (insert key val (append read-so-far (car dict)) (cdr dict))
    )
  )
)

(define (get key dict)
  (cdr (assoc key dict))
  ; (cond
  ;   ((null? dict)
  ;     '()
  ;   )
  ;   ((eq? key (car (car dict))) ;;compare element to key of a key value pair in dict
  ;     (cdr (car dict))
  ;   )
  ;   (else
  ;     (get key (cdr dict))
  ;   )
  ; )
)


; Returns an object that represents a frame in an environment, with
; the given parent. The parent must either be the empty list or
; another frame object.
;
; Does not do any error checking.
;
; > (define f1 (frame '()))
; > (define f2 (frame f1))
; > (f1 'insert 'x 3)
; > (f1 'get 'x)
; 3
; > (f2 'get 'x)
; 3
; > (f2 'insert 'x 4)
; > (f1 'get 'x)
; 3
; > (f2 'get 'x)
; 4
; > (f2 'insert 'y -7)
; > (f2 'get 'y)
; -7
; > (f1 'contains 'y)
; #f
(define (frame parent)
  (lambda (message . args)  ; replace with your solution
    '()
  )
)
