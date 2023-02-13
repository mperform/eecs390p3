;;; Test cases for Scheme, Phase 3.

;;; These are examples from several sections of "The Structure
;;; and Interpretation of Computer Programs" by Abelson and Sussman.

;;; License: Creative Commons share alike with attribution

;;; Project UID 539e8badf616b510473c4657a8f7f9e717dc3ca9

(define size 2)
; expect size
size
; expect 2

(* 5 size)
; expect 10

(define pi 3.14159)
(define radius 10)
(* pi (* radius radius))
; expect 314.159

(define circumference (* 2 (* pi radius)))
circumference
; expect 62.8318

(define nil (list))
nil
; expect ()

;;; 1.1.4

(define (square x) (* x x))
; expect square
(square 21)
; expect 441

(define square (lambda (x) (* x x))) ; See Section 1.3.2
(square 21)
; expect 441

(square (+ 2 5))
; expect 49

(square (square 3))
; expect 81

(define (sum-of-squares x y)
  (+ (square x) (square y))
)
(sum-of-squares 3 4)
; expect 25

(define (f a)
  (sum-of-squares (+ a 1) (* a 2))
)
(f 5)
; expect 136

;;; 1.1.6

(define (abs x)
  (if (> x 0) x
      (if (= x 0) 0
          (- 0 x)
      )
  )
)
(abs -3)
; expect 3

(abs 0)
; expect 0

(abs 3)
; expect 3

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b)
)
(a-plus-abs-b 3 -2)
; expect 5

;;; 1.1.7

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)
  )
)
(define (improve guess x)
  (average guess (/ x guess))
)
(define (average x y)
  (/ (+ x y) 2)
)
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001)
)
(define (sqrt x)
  (sqrt-iter 1.0 x)
)
(sqrt 9)
; expect 3.00009155413138

(sqrt (+ 100 37))
; expect 11.704699917758145

(sqrt (+ (sqrt 2) (sqrt 3)))
; expect 1.7739279023207892

(square (sqrt 1000))
; expect 1000.000369924366

;;; 1.1.8

(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001)
  )
  (define (improve guess)
    (average guess (/ x guess))
  )
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))
    )
  )
  (sqrt-iter 1.0)
)
(sqrt 9)
; expect 3.00009155413138

(sqrt (+ 100 37))
; expect 11.704699917758145

(sqrt (+ (sqrt 2) (sqrt 3)))
; expect 1.7739279023207892

(square (sqrt 1000))
; expect 1000.000369924366

;;; 1.3.1

(define (cube x) (* (* x x) x))
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b)
      )
  )
)
(define (inc n) (+ n 1))
(define (sum-cubes a b)
  (sum cube a inc b)
)
(sum-cubes 1 10)
; expect 3025

(define (identity x) x)
(define (sum-integers a b)
  (sum identity a inc b)
)
(sum-integers 1 10)
; expect 55

;;; 1.3.2

((lambda (x y z) (+ (+ x y) (square z))) 1 2 3)
; expect 12

(define (f x y)
  (define a (+ 1 (* x y)))
  (define b (- 1 y))
  (+ (+ (* x (square a))
        (* y b)
     )
     (* a b)
  )
)
(f 3 4)
; expect 456

(define x 5)
(+ ((lambda (x)
     (+ x (* x 10))
    ) 3)
   x
)
; expect 38

;;; 2.1.1

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x))
            )
            (* (denom x) (denom y))
  )
)
(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x))
            )
            (* (denom x) (denom y))
  )
)
(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))
  )
)
(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))
  )
)
(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))
  )
)

(define x (cons 1 2))
(car x)
; expect 1

(cdr x)
; expect 2

(define x (cons 1 2))
(define y (cons 3 4))
(define z (cons x y))
(car (car z))
; expect 1

(car (cdr z))
; expect 3

z
; expect ((1 . 2) 3 . 4)

(define (make-rat n d) (cons n d))
(define (numer x) (car x))
(define (denom x) (cdr x))
(define (print-rat x)
  (display (numer x))
  (display '/)
  (display (denom x))
  (newline)
)
(define one-half (make-rat 1 2))
(print-rat one-half)
; expect 1/2

(define one-third (make-rat 1 3))
(print-rat (add-rat one-half one-third))
; expect 5/6

(print-rat (mul-rat one-half one-third))
; expect 1/6

(print-rat (add-rat one-third one-third))
; expect 6/9

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))
  )
)
(define (make-rat n d)
  ((lambda (g)
     (cons (/ n g) (/ d g))
   ) (gcd n d))
)
(print-rat (add-rat one-third one-third))
; expect 2/3

(define one-through-four '(1 2 3 4))
one-through-four
; expect (1 2 3 4)

(car one-through-four)
; expect 1

(cdr one-through-four)
; expect (2 3 4)

(car (cdr one-through-four))
; expect 2

(cons 10 one-through-four)
; expect (10 1 2 3 4)

(cons 5 one-through-four)
; expect (5 1 2 3 4)

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items))
      )
  )
)
(map abs '(-10 2.5 -11.6 17))
; expect (10 2.5 11.6 17)

(map (lambda (x) (* x x))
     '(1 2 3 4))
; expect (1 4 9 16)

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))
(scale-list '(1 2 3 4 5) 10)
; expect (10 20 30 40 50)

(define (count-leaves x)
  (if (null? x) 0
      (if (not (pair? x)) 1
          (+ (count-leaves (car x))
             (count-leaves (cdr x)))
      )
  )
)
(define x (cons '(1 2) '(3 4)))
(count-leaves x)
; expect 4

(count-leaves (cons x (cons x '())))
; expect 8

;;; 2.2.3

(define (odd? x) (= 1 (remainder x 2)))
(define (filter predicate sequence)
  (if (null? sequence) nil
      (if (predicate (car sequence))
          (cons (car sequence)
                (filter predicate (cdr sequence))
          )
          (filter predicate (cdr sequence))
      )
  )
)
(filter odd? '(1 2 3 4 5))
; expect (1 3 5)

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))
  )
)
(accumulate + 0 '(1 2 3 4 5))
; expect 15

(accumulate * 1 '(1 2 3 4 5))
; expect 120

(accumulate cons nil '(1 2 3 4 5))
; expect (1 2 3 4 5)

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))
  )
)
(enumerate-interval 2 7)
; expect (2 3 4 5 6 7)

;;; 2.3.1

(define a 1)

(define b 2)

(cons a (cons b (list)))
; expect (1 2)

(cons 'a (cons 'b (list)))
; expect (a b)

(cons 'a (cons b (list)))
; expect (a 2)

(car '(a b c))
; expect a

(cdr '(a b c))
; expect (b c)

(define (member item x)
  (if (null? x) #f
      (if (equal? item (car x)) x
          (member item (cdr x))
      )
  )
)
(member 'apple '(pear banana prune))
; expect #f

(member 'apple '(x (apple sauce) y apple pear))
; expect (apple pear)

;;; Peter Norvig tests (http://norvig.com/lispy2.html)

(define double (lambda (x) (* 2 x)))
(double 5)
; expect 10

(define (make-list x) (cons x (list)))
(define compose (lambda (f g) (lambda (x) (f (g x)))))
((compose make-list double) 5)
; expect (10)

(define apply-twice (lambda (f) (compose f f)))
((apply-twice double) 5)
; expect 20

((apply-twice (apply-twice double)) 5)
; expect 80

(define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))
(fact 3)
; expect 6

(fact 10)
; expect 3628800

(define (combine f)
  (lambda (x y)
    (if (null? x)
        nil
        (f (cons (car x) (cons (car y) (list)))
           ((combine f) (cdr x) (cdr y))
        )
    )
  )
)
(define zip (combine cons))
(zip '(1 2 3 4) '(5 6 7 8))
; expect ((1 5) (2 6) (3 7) (4 8))

;;; Additional tests

(if 0 1 2)
; expect 1

(if '() 1 2)
; expect 1

(if nil 1 2)
; expect 1

(if 0 1 2)
; expect 1

(define (loop) (loop))
(if #f (loop) 12)
; expect 12

((lambda (x) (display x) (newline) x) 2)
; expect 2 ; 2

(define (print-and-square x)
  (display x)
  (newline)
  (square x)
)
(print-and-square 12)
; expect 12 ; 144

(/ 1 0)
; expect Error

((begin (display "hello")
        (newline)
        (lambda (x) (+ x 1))
 ) 3)
; expect hello ; 4

;;; Test redefining special forms

(define foo define)
(foo x 3)
; expect x
x
; expect 3
(define define 3)
; expect define
(+ define 4)
; expect 7
(define x 4)
; expect Error
(foo define foo)
; expect define
(define y 4)
; expect y
y
; expect 4
