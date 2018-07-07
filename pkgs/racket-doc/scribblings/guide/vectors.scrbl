#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "vectors"]{Vectors}

@title[#:tag "vectors"]{向量}

@; A @deftech{vector} is a fixed-length array of arbitrary
@; values. Unlike a list, a vector supports constant-time access and
@; update of its elements.

@deftech{向量}是任意值的定长数组。与列表不同，向量支持常量时间的元素访问和更新。

@; A vector prints similar to a list---as a parenthesized sequence of its
@; elements---but a vector is prefixed with @litchar{#} after
@; @litchar{'}, or it uses @racketresult[vector] if one of its elements
@; cannot be expressed with @racket[quote].

向量的打印形式与列表类似，都是带括号的元素序列，不过向量在 @litchar{'}
之后还有 @litchar{#} 前缀；如果其中存在无法用 @racket[quote] 引述表达的元素，
则会使用 @racketresult[vector] 表示。

@; For a vector as an expression, an optional length can be
@; supplied. Also, a vector as an expression implicitly @racket[quote]s
@; the forms for its content, which means that identifiers and
@; parenthesized forms in a vector constant represent symbols and lists.

向量作为表达式时支持可选的长度。此外，向量作为表达式时隐式地用 @racket[quote]
引述了其内容的形式，这意味着向量内容中的标识符和括号括住的形式表示符号和列表。

@; @refdetails/gory["parse-vector"]{the syntax of vectors}

@refdetails/gory["parse-vector"]{向量语法}

@examples[
(eval:alts @#,racketvalfont{#("a" "b" "c")} #("a" "b" "c"))
(eval:alts @#,racketvalfont{#(name (that tune))} #(name (that tune)))
(eval:alts @#,racketvalfont{#4(baldwin bruce)} #4(baldwin bruce))
(vector-ref #("a" "b" "c") 1)
(vector-ref #(name (that tune)) 1)
]

@; Like strings, a vector is either mutable or immutable, and vectors
@; written directly as expressions are immutable.

与字符串类似，向量也分可变和不可变两种，直接写成表达式的向量是不可变的。

@; Vectors can be converted to lists and vice versa via
@; @racket[vector->list] and @racket[list->vector]; such conversions are
@; particularly useful in combination with predefined procedures on
@; lists. When allocating extra lists seems too expensive, consider
@; using looping forms like @racket[for/fold], which recognize vectors as
@; well as lists.

向量和列表之间可通过 @racket[vector->list] 和 @racket[list->vector] 互相转换，
这种转换在与列表的预定义过程组合时特别有用。当分配额外列表的代价看起来太高时，
可考虑使用 @racket[for/fold] 之类的循环形式，同列表一样，它也接受向量。

@examples[
(list->vector (map string-titlecase
                   (vector->list #("three" "blind" "mice"))))
]

@; @refdetails["vectors"]{vectors and vector procedures}

@refdetails["vectors"]{向量及其过程}
