#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "scheme-forms" #:style 'toc]{Expressions and Definitions}

@title[#:tag "scheme-forms" #:style 'toc]{表达式与定义}

@; The @secref["to-scheme"] chapter introduced some of Racket's syntactic
@; forms: definitions, procedure applications, conditionals, and so
@; on. This section provides more details on those forms, plus a few
@; additional basic forms.

@secref["to-scheme"]一章中介绍了一些 Racket 的语法形式：定义、过程应用、条件等等。
本节中则提供了更多关于这些形式的详情和一些附加的基本形式。

@local-table-of-contents[]

@; @section[#:tag "syntax-notation"]{Notation}

@section[#:tag "syntax-notation"]{记法}

@; This chapter (and the rest of the documentation) uses a slightly
@; different notation than the character-based grammars of the
@; @secref["to-scheme"] chapter. The grammar for a use of a syntactic
@; form @racketkeywordfont{something} is shown like this:

本章（以及本文档的剩余部分）中使用的文法与@secref["to-scheme"]
一章中基于字符的语法稍微有些不同。使用语法形式 @racketkeywordfont{something}
的文法如下：

@specform[(#,(racketkeywordfont "something") [id ...+] an-expr ...)]

@; The italicized meta-variables in this specification, such as
@; @racket[_id] and @racket[_an-expr], use the syntax of Racket
@; identifiers, so @racket[_an-expr] is one meta-variable. A naming
@; convention implicitly defines the meaning of many meta-variables:

在此规范中，斜体的是元变量，使用 Racket 标识符的语法，如 @racket[_id]
和 @racket[_an-expr]。因此 @racket[_an-expr] 是一个元变量。
命名约定隐式地定义了各种元变量的含义：

@itemize[

@;  @item{A meta-variable that ends in @racket[_id] stands for an
@;        identifier, such as @racketidfont{x} or
@;        @racketidfont{my-favorite-martian}.}

@;  @item{A meta-identifier that ends in @racket[_keyword] stands
@;        for a keyword, such as @racket[#:tag].}

@;  @item{A meta-identifier that ends with @racket[_expr] stands for any
@;        sub-form, and it will be parsed as an expression.}

@;  @item{A meta-identifier that ends with @racket[_body] stands for any
@;        sub-form; it will be parsed as either a local definition or an
@;        expression. A @racket[_body] can parse as a definition only if
@;        it is not preceded by any expression, and the last
@;        @racket[_body] must be an expression; see also @secref["intdefs"].}

 @item{以 @racket[_id] 结尾的元变量为标识符，如 @racketidfont{x}
       或 @racketidfont{my-favorite-martian}。}

 @item{以 @racket[_keyword] 结尾的元变量为关键字，如 @racket[#:tag]。}

 @item{以 @racket[_expr] 结尾的元变量为任意子形式，它会被解析为表达式。}

 @item{以 @racket[_body] 结尾的元变量为任意子形式，它会被解析为局部定义或表达式二者其一。
       仅当 @racket[_body] 前面没有任何表达式时，它才会被解析为定义，而最后一个
       @racket[_body] 必定为表达式。另见 @secref["intdefs"]。}

]

@; Square brackets in the grammar indicate a parenthesized sequence of
@; forms, where square brackets are normally used (by convention). That
@; is, square brackets @italic{do not} mean optional parts of the
@; syntactic form.

文法中的方括号表示带括号的形式序列，按照约定，形式序列通常使用方括号来表示。
换句话说，方括号@bold{并不}表示语法形式中可选的部分。

@; A @racketmetafont{...} indicates zero or more repetitions of the
@; preceding form, and @racketmetafont{...+} indicates one or more
@; repetitions of the preceding datum. Otherwise, non-italicized
@; identifiers stand for themselves.

@racketmetafont{...} 表示之前形式的零或多次重复，而 @racketmetafont{...+}
表示之前数据的一到多次重复。其它情况下，非斜体的标识符表示其自身。

@; Based on the above grammar, then, here are a few conforming uses of
@; @racketkeywordfont{something}:

下面是一些遵守以上文法的示例：

@racketblock[
(#,(racketkeywordfont "something") [x])
(#,(racketkeywordfont "something") [x] (+ 1 2))
(#,(racketkeywordfont "something") [x my-favorite-martian x] (+ 1 2) #f)
]

@; Some syntactic-form specifications refer to meta-variables that are
@; not implicitly defined and not previously defined. Such meta-variables
@; are defined after the main form, using a BNF-like format for
@; alternatives:

有些语法形式规范指代了未隐式定义且之前未定义的元变量。这些元变量在主形式之后定义，
使用类 BNF 的格式：

@specform/subs[(#,(racketkeywordfont "something-else") [thing ...+] an-expr ...)
               ([thing thing-id
                       thing-keyword])]

@; The above example says that, within a @racketkeywordfont{something-else}
@; form, a @racket[_thing] is either an identifier or a keyword.

上面的示例表示，在形式 @racketkeywordfont{something-else} 中，@racket[_thing]
为标识符或关键字二者其一。

@;------------------------------------------------------------------------

@include-section["binding.scrbl"]
@include-section["apply.scrbl"]
@include-section["lambda.scrbl"]
@include-section["define.scrbl"]
@include-section["let.scrbl"]
@include-section["cond.scrbl"]
@include-section["begin.scrbl"]
@include-section["set.scrbl"]
@include-section["quote.scrbl"]
@include-section["qq.scrbl"]
@include-section["case.scrbl"]
@include-section["parameterize.scrbl"]
