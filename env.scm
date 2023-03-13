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
      (lambda (message . args)
        (cond
          ((eq? message 'contains)
            (contains (car args) dict)
          )
          ((eq? message 'insert)
            (let ((entry (assoc (car args) dict)))
              (cond 
                ((not entry) ;; Not found --> means you insert
                  (set! dict (append dict (list (cons (car args) (cadr args)))))
                )
                (else ;; Found --> modify
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
  (let ((dict (dictionary)))
  (lambda (message . args)  ; replace with your solution
    (cond
          ((eq? message 'insert)
            (dict 'insert (car args) (cadr args))
          )
          ((eq? message 'contains)
            (cond 
              ((dict 'contains (car args))
                #t
              )
              ((null? parent)
                #f
              )
              (else (apply parent (cons message args)))
            )
          )
          ((eq? message 'get)
            (cond 
              ((dict 'contains (car args))
                (dict 'get (car args))
              )
              (else (apply parent (cons message args)))
            )
          )
        )
  ))
)
