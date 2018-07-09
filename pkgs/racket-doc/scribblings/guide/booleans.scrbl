#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "booleans"]{Booleans}

@title[#:tag "booleans"]{布尔值}

@; Racket has two distinguished constants to represent boolean values:
@; @racket[#t] for true and @racket[#f] for false. Uppercase
@; @racketvalfont{#T} and @racketvalfont{#F} are parsed as the same
@; values, but the lowercase forms are preferred.

Racket 用两个不同的常量来表示布尔值：@racket[#t] 表示真，@racket[#f] 表示假。
大写的 @racketvalfont{#T} 和 @racketvalfont{#F} 会被解析为相同的值，
不过小写形式是首选的。

@; The @racket[boolean?] procedure recognizes the two boolean
@; constants. In the result of a test expression for @racket[if],
@; @racket[cond], @racket[and], @racket[or], etc., however, any value
@; other than @racket[#f] counts as true.

过程 @racket[boolean?] 用于识别这两个布尔常量。然而在 @racket[if]、@racket[cond]、
@racket[and] 和 @racket[or] 等测试表达式中，任何非 @racket[#f] 的值均被视为真。
@examples[
(= 2 (+ 1 1))
(boolean? #t)
(boolean? #f)
(boolean? "no")
(if "no" 1 0)
]

