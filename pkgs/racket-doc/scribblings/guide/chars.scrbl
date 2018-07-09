#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "characters"]{Characters}

@title[#:tag "characters"]{字符}

@; A Racket @deftech{character} corresponds to a Unicode @defterm{scalar
@; value}. Roughly, a scalar value is an unsigned integer whose
@; representation fits into 21 bits, and that maps to some notion of a
@; natural-language character or piece of a character. Technically, a
@; scalar value is a simpler notion than the concept called a
@; ``character'' in the Unicode standard, but it's an approximation that
@; works well for many purposes. For example, any accented Roman letter
@; can be represented as a scalar value, as can any common Chinese character.

Racket @deftech{字符} 与 Unicode @defterm{标量值}（Scalar Value）相对应。
大致上来来说，标量值就是个可以用 21 个二进制位表示的无符号整数，
只是它被映射到了自然语言字符或字符部分的概念上来。从技术上来说，标量值的概念比
Unicode 标准中名为“字符”概念还要简单，但就很多目的而言，这种近似可以做得相当不错了。
例如，带变音符号的罗马字母可以表示为标量值，任何普通的中文字符也都可以。

@; Although each Racket character corresponds to an integer, the
@; character datatype is separate from numbers. The
@; @racket[char->integer] and @racket[integer->char] procedures convert
@; between scalar-value numbers and the corresponding character.

尽管每个 Racket 字符都对应一个整数，然而字符数据类型却不同于数值类型。
过程 @racket[char->integer] 和 @racket[integer->char]
可用于在标量值和与之对应的字符之间转换。

@; A printable character normally prints as @litchar{#\} followed
@; by the represented character. An unprintable character normally prints
@; as @litchar{#\u} followed by the scalar value as hexadecimal
@; number. A few characters are printed specially; for example, the space
@; and linefeed characters print as @racket[#\space] and
@; @racket[#\newline], respectively.

@; @refdetails/gory["parse-character"]{the syntax of characters}

可打印的字符通常会打印成 @litchar{#\} 后跟该字符的表示。
不可打印的字符通常会打印成 @litchar{#\u} 后跟其十六进制数值形式的标量值。
还有些字符会打印为专有的形式，例如，空格符和换行符会分别打印为
@racket[#\space] 和 @racket[#\newline]。

@refdetails/gory["parse-character"]{字符语法}

@examples[
(integer->char 65)
(char->integer #\A)
#\u03BB
(eval:alts @#,racketvalfont["#\\u03BB"] #\u03BB)
(integer->char 17)
(char->integer #\space)
]

@; The @racket[display] procedure directly writes a character to the
@; current output port (see @secref["i/o"]), in contrast to the
@; character-constant syntax used to print a character result.

与用于打印字符结果的字符常量语法相反，过程 @racket[display]
会直接将字符写到当前的输出端口中（见 @secref["i/o"]）。

@examples[
#\A
(display #\A)
]

@; Racket provides several classification and conversion procedures on
@; characters. Beware, however, that conversions on some Unicode
@; characters work as a human would expect only when they are in a string
@; (e.g., upcasing ``@elem["\uDF"]'' or downcasing ``@elem["\u03A3"]'').

Racket 提供了一些关于字符的分类和转换过程。然而需要注意，某些 Unicode
的转换只有在字符串中时才能按照人们的预期来工作（例如，将 “@elem["\uDF"]”
转为大写，或将 “@elem["\u03A3"]” 转为小写）。

@examples[
(char-alphabetic? #\A)
(char-numeric? #\0)
(char-whitespace? #\newline)
(char-downcase #\A)
(char-upcase #\uDF)
]

@; The @racket[char=?] procedure compares two or more characters, and
@; @racket[char-ci=?] compares characters ignoring case. The
@; @racket[eqv?] and @racket[equal?] procedures behave the same as
@; @racket[char=?] on characters; use @racket[char=?] when you want to
@; more specifically declare that the values being compared are
@; characters.


过程 @racket[char=?] 用于比较两个或更多字符，@racket[char-ci=?]
则用于在忽略大小写的情况下比较字符。过程 @racket[eqv?] 和 @racket[equal?] 的行为与
@racket[char=?] 作用于字符是相同的。如果你想要更加具体地说明要比较的值为字符，
那么请使用 @racket[char=?]。

@examples[
(char=? #\a #\A)
(char-ci=? #\a #\A)
(eqv? #\a #\A)
]

@; @refdetails["characters"]{characters and character procedures}

@refdetails["characters"]{字符与字符过程}
