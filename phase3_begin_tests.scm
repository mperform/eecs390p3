;;; Test cases for begin special form, Phase 3.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(begin 
  (+ 1 2)
)
; expect 3

(begin 
  (+ 3 4)
  (+ 1 2)
)
; expect 3

(begin 
  (display (+ 3 4))
  (newline)
  (display (+ 1 2))
  (newline)
)
; expect 7 ; 3
