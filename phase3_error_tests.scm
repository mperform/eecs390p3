;;; Error test cases for special forms, Phase 3.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

;;; correct tests

(define x 3)
; expect x

x
; expect 3

((lambda (x) 3) 4)
; expect 3

(if #t 3 4)
; expect 3

;;; error tests

(define x 3 4)
; expect Error

(define 4 5)
; expect Error

(lambda (x y x) 3)
; expect Error

(if #t)
; expect Error
