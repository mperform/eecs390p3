(define item  #f)

item

(= #f item)

(define constant 9.8)

constant

(define mass 10)

mass

(define force (* mass constant))

force

(define lst (list))

lst

(define (cube x ) (* x (* x x)))

(cube 2)

(cube (- 2 -1))

(define (to-the-9th x) (* (cube x) (cube x)))

(to-the-9th 3)

((lambda (x y) 
    (+ x (to-the-9th y))
    )
1 2
)
