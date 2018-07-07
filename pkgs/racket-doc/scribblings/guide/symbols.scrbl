#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "symbols"]{Symbols}

@title[#:tag "symbols"]{符号}

@; A @deftech{symbol} is an atomic value that prints like an identifier
@; preceded with @litchar{'}.  An expression that starts with @litchar{'}
@; and continues with an identifier produces a symbol value.

@deftech{符号}为原子值，其打印形式类似于一个带有 @litchar{'} 的标识符。
以 @litchar{'} 开头，后跟一个标识符的的表达式会产生一个符号值。

@examples[
'a
(symbol? 'a)
]

@; For any sequence of characters, exactly one corresponding symbol is
@; @defterm{interned}; calling the @racket[string->symbol] procedure, or
@; @racket[read]ing a syntactic identifier, produces an interned
@; symbol. Since interned symbols can be cheaply compared with
@; @racket[eq?] (and thus @racket[eqv?] or @racket[equal?]), they serve
@; as a convenient values to use for tags and enumerations.

对于任何字符序列，都只有一个对应的符号被@defterm{保留}（interned）；
调用过程 @racket[string->symbol] 或通过 @racket[read] 读取语法标识符，
都会产生保留的符号。由于保留符号可简单地通过 @racket[eq?]（@racket[eqv?]
或 @racket[equal?] 亦可）来比较, 因此它们可方便地作为标签和枚举值来使用。

@; Symbols are case-sensitive. By using a @racketfont{#ci} prefix or in
@; other ways, the reader can be made to case-fold character sequences to
@; arrive at a symbol, but the reader preserves case by default.

符号是区分大小写的。通过使用 @racketfont{#ci} 前缀或其它方式，
可以让读取器将字符序列的大小写归一（case-fold）来得到一个符号，
不过读取器默认会保留大小写。

@examples[
(eq? 'a 'a)
(eq? 'a (string->symbol "a"))
(eq? 'a 'b)
(eq? 'a 'A)
(eval:alts @#,elem{@racketfont{#ci}@racketvalfont{@literal{'A}}} #ci'A)
]

@; Any string (i.e., any character sequence) can be supplied to
@; @racket[string->symbol] to obtain the corresponding symbol. For reader
@; input, any character can appear directly in an identifier, except for
@; whitespace and the following special characters:

任何字符串（即任何字符序列）均可通过应用 @racket[string->symbol] 来得到对应的符号。
对于读取器的输入来说，除空白符和以下特殊符号之外，均可直接出现在标识符中：

@t{
  @hspace[2] @litchar{(} @litchar{)} @litchar{[} @litchar{]}
  @litchar["{"] @litchar["}"]
  @litchar{"} @litchar{,} @litchar{'} @litchar{`}
  @litchar{;} @litchar{#} @litchar{|} @litchar{\}
}

@; Actually, @litchar{#} is disallowed only at the beginning of a symbol,
@; and then only if not followed by @litchar{%}; otherwise, @litchar{#} is
@; allowed, too. Also, @litchar{.} by itself is not a symbol.

实际上，@litchar{#} 只是不允许作为符号开头，且不允许紧跟在 @litchar{%} 之后。
其它情况下 @litchar{#} 也可以使用。@litchar{.} 本身并不是一个符号。

@; Whitespace or special characters can be included in an identifier by
@; quoting them with @litchar{|} or @litchar{\}. These quoting
@; mechanisms are used in the printed form of identifiers that contain
@; special characters or that might otherwise look like numbers.

通过 @litchar{|} 或 @litchar{\} 引述的方式，空白符或特殊符号也可被包含在标识符中。
这种引述机制会在标识符的打印形式中包含特殊字符，或看起来像数值时使用。

@examples[
(string->symbol "one, two")
(string->symbol "6")
]

@; @refdetails/gory["parse-symbol"]{the syntax of symbols}

@refdetails/gory["parse-symbol"]{符号语法}

@; The @racket[write] function prints a symbol without a @litchar{'}
@; prefix. The @racket[display] form of a symbol is the same as the
@; corresponding string.

函数 @racket[write] 在打印符号时不会有 @litchar{'} 前缀。符号的 @racket[display]
形式与其对应的字符串相同。

@examples[
(write 'Apple)
(display 'Apple)
(write '|6|)
(display '|6|)
]

@; The @racket[gensym] and @racket[string->uninterned-symbol] procedures
@; generate fresh @defterm{uninterned} symbols that are not equal
@; (according to @racket[eq?]) to any previously interned or uninterned
@; symbol. Uninterned symbols are useful as fresh tags that cannot be
@; confused with any other value.

过程 @racket[gensym] 和 @racket[string->uninterned-symbol]
会生成一个全新的 @defterm{未保留}（uninterned）符号，该符号（按照 @racket[eq?]）
不等于任何前面的已保留或未保留的符号，未保留符号通常用作不会与其它值混淆的全新标签。

@examples[
(define s (gensym))
(eval:alts s 'g42)
(eval:alts (eq? s 'g42) #f)
(eq? 'a (string->uninterned-symbol "a"))
]

@; @refdetails["symbols"]{symbols}

@refdetails["symbols"]{符号}
