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
      (lambda (message . args)  ; replace with your solution
        (cond
          ((eq? message 'contains)
            (contains (car args) dict)
          )
          ((eq? message 'insert)
            ; (set! dict (insert (car args) (cadr args) dict))
            (let ((entry (assoc (car args) dict)))
              (cond 
                ((not entry)
                  (set! dict (append dict (list (cons (car args) (cadr args)))))
                )
                (else 
                  (set-cdr! entry (cadr args))
                )
              )
            )
          )
          ((eq? message 'get)
            (get (car args) dict)
          )
          ((eq? message 'length)
            (len dict 0)
          )
        )
      )
    ; get, contain, length, insert
      ; a "chain" of pairs I assume? (key, value)
      ; not sure how to hash the key to the value tho, or we iterate to find the value according to the key
      ; insert: use cdr or car to recursively iterate, set to modify, etc
      ; length: iterate thru to find the length
  )
)
(define (len dict cnt)
  (cond
    ((null? dict)
      cnt
    )
    (else
      (len (cdr dict) (+ cnt 1))
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

(define (insert key val dict)
  (let ((entry (assoc key dict)))
    (display entry)
       (display "\n")
       (display dict)
       (display "\n")
    (cond 
      ((not entry)
       (display entry)
       (display "\n")
       (display dict)
       (display "\n")
        (append dict (list (cons key val)))
      )
      (
        else ( ;I want to modify entry and then return modified dict
          set-cdr! entry val
          )
      )

    )
  )
  ; (cond 
  ;   ((null? dict)
  ;     (display "\n")
  ;     (display "read-so-far: ")
  ;     (display read-so-far)
  ;     (display "\n")
  ;     (append read-so-far (list (cons key val)))
  ;   ); dict is empty
  ;   ((eq? key (car (car dict))); key matches current key ;;THIS IS BROKEN
  ;     (display read-so-far)
  ;     (display "\n")
  ;     (display dict)
  ;     (display "\n")
  ;     (append read-so-far (set-car! dict (cons key val)))
  ;   )
  ;   (else ;recurse
  ;     ;(display (car (car dict)))
  ;     (insert key val (append read-so-far (list (car dict))) (cdr dict))
  ;   )
  ; )
)

(define (get key dict)
  (cdr (assoc key dict))
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
