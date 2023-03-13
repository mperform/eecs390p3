;;; Test cases for mu special form, Phase 4.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(define y 5)
(define a 1000)
((mu (x)
   (+ x y)
 )
 3
)
; expect 8

(define foo (mu (x)
              (+ x y)
            ))
(foo 3 4)
; expect Error

(define bar (mu (c)
   (foo a)
 )
)
(bar 2)
; expect -1

(define foobar (mu (a)
   (bar (+ 4 y))
 )
)

((mu (y)
   (foobar 4)
 )
 -100
)
; expect -96
