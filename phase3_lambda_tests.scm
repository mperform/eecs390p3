;;; Test cases for Scheme lambda special form, Phase 3.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

((lambda (x) 3) 4)
; expect 3

((lambda (x y)
   (+ x y)
 )
 2 3
)
; expect 5

((lambda (x y)
   (display x)
   (newline)
   (display y)
   (newline)
   (+ x y)
 )
 2 3
)
; expect 2 ; 3 ; 5

(((lambda (x)
    (lambda (y)
      (+ x y)
    )
  )
  2
 )
 3
)
; expect 5
