;;; Test cases for Scheme, Phase 2.

;;; These are examples from several sections of "The Structure
;;; and Interpretation of Computer Programs" by Abelson and Sussman.

;;; License: Creative Commons share alike with attribution

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

;;; 1.1.1

10
; expect 10

(+ 137 349)
; expect 486

(- 1000 334)
; expect 666

(* 5 99)
; expect 495

(/ 10 5)
; expect 2

(/ 10.5 5)
; expect 2.1

(+ 2.7 10)
; expect 12.7

(+ (* 3 5) (- 10 6))
; expect 19

(+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6))
; expect 57

(+ (* 3
      (+ (* 2 4)
         (+ 3 5)
      )
   )
   (+ (- 10 7)
      6
   )
)
; expect 57

(= 3 4)
; expect #f

(= (+ 1 2) (/ 9 3))
; expect #t

(< 3 4)
; expect #t

(< 4 4)
; expect #f

(<= 3 3)
; expect #t

(cons 3 4)
; expect (3 . 4)

(cdr (cons 3 4))
; expect 4

((car (cons + 3)) 4 5)
; expect 9
