#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@(define qq (racket quasiquote))
@(define uq (racket unquote))

@; @title[#:tag "qq"]{Quasiquoting: @racket[quasiquote] and @racketvalfont{`}}

@title[#:tag "qq"]{准引述：@racket[quasiquote] 与 @racketvalfont{`}}

@refalso["quasiquote"]{@racket[quasiquote]}

@; The @racket[quasiquote] form is similar to @racket[quote]:

@racket[quasiquote] 形式类似于 @racket[quote]：

@specform[(#,qq datum)]

@; However, for each @racket[(#,uq _expr)]
@; that appears within the @racket[_datum], the @racket[_expr] is
@; evaluated to produce a value that takes the place of the
@; @racket[unquote] sub-form.

然而，对于每一个出现在 @racket[_datum] 中的 @racket[(#,uq _expr)]，
@racket[_expr] 都会被求值，所产生的值会在 @racket[unquote] 子形式中占据对应的位置。

@examples[
(eval:alts (#,qq (1 2 (#,uq (+ 1 2)) (#,uq (- 5 1))))
           `(1 2 ,(+ 1 2), (- 5 1)))
]

@; This form can be used to write functions that build lists according to
@; certain patterns.

此形式和用于编写根据具体模式来构建列表的函数。

@examples[
(eval:alts (define (deep n)
             (cond
               [(zero? n) 0]
               [else
                (#,qq ((#,uq n) (#,uq (deep (- n 1)))))]))
           (define (deep n)
             (cond
               [(zero? n) 0]
               [else
                (quasiquote ((unquote n) (unquote (deep (- n 1)))))])))
(deep 8)
]

@; Or even to cheaply construct expressions programmatically. (Of course, 9 times out of 10,
@; you should be using a @seclink["macros"]{macro} to do this
@; (the 10th time being when you're working through
@; a textbook like @hyperlink["http://www.cs.brown.edu/~sk/Publications/Books/ProgLangs/"]{PLAI}).)

甚至还可以用很低的代价通过编程来构造表达式（当然，九成的情况下可行），
你可以使用@seclink["macros"]{宏}来完成它（剩下的一成在你阅读像
@hyperlink["http://www.cs.brown.edu/~sk/Publications/Books/ProgLangs/"]{PLAI}
这样的书时可以做到）。

@examples[(define (build-exp n)
            (add-lets n (make-sum n)))

          (eval:alts
           (define (add-lets n body)
             (cond
               [(zero? n) body]
               [else
                (#,qq
                 (let ([(#,uq (n->var n)) (#,uq n)])
                   (#,uq (add-lets (- n 1) body))))]))
           (define (add-lets n body)
             (cond
               [(zero? n) body]
               [else
                (quasiquote
                 (let ([(unquote (n->var n)) (unquote n)])
                   (unquote (add-lets (- n 1) body))))])))

          (eval:alts
           (define (make-sum n)
             (cond
               [(= n 1) (n->var 1)]
               [else
                (#,qq (+ (#,uq (n->var n))
                         (#,uq (make-sum (- n 1)))))]))
           (define (make-sum n)
             (cond
               [(= n 1) (n->var 1)]
               [else
                (quasiquote (+ (unquote (n->var n))
                               (unquote (make-sum (- n 1)))))])))
          (define (n->var n) (string->symbol (format "x~a" n)))
          (build-exp 3)]

@; The @racket[unquote-splicing] form is similar to @racket[unquote], but
@; its @racket[_expr] must produce a list, and the
@; @racket[unquote-splicing] form must appear in a context that produces
@; either a list or a vector. As the name suggests, the resulting list
@; is spliced into the context of its use.

@racket[unquote-splicing] 形式类似于 @racket[unquote]，不过其 @racket[_expr]
必须产生一个列表，且 @racket[unquote-splicing] 形式必须出现在产生列表或向量
的上下文中。顾名思义，其结果列表会被切分成它所使用的上下文。

@examples[
(eval:alts (#,qq (1 2 (#,(racket unquote-splicing) (list (+ 1 2) (- 5 1))) 5))
           `(1 2 ,@(list (+ 1 2) (- 5 1)) 5))
]

@; Using splicing we can revise the construction of our example expressions above
@; to have just a single @racket[let] expression and a single @racket[+] expression.

通过使用切分，我们只需一个 @racket[let] 表达式和一个 @racket[+] 就能修订前面
示例表达式的构造。

@examples[(eval:alts
           (define (build-exp n)
             (add-lets
              n
              (#,qq (+ (#,(racket unquote-splicing)
                        (build-list
                         n
                         (λ (x) (n->var (+ x 1)))))))))
           (define (build-exp n)
             (add-lets
              n
              (quasiquote (+ (unquote-splicing
                              (build-list
                               n
                               (λ (x) (n->var (+ x 1))))))))))
          (eval:alts
           (define (add-lets n body)
             (#,qq
              (let (#,uq
                    (build-list
                     n
                     (λ (n)
                       (#,qq
                        [(#,uq (n->var (+ n 1))) (#,uq (+ n 1))]))))
                (#,uq body))))
           (define (add-lets n body)
             (quasiquote
              (let (unquote
                    (build-list
                     n
                     (λ (n)
                       (quasiquote
                        [(unquote (n->var (+ n 1))) (unquote (+ n 1))]))))
                (unquote body)))))
          (define (n->var n) (string->symbol (format "x~a" n)))
          (build-exp 3)]

@; If a @racket[quasiquote] form appears within an enclosing
@; @racket[quasiquote] form, then the inner @racket[quasiquote]
@; effectively cancels one layer of @racket[unquote] and
@; @racket[unquote-splicing] forms, so that a second @racket[unquote]
@; or @racket[unquote-splicing] is needed.

若某个 @racket[quasiquote] 形式嵌套在另一个 @racket[quasiquote] 形式中，
那么内部的 @racket[quasiquote] 实际上会取消掉一层 @racket[unquote]
和 @racket[unquote-splicing] 形式，因此需要第二个 @racket[unquote]
或 @racket[unquote-splicing]。

@examples[
(eval:alts (#,qq (1 2 (#,qq (#,uq (+ 1 2)))))
           `(1 2 (,(string->uninterned-symbol "quasiquote")
                  (,(string->uninterned-symbol "unquote") (+ 1 2)))))
(eval:alts (#,qq (1 2 (#,qq (#,uq (#,uq (+ 1 2))))))
           `(1 2 (,(string->uninterned-symbol "quasiquote")
                  (,(string->uninterned-symbol "unquote") 3))))
(eval:alts (#,qq (1 2 (#,qq ((#,uq (+ 1 2)) (#,uq (#,uq (- 5 1)))))))
           `(1 2 (,(string->uninterned-symbol "quasiquote")
                  ((,(string->uninterned-symbol "unquote") (+ 1 2))
                   (,(string->uninterned-symbol "unquote") 4)))))
]

@; The evaluations above will not actually print as shown. Instead, the
@; shorthand form of @racket[quasiquote] and @racket[unquote] will be
@; used: @litchar{`} (i.e., a backquote) and @litchar{,} (i.e., a comma).
@; The same shorthands can be used in expressions:

前面的求值实际上并不会打印成上面所示那样。而是会使用 @racket[quasiquote]
和 @racket[unquote] 的简写信息：@litchar{`}（即反引号）和
@litchar{,}（即逗号）。同样的简写也可在表达式中使用：

@examples[
`(1 2 `(,(+ 1 2) ,,(- 5 1)))
]

@; The shorthand form of @racket[unquote-splicing] is @litchar[",@"]:

@racket[unquote-splicing] 的简写形式为 @litchar[",@"]：

@examples[
`(1 2 ,@(list (+ 1 2) (- 5 1)))
]
