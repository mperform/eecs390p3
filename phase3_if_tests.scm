;;; Test cases for Scheme if special form, Phase 3.

;;; These are examples from several sections of "The Structure
;;; and Interpretation of Computer Programs" by Abelson and Sussman.

;;; License: Creative Commons share alike with attribution

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(if 0 1 2)
; expect 1

(if (list) 1 2)
; expect 1

(if #t 1 (/ 1 0))
; expect 1

(if #f (/ 1 0) 2)
; expect 2

(if 0 (+ 1 2))
; expect 3

(if #f (/ 1 0))
; expect
