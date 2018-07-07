#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt"
          (for-label racket/undefined
                     racket/shared))

@; @title[#:tag "void+undefined"]{Void and Undefined}

@title[#:tag "void+undefined"]{void 与 undefined}

@; Some procedures or expression forms have no need for a result
@; value. For example, the @racket[display] procedure is called only for
@; the side-effect of writing output. In such cases the result value is
@; normally a special constant that prints as @|void-const|.  When the
@; result of an expression is simply @|void-const|, the @tech{REPL} does not
@; print anything.

有些过程或表达式形式无需产生结果值。例如，调用过程 @racket[display]
只是为了其写入到输出的副作用。此时的结果值一般为打印作 @|void-const|
的特殊常量当表达式的结果只是简单的 @|void-const| 时，@tech{REPL}
不会打印任何东西。

@; The @racket[void] procedure takes any number of arguments and returns
@; @|void-const|. (That is, the identifier @racketidfont{void} is bound
@; to a procedure that returns @|void-const|, instead of being bound
@; directly to @|void-const|.)

过程 @racket[void] 接受任意数量的参数并返回 @|void-const|。
（也就是说，标识符 @racketidfont{void} 被绑定到了一个返回 @|void-const|
的过程上，而非直接绑定到 @|void-const|。）

@examples[
(void)
(void 1 2 3)
(list (void))
]

@; The @racket[undefined] constant, which prints as @|undefined-const|, is
@; sometimes used as the result of a reference whose value is not yet
@; available. In previous versions of Racket (before version 6.1),
@; referencing a local binding too early produced @|undefined-const|;
@; too-early references now raise an exception, instead.

@; @margin-note{The @racket[undefined] result can still be produced
@; in some cases by the @racket[shared] form.}

常量 @racket[undefined] 打印为 @|undefined-const|，当某个引用的值不可用时，
它通常作为其结果来使用。在 6.1 版之前的 Racket 中，过早地引用局部绑定会产生
@|undefined-const|；而现在过早的引用则会触发一个异常。

@margin-note{@racket[undefined] 的结果也可以在某些使用 @racket[shared]
形式的情况下产生。}

@def+int[
(define (fails)
  (define x x)
  x)
(fails)
]
