;;; Test cases for Scheme quote special form, Phase 3.

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(quote x)
; expect x

'()
; expect ()

'(quote x)
; expect (quote x)

'(+ 1 3)
; expect (+ 1 3)

''x
; expect (quote x)
