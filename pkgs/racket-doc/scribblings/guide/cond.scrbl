#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "conditionals"]{Conditionals}

@title[#:tag "conditionals"]{条件分支}

@; Most functions used for branching, such as @racket[<] and
@; @racket[string?], produce either @racket[#t] or @racket[#f]. Racket's
@; branching forms, however, treat any value other than @racket[#f] as
@; true. We say a @defterm{true value} to mean any value other than
@; @racket[#f].

大部分用于条件分支的函数（如 @racket[<] 何 @racket[string?]）会产生
@racket[#t] 或 @racket[#f]。然而 Racket 的分支形式会将除 @racket[#f]
之外的任何值都视为真。我们用@defterm{真值}表示除 @racket[#f] 以外的任何值。

@; This convention for ``true value'' meshes well with protocols where
@; @racket[#f] can serve as failure or to indicate that an optional value
@; is not supplied. (Beware of overusing this trick, and remember that an
@; exception is usually a better mechanism to report failure.)

这种对“真值”的约定能够很好地与用 @racket[#f] 表示失败或可选的值不被支持的协议相融合。
（请注意不要滥用此技巧，异常通常是更好的失败报告机制。）

@; For example, the @racket[member] function serves double duty; it can
@; be used to find the tail of a list that starts with a particular item,
@; or it can be used to simply check whether an item is present in a
@; list:

例如，@racket[member] 函数有两种，它既可用于查找以某个特定项开始的列表的尾部，
也可用于简单地检查某项是否在列表中：

@interaction[
(member "Groucho" '("Harpo" "Zeppo"))
(member "Groucho" '("Harpo" "Groucho" "Zeppo"))
(if (member "Groucho" '("Harpo" "Zeppo"))
    'yep
    'nope)
(if (member "Groucho" '("Harpo" "Groucho" "Zeppo"))
    'yep
    'nope)
]

@;------------------------------------------------------------------------
@; @section{Simple Branching: @racket[if]}

@section{简单分支：@racket[if]}

@refalso["if"]{@racket[if]}

@; In an @racket[if] form,

在 @racket[if] 形式

@specform[(if test-expr then-expr else-expr)]

@; the @racket[_test-expr] is always evaluated. If it produces any value
@; other than @racket[#f], then @racket[_then-expr] is
@; evaluated. Otherwise, @racket[_else-expr] is evaluated.

中，@racket[_test-expr] 总是会被求值。如果它产生了除 @racket[#f] 以外的任何值，
那么 @racket[_then-expr] 就会被求值。否则 @racket[_else-expr] 就会被求值。

@; An @racket[if] form must have both a @racket[_then-expr] and an
@; @racket[_else-expr]; the latter is not optional. To perform (or skip)
@; side-effects based on a @racket[_test-expr], use @racket[when] or
@; @racket[unless], which we describe later in @secref["begin"].

@racket[if] 必须同时有 @racket[_then-expr] 和 @racket[_else-expr]，
后者并不是可选的。要处理（或跳过）基于 @racket[_test-expr] 的副作用，请使用
@racket[when] 或 @racket[unless]，我们会在之后的 @secref["begin"] 一节中讨论它。

@;------------------------------------------------------------------------
@; @section[#:tag "and+or"]{Combining Tests: @racket[and] and @racket[or]}

@section[#:tag "and+or"]{组合测试：@racket[and] 与 @racket[or]}

@; @refalso["if"]{@racket[and] and @racket[or]}

@refalso["if"]{@racket[and] 与 @racket[or]}

@; Racket's @racket[and] and @racket[or] are syntactic forms, rather than
@; functions. Unlike a function, the @racket[and] and @racket[or] forms
@; can skip evaluation of later expressions if an earlier one determines
@; the answer.

Racket 的 @racket[and] 与 @racket[or] 为语法形式而非函数。与函数不同，
@racket[and] 与 @racket[or] 形式在前一个表达式确定结果后可跳过后面表达式的求值。

@specform[(and expr ...)]

@; An @racket[and] form produces @racket[#f] if any of its @racket[_expr]s
@; produces @racket[#f]. Otherwise, it produces the value of its last
@; @racket[_expr]. As a special case, @racket[(and)] produces
@; @racket[#t].

@racket[and] 形式会在其任意一个 @racket[_expr] 产生 @racket[#f] 时产生
@racket[#f]。否则，它会产生其最后一个 @racket[_expr] 的值。作为特例，
@racket[(and)] 会产生 @racket[#t]。

@specform[(or expr ...)]

@; The @racket[or] form produces @racket[#f] if all of its
@; @racket[_expr]s produce @racket[#f]. Otherwise, it produces the first
@; non-@racket[#f] value from its @racket[expr]s.  As a special case,
@; @racket[(or)] produces @racket[#f].

@racket[or] 形式会在其所有 @racket[_expr] 产生 @racket[#f] 时产生
@racket[#f]。否则，它会产生其 @racket[expr] 中的第一个非 @racket[#f] 的值。
作为特例，@racket[(or)] 会产生 @racket[#f]。

@; @examples[
@; (code:line
@;  (define (got-milk? lst)
@;    (and (not (null? lst))
@;         (or (eq? 'milk (car lst))
@;             (got-milk? (cdr lst))))) (code:comment @#,t{recurs only if needed}))
@; (got-milk? '(apple banana))
@; (got-milk? '(apple milk banana))
@; ]

@examples[
(code:line
 (define (got-milk? lst)
   (and (not (null? lst))
        (or (eq? 'milk (car lst))
            (got-milk? (cdr lst))))) (code:comment @#,t{仅在需要时递归}))
(got-milk? '(apple banana))
(got-milk? '(apple milk banana))
]

@; If evaluation reaches the last @racket[_expr] of an @racket[and] or
@; @racket[or] form, then the @racket[_expr]'s value directly determines
@; the @racket[and] or @racket[or] result. Therefore, the last
@; @racket[_expr] is in tail position, which means that the above
@; @racket[got-milk?] function runs in constant space.

若求值抵达了 @racket[and] 或 @racket[or] 形式的最后一个 @racket[_expr]，那么
@racket[_expr] 的值会直接确定 @racket[and] 或 @racket[or] 的结果。因此，最后一个
@racket[_expr] 在尾部，这意味着 @racket[got-milk?] 函数的执行只需要常量空间。

@; @guideother{@secref["tail-recursion"] introduces tail calls and tail positions.}

@guideother{@secref["tail-recursion"] 介绍了尾调用和尾部位置。}

@;------------------------------------------------------------------------
@; @section[#:tag "cond"]{Chaining Tests: @racket[cond]}

@section[#:tag "cond"]{链式测试：@racket[cond]}

@; The @racket[cond] form chains a series of tests to select a result
@; expression. To a first approximation, the syntax of @racket[cond] is
@; as follows:

@racket[cond] 形式将一系列测试作为测试链来从中选取一个结果表达式。
@racket[cond] 的语法大致如下：

@refalso["if"]{@racket[cond]}

@specform[(cond [test-expr body ...+]
                ...)]

@; Each @racket[_test-expr] is evaluated in order. If it produces
@; @racket[#f], the corresponding @racket[_body]s are ignored, and
@; evaluation proceeds to the next @racket[_test-expr]. As soon as a
@; @racket[_test-expr] produces a true value, the associated @racket[_body]s
@; are evaluated to produce the result for the @racket[cond] form, and no
@; further @racket[_test-expr]s are evaluated.

每个 @racket[_test-expr] 都会按顺序求值。若它产生 @racket[#f]，那么其对应的
@racket[_body] 就会被忽略，然后对下一个 @racket[_test-expr] 进行求值。只要
@racket[_test-expr] 产生了真值，其相应的 @racket[_body] 就会被求值并产生
@racket[cond] 的结果，之后的 further @racket[_test-expr] 则不再被求值。

@; The last @racket[_test-expr] in a @racket[cond] can be replaced by
@; @racket[else]. In terms of evaluation, @racket[else] serves as a
@; synonym for @racket[#t], but it clarifies that the last clause is
@; meant to catch all remaining cases. If @racket[else] is not used, then
@; it is possible that no @racket[_test-expr]s produce a true value; in
@; that case, the result of the @racket[cond] expression is
@; @|void-const|.

@racket[cond] 中的最后一个 @racket[_test-expr] 可替换为 @racket[else]。
从求值的角度来说，@racket[else] 就是 @racket[#t] 的同义词，
不过它能清除地说明最后一个从句表示捕获所有剩余的情况。若 @racket[else]
未被使用，那么 @racket[_test-expr] 可能不会产生任何真值。此时， @racket[cond]
表达式的结果为 @|void-const|。

@examples[
(cond
 [(= 2 3) (error "wrong!")]
 [(= 2 2) 'ok])
(cond
 [(= 2 3) (error "wrong!")])
(cond
 [(= 2 3) (error "wrong!")]
 [else 'ok])
]

@def+int[
(define (got-milk? lst)
  (cond
    [(null? lst) #f]
    [(eq? 'milk (car lst)) #t]
    [else (got-milk? (cdr lst))]))
(got-milk? '(apple banana))
(got-milk? '(apple milk banana))
]

@; The full syntax of @racket[cond] includes two more kinds of clauses:

@racket[cond] 的完整语法还包括另外两种从句：

@specform/subs[#:literals (else =>)
               (cond cond-clause ...)
               ([cond-clause [test-expr then-body ...+]
                             [else then-body ...+]
                             [test-expr => proc-expr]
                             [test-expr]])]

@; The @racket[=>] variant captures the true result of its
@; @racket[_test-expr] and passes it to the result of the
@; @racket[_proc-expr], which must be a function of one argument.

@racket[=>] 的变体会捕获其 @racket[_test-expr] 为真的结果并将其传给
@racket[_proc-expr] 的结果中，它必须为单参数函数。

@examples[
(define (after-groucho lst)
  (cond
    [(member "Groucho" lst) => cdr]
    [else (error "not there")]))

(after-groucho '("Harpo" "Groucho" "Zeppo"))
(after-groucho '("Harpo" "Zeppo"))
]

@; A clause that includes only a @racket[_test-expr] is rarely used. It
@; captures the true result of the @racket[_test-expr], and simply
@; returns the result for the whole @racket[cond] expression.

只包含一个 @racket[_test-expr] 的从句很少被使用。它会捕获 @racket[_test-expr]
为真的结果，并简单地将其作为整个 @racket[cond] 表达式的结果返回。
