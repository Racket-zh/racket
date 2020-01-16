#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "quote"]{Quoting: @racket[quote] and @racketvalfont{'}}

@title[#:tag "quote"]{引述：@racket[quote] 与 @racketvalfont{'}}

@refalso["quote"]{@racket[quote]}

@; The @racket[quote] form produces a constant:

@racket[quote] 形式产生一个常量：

@specform[(#,(racketkeywordfont "quote") datum)]

@; The syntax of a @racket[datum] is technically specified as anything
@; that the @racket[read] function parses as a single element. The value
@; of the @racket[quote] form is the same value that @racket[read] would
@; produce given @racket[_datum].

从技术上来说，@racket[datum] 的语法可由任何能够被 @racket[read] 函数解析为
单个元素的东西所指定。@racket[quote] 形式的值与在向 @racket[read] 给定
@racket[_datum] 时所产生的值相同。

@; The @racket[_datum] can be a symbol, a boolean, a number, a (character
@; or byte) string, a character, a keyword, an empty list, a pair (or
@; list) containing more such values, a vector containing more such
@; values, a hash table containing more such values, or a box containing
@; another such value.


@racket[_datum] 可以是符号、布尔值、数值、（字符或字节）串、字符、关键字、空列表，以及包含更多这类值的序对（或列表）、向量、散列表或盒子。

@examples[
(eval:alts (#,(racketkeywordfont "quote") apple) 'apple)
(eval:alts (#,(racketkeywordfont "quote") #t) #t)
(eval:alts (#,(racketkeywordfont "quote") 42) 42)
(eval:alts (#,(racketkeywordfont "quote") "hello") "hello")
(eval:alts (#,(racketkeywordfont "quote") ()) '())
(eval:alts (#,(racketkeywordfont "quote") ((1 2 3) #2("z" x) . the-end)) '((1 2 3) #2("z" x) . the-end))
(eval:alts (#,(racketkeywordfont "quote") (1 2 #,(racketparenfont ".") (3))) '(1 2 . (3)))
]

@; As the last example above shows, the @racket[_datum] does not have to
@; match the normalized printed form of a value. A @racket[_datum] cannot
@; be a printed representation that starts with @litchar{#<}, so it
@; cannot be @|void-const|, @|undefined-const|, or a procedure.

如上面的最后一个例子所示，@racket[_datum] 不必匹配值的一般化打印形式。
@racket[_datum] 不能是以 @litchar{#<} 开头的打印表示，因此它不能是
@|void-const|、@|undefined-const| 或一个过程。

@; The @racket[quote] form is rarely used for a @racket[_datum] that is a
@; boolean, number, or string by itself, since the printed forms of those
@; values can already be used as constants. The @racket[quote] form is
@; more typically used for symbols and lists, which have other meanings
@; (identifiers, function calls, etc.) when not quoted.

@racket[quote] 很少用于 @racket[_datum] 为布尔值、数值或字符串本身的情况，
因为这些值的打印形式已经被用作常量了。@racket[quote] 形式更常用于符号和列表，
因为它们在未被引述时可以有别的意思（如标识符、函数调用等等）。

@; An expression

表达式

@specform[(quote @#,racketvarfont{datum})]

@; is a shorthand for

是

@racketblock[
(#,(racketkeywordfont "quote") #,(racket _datum))
]

@; and this shorthand is almost always used instead of
@; @racket[quote]. The shorthand applies even within the @racket[_datum],
@; so it can produce a list containing @racket[quote].

的简写形式，我们几乎总是使用该简写而非 @racket[quote]。此简写甚至可以在
@racket[_datum] 中应用，因此它可以处理包含 @racket[quote] 的列表。

@; @refdetails["parse-quote"]{the @racketvalfont{@literal{'}} shorthand}

@refdetails["parse-quote"]{@racketvalfont{@literal{'}} 简写形式}

@examples[
'apple
'"hello"
'(1 2 3)
(display '(you can 'me))
]
