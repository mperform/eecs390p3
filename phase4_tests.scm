;;; Test cases for mu special form, Phase 4.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

((mu (x) 3) 4)
; expect 3

((mu (x y)
   (+ x y)
 )
 2 3
)
; expect 5

((mu (x y)
   (display x)
   (newline)
   (display y)
   (newline)
   (+ x y)
 )
 2 3
)
; expect 2 ; 3 ; 5

((mu (x)
   (+ x y)
 )
 3
)
; expect Error

(define y 5)
((mu (x)
   (+ x y)
 )
 3
)
; expect 8

(define foo (mu (x)
              (+ x y)
            ))
(foo 3)
; expect 8

((mu (y)
   (foo -3)
 )
 2
)
; expect -1
