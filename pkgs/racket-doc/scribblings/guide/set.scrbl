#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "set!"]{Assignment: @racket[set!]}

@title[#:tag "set!"]{赋值：@racket[set!]}

@refalso["set!"]{@racket[set!]}

@; Assign to a variable using @racket[set!]:

对变量赋值使用 @racket[set!]：

@specform[(set! id expr)]

@; A @racket[set!] expression evaluates @racket[_expr] and changes
@; @racket[_id] (which must be bound in the enclosing environment) to the
@; resulting value. The result of the @racket[set!]  expression itself is
@; @|void-const|.

@racket[set!] 表达式对 @racket[_expr] 进行求值并更改 @racket[_id]
（它必须在环境内被绑定）的值为该结果。@racket[set!] 表达式的结果本身为
@|void-const|。

@defexamples[
(define greeted null)
(define (greet name)
  (set! greeted (cons name greeted))
  (string-append "Hello, " name))

(greet "Athos")
(greet "Porthos")
(greet "Aramis")
greeted
]

@defs+int[
[(define (make-running-total)
   (let ([n 0])
     (lambda ()
       (set! n (+ n 1))
       n)))
 (define win (make-running-total))
 (define lose (make-running-total))]
(win)
(win)
(lose)
(win)
]

@;------------------------------------------------------------------------
@; @section[#:tag "using-set!"]{Guidelines for Using Assignment}

@section[#:tag "using-set!"]{赋值使用准则}

@; Although using @racket[set!] is sometimes appropriate, Racket style
@; generally discourages the use of @racket[set!]. The following
@; guidelines may help explain when using @racket[set!] is appropriate.

尽管有时使用 @racket[set!] 是恰当的，但 Racket 的风格通常不鼓励使用
@racket[set!]。以下准则可以帮助你澄清何时使用 @racket[set!] 是恰当的。

@itemize[

@;  @item{As in any modern language, assigning to a shared identifier is no
@;        substitute for passing an argument to a procedure or getting
@;        its result.

@;        @as-examples[@t{@bold{@italic{Really awful}} example:}
@;        @defs+int[
@;        [(define name "unknown")
@;         (define result "unknown")
@;         (define (greet)
@;           (set! result (string-append "Hello, " name)))]
@;         (set! name "John")
@;         (greet)
@;         result
@;        ]]

@;       @as-examples[@t{Ok example:}
@;       @def+int[
@;         (define (greet name)
@;           (string-append "Hello, " name))
@;         (greet "John")
@;         (greet "Anna")
@;       ]]}

 @item{在任何现代语言中，对共享的标识符赋值都不能取代向过程中传入参数或获取其结果。

       @as-examples[@t{@bold{@italic{非常糟糕}}的示例：}
       @defs+int[
       [(define name "unknown")
        (define result "unknown")
        (define (greet)
          (set! result (string-append "Hello, " name)))]
        (set! name "John")
        (greet)
        result
       ]]

      @as-examples[@t{良好的示例：}
      @def+int[
        (define (greet name)
          (string-append "Hello, " name))
        (greet "John")
        (greet "Anna")
      ]]}

@;-- FIXME: explain more _why_ it's inferior
@;  @item{A sequence of assignments to a local variable is far inferior
@;        to nested bindings.

@;        @as-examples[@t{@bold{Bad} example:}
@;        @interaction[
@;        (let ([tree 0])
@;          (set! tree (list tree 1 tree))
@;          (set! tree (list tree 2 tree))
@;          (set! tree (list tree 3 tree))
@;          tree)]]

@;        @as-examples[@t{Ok example:}
@;        @interaction[
@;        (let* ([tree 0]
@;               [tree (list tree 1 tree)]
@;               [tree (list tree 2 tree)]
@;               [tree (list tree 3 tree)])
@;          tree)]]}

 @item{一系列对局部变量的赋值远不如嵌套的绑定。

       @as-examples[@t{@bold{糟糕}的示例：}
       @interaction[
       (let ([tree 0])
         (set! tree (list tree 1 tree))
         (set! tree (list tree 2 tree))
         (set! tree (list tree 3 tree))
         tree)]]

       @as-examples[@t{良好的示例}
       @interaction[
       (let* ([tree 0]
              [tree (list tree 1 tree)]
              [tree (list tree 2 tree)]
              [tree (list tree 3 tree)])
         tree)]]}

@;  @item{Using assignment to accumulate results from an iteration is
@;        bad style. Accumulating through a loop argument is better.

@;        @as-examples[@t{Somewhat bad example:}
@;        @def+int[
@;        (define (sum lst)
@;          (let ([s 0])
@;            (for-each (lambda (i) (set! s (+ i s)))
@;                      lst)
@;            s))
@;        (sum '(1 2 3))
@;        ]]

@;        @as-examples[@t{Ok example:}
@;        @def+int[
@;        (define (sum lst)
@;          (let loop ([lst lst] [s 0])
@;            (if (null? lst)
@;                s
@;                (loop (cdr lst) (+ s (car lst))))))
@;        (sum '(1 2 3))
@;        ]]

@;        @as-examples[@t{Better (use an existing function) example:}
@;        @def+int[
@;        (define (sum lst)
@;          (apply + lst))
@;        (sum '(1 2 3))
@;        ]]

@;        @as-examples[@t{Good (a general approach) example:}
@;        @def+int[
@;        (define (sum lst)
@;          (for/fold ([s 0])
@;                    ([i (in-list lst)])
@;            (+ s i)))
@;        (sum '(1 2 3))
@;        ]]  }

 @item{在迭代中使用赋值来累计结果是种糟糕的风格。通过循环参数来累计要更好。

       @as-examples[@t{有时比较糟糕的示例：}
       @def+int[
       (define (sum lst)
         (let ([s 0])
           (for-each (lambda (i) (set! s (+ i s)))
                     lst)
           s))
       (sum '(1 2 3))
       ]]

       @as-examples[@t{良好的示例}
       @def+int[
       (define (sum lst)
         (let loop ([lst lst] [s 0])
           (if (null? lst)
               s
               (loop (cdr lst) (+ s (car lst))))))
       (sum '(1 2 3))
       ]]

       @as-examples[@t{更好的示例（使用了既有的函数）：}
       @def+int[
       (define (sum lst)
         (apply + lst))
       (sum '(1 2 3))
       ]]

       @as-examples[@t{绝佳的示例（一种通用的方法）：}
       @def+int[
       (define (sum lst)
         (for/fold ([s 0])
                   ([i (in-list lst)])
           (+ s i)))
       (sum '(1 2 3))
       ]]  }

@;  @item{For cases where stateful objects are necessary or appropriate,
@;        then implementing the object's state with @racket[set!] is
@;        fine.

@;        @as-examples[@t{Ok example:}
@;        @def+int[
@;        (define next-number!
@;          (let ([n 0])
@;            (lambda ()
@;              (set! n (add1 n))
@;              n)))
@;        (next-number!)
@;        (next-number!)
@;        (next-number!)]]}

 @item{在必须或适于使用带状态对象的情况下，用 @racket[set!] 来实现对象的状态也是可以的。

       @as-examples[@t{Ok example:}
       @def+int[
       (define next-number!
         (let ([n 0])
           (lambda ()
             (set! n (add1 n))
             n)))
       (next-number!)
       (next-number!)
       (next-number!)]]}

]

@; All else being equal, a program that uses no assignments or mutation
@; is always preferable to one that uses assignments or mutation. While
@; side effects are to be avoided, however, they should be used if the
@; resulting code is significantly more readable or if it implements a
@; significantly better algorithm.

其它所有等价的情况下，不使用赋值或可变量的程序总是优于使用赋值或可变量的程序。
然而，即便在副作用可以被避免的情况下，当使用赋值能够显著提升可读性或能够实现
明显更好的算法时，那就应该使用它。

@; The use of mutable values, such as vectors and hash tables, raises
@; fewer suspicions about the style of a program than using @racket[set!]
@; directly. Nevertheless, simply replacing @racket[set!]s in a program
@; with @racket[vector-set!]s obviously does not improve the style of
@; the program.

比起直接使用 @racket[set!] 来说，使用向量或散列表这类可变值能减少
对程序风格的疑虑，然而，简单地将程序中的 @racket[set!] 替换为
@racket[vector-set!] 显然无法提升程序的风格。

@;------------------------------------------------------------------------
@; @section{Multiple Values: @racket[set!-values]}

@section{多重赋值：@racket[set!-values]}

@refalso["set!"]{@racket[set!-values]}

@; The @racket[set!-values] form assigns to multiple variables at once,
@; given an expression that produces an appropriate number of values:

@racket[set!-values] 形式可一次对多个变量赋值，给定一个产生对应数量的值的表达式：

@specform[(set!-values (id ...) expr)]

@; This form is equivalent to using @racket[let-values] to receive
@; multiple results from @racket[_expr], and then assigning the results
@; individually to the @racket[_id]s using @racket[set!].

此形式等价于使用 @racket[let-values] 从 @racket[_expr] 中接收多个结果，
然后使用 @racket[set!] 将这些结果分别赋予这些 @racket[_id]。

@; @defexamples[
@; (define game
@;   (let ([w 0]
@;         [l 0])
@;     (lambda (win?)
@;       (if win?
@;           (set! w (+ w 1))
@;           (set! l (+ l 1)))
@;       (begin0
@;         (values w l)
@;         (code:comment @#,t{swap sides...})
@;         (set!-values (w l) (values l w))))))
@; (game #t)
@; (game #t)
@; (game #f)]

@defexamples[
(define game
  (let ([w 0]
        [l 0])
    (lambda (win?)
      (if win?
          (set! w (+ w 1))
          (set! l (+ l 1)))
      (begin0
        (values w l)
        (code:comment @#,t{交换位置...})
        (set!-values (w l) (values l w))))))
(game #t)
(game #t)
(game #f)]
