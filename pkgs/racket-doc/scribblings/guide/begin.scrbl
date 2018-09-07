#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "begin"]{Sequencing}

@title[#:tag "begin"]{序列}

@; Racket programmers prefer to write programs with as few side-effects
@; as possible, since purely functional code is more easily tested and
@; composed into larger programs. Interaction with the external
@; environment, however, requires sequencing, such as when writing to a
@; display, opening a graphical window, or manipulating a file on disk.

Racket 程序员更喜欢编写副作用尽可能少的程序，因为纯函数式代码更容易测试
并组合到更大的程序中。然而，与外部环境交互需要序列，如写入到显式，
打开图形窗口或操作磁盘上的文件等。

@;------------------------------------------------------------------------
@; @section{Effects Before: @racket[begin]}

@section{作用在前：@racket[begin]}

@refalso["begin"]{@racket[begin]}

@; A @racket[begin] expression sequences expressions:

@racket[begin] 表达式用于串连表达式：

@specform[(begin expr ...+)]{}

@; The @racket[_expr]s are evaluated in order, and the result of all but
@; the last @racket[_expr] is ignored. The result from the last
@; @racket[_expr] is the result of the @racket[begin] form, and it is in
@; tail position with respect to the @racket[begin] form.

@racket[_expr] 会按顺序求值，且除最后一个 @racket[_expr] 之外的所有结果都会被忽略。最后一个 @racket[_expr] 的结果即为整个 @racket[begin] 形式的结果，它在对应的 @racket[begin] 形式的尾部。

@defexamples[
(define (print-triangle height)
  (if (zero? height)
      (void)
      (begin
        (display (make-string height #\*))
        (newline)
        (print-triangle (sub1 height)))))
(print-triangle 4)
]

@; Many forms, such as @racket[lambda] or @racket[cond] support a
@; sequence of expressions even without a @racket[begin]. Such positions are
@; sometimes said to have an @deftech{implicit begin}.

很多形式，例如 @racket[lambda] 或 @racket[cond] 即便没有 @racket[begin]
也支持表达式序列。有时可以说这样的位置拥有一个 @deftech{隐式 begin}。

@defexamples[
(define (print-triangle height)
  (cond
    [(positive? height)
     (display (make-string height #\*))
     (newline)
     (print-triangle (sub1 height))]))
(print-triangle 4)
]

@; The @racket[begin] form is special at the top level, at module level,
@; or as a @racket[body] after only internal definitions. In those
@; positions, instead of forming an expression, the content of
@; @racket[begin] is spliced into the surrounding context.

@racket[begin] 形式在顶级、模块级或只在内部定义中作为 @racket[body] 时是特殊的。
在这些位置，它并不会构成一个表达式，而是 @racket[begin] 的内容会被分割为周围的上下文。

@defexamples[
(let ([curly 0])
  (begin
    (define moe (+ 1 curly))
    (define larry (+ 1 moe)))
  (list larry curly moe))
]

@; This splicing behavior is mainly useful for macros, as we discuss
@; later in @secref["macros"].

这种分割的行为主要用于宏，我们会在之后的 @secref["macros"] 一章中讨论。

@;------------------------------------------------------------------------
@; @section{Effects After: @racket[begin0]}

@section{作用在后：@racket[begin0]}

@refalso["begin"]{@racket[begin0]}

@; A @racket[begin0] expression has the same syntax as a @racket[begin]
@; expression:

@racket[begin0] 表达式的语法与 @racket[begin] 表达式相同：

@specform[(begin0 expr ...+)]{}

@; The difference is that @racket[begin0] returns the result of the first
@; @racket[expr], instead of the result of the last @racket[expr]. The
@; @racket[begin0] form is useful for implementing side-effects that
@; happen after a computation, especially in the case where the
@; computation produces an unknown number of results.

不同之处在于 @racket[begin0] 返回第一个 @racket[expr] 的结果，而非最后一个
@racket[expr] 的结果。@racket[begin0] 形式对于实现发生在计算之前的副作用，
特别是产生结果数量未知的计算来说很有用。

@defexamples[
(define (log-times thunk)
  (printf "Start: ~s\n" (current-inexact-milliseconds))
  (begin0
    (thunk)
    (printf "End..: ~s\n" (current-inexact-milliseconds))))
(log-times (lambda () (sleep 0.1) 0))
(log-times (lambda () (values 1 2)))
]

@;------------------------------------------------------------------------
@; @section[#:tag "when+unless"]{Effects If...: @racket[when] and @racket[unless]}

@section[#:tag "when+unless"]{按条件作用：@racket[when] 与 @racket[unless]}

@; @refalso["when+unless"]{@racket[when] and @racket[unless]}

@refalso["when+unless"]{@racket[when] 与 @racket[unless]}

@; The @racket[when] form combines an @racket[if]-style conditional with
@; sequencing for the ``then'' clause and no ``else'' clause:

@racket[when] 形式为 ``then'' 从句结合了 @racket[if] 风格的条件和序列而没有
``else'' 从句：

@specform[(when test-expr then-body ...+)]

@; If @racket[_test-expr] produces a true value, then all of the
@; @racket[_then-body]s are evaluated. The result of the last
@; @racket[_then-body] is the result of the @racket[when] form.
@; Otherwise, no @racket[_then-body]s are evaluated and the
@; result is @|void-const|.

若 @racket[_test-expr] 产生了真值，那么所有的 @racket[_then-body] 都会被求值。
最后一个 @racket[_then-body] 即为  @racket[when] 形式的结果。否则
@racket[_then-body] 均不会被求值，且其结果为 @|void-const|。

@; The @racket[unless] form is similar:

@racket[unless] 形式是类似的：

@specform[(unless test-expr then-body ...+)]

@; The difference is that the @racket[_test-expr] result is inverted: the
@; @racket[_then-body]s are evaluated only if the @racket[_test-expr]
@; result is @racket[#f].

不同之处在于 @racket[_test-expr] 的结果是相反的：@racket[_then-body] 只在
@racket[_test-expr] 的结果为 @racket[#f] 时才会被求值。

@defexamples[
(define (enumerate lst)
  (if (null? (cdr lst))
      (printf "~a.\n" (car lst))
      (begin
        (printf "~a, " (car lst))
        (when (null? (cdr (cdr lst)))
          (printf "and "))
        (enumerate (cdr lst)))))
(enumerate '("Larry" "Curly" "Moe"))
]

@def+int[
(define (print-triangle height)
  (unless (zero? height)
    (display (make-string height #\*))
    (newline)
    (print-triangle (sub1 height))))
(print-triangle 4)
]
