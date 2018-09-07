#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title{Named @racket[let]}

@title{命名的 @racket[let]}

@; A named @racket[let] is an iteration and recursion form. It uses the
@; same syntactic keyword @racket[let] as for local binding, but an
@; identifier after the @racket[let] (instead of an immediate open
@; parenthesis) triggers a different parsing.

命名的 @racket[let] 是一种递归或迭代的形式。它使用相同的语法关键字 @racket[let]
进行局部绑定，但 @racket[let] 之后的标识符（而非紧跟着的开括号）会触发不同的解析过程。

@specform[
(let proc-id ([arg-id init-expr] ...)
  body ...+)
]

@; A named @racket[let] form is equivalent to

命名的 @racket[let] 形式等价于

@racketblock[
(letrec ([_proc-id (lambda (_arg-id ...)
                     _body ...+)])
  (_proc-id _init-expr ...))
]

@; That is, a named @racket[let] binds a function identifier that is
@; visible only in the function's body, and it implicitly calls the
@; function with the values of some initial expressions.

也就是说，命名的 @racket[let] 只绑定在函数体中可见的函数标识符，
且它隐式地以某些初始表达式的值调用了函数。

@defexamples[
(define (duplicate pos lst)
  (let dup ([i 0]
            [lst lst])
   (cond
    [(= i pos) (cons (car lst) lst)]
    [else (cons (car lst) (dup (+ i 1) (cdr lst)))])))
(duplicate 1 (list "apple" "cheese burger!" "banana"))
]

