#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "strings"]{Strings (Unicode)}

@title[#:tag "strings"]{字符串（Unicode）}

@; A @deftech{string} is a fixed-length array of
@; @seclink["characters"]{characters}. It prints using doublequotes,
@; where doublequote and backslash characters within the string are
@; escaped with backslashes. Other common string escapes are supported,
@; including @litchar{\n} for a linefeed, @litchar{\r} for a
@; carriage return, octal escapes using @litchar{\} followed by up
@; to three octal digits, and hexadecimal escapes with @litchar{\u}
@; (up to four digits).  Unprintable characters in a string are normally
@; shown with @litchar{\u} when the string is printed.

@; @refdetails/gory["parse-string"]{the syntax of strings}

@deftech{字符串}就是定长的@seclink["characters"]{字符}数组。它使用双引号打印，
字符串中的双引号和和反斜杠通过反斜杠转义。其它通用的字符串转义也是通用的，包括
换行符 @litchar{\n}、回车符 @litchar{\r}，八进制转义为 @litchar{\}
后跟三个八进制数字，而十六进制转义则为 @litchar{\u} 后跟四个十六进制数字。
字符串中的不可打印字符通常会在打印时显示为 @litchar{\u} 的形式。

@refdetails/gory["parse-string"]{字符串语法}

@; The @racket[display] procedure directly writes the characters of a
@; string to the current output port (see @secref["i/o"]), in contrast
@; to the string-constant syntax used to print a string result.

同用于打印字符串结果的字符串常量语法相反，过程 @racket[display]
直接将字符串中的字符写入到当前的输出端口中（见@secref["i/o"]）。

@examples[
"Apple"
(eval:alts @#,racketvalfont{"\u03BB"} "\u03BB")
(display "Apple")
(display "a \"quoted\" thing")
(display "two\nlines")
(eval:alts (display @#,racketvalfont{"\u03BB"}) (display "\u03BB"))
]

@; A string can be mutable or immutable; strings written directly as
@; expressions are immutable, but most other strings are mutable. The
@; @racket[make-string] procedure creates a mutable string given a length
@; and optional fill character. The @racket[string-ref] procedure
@; accesses a character from a string (with 0-based indexing); the
@; @racket[string-set!]  procedure changes a character in a mutable
@; string.

字符串分为可变的和不可变的两种。直接写成表达式的字符串是不可变的，
而大部分其它字符串都是可变的。过程 @racket[make-string]
根据给定的长度和可选的填充字符来创建可变字符串。过程 @racket[string-ref]
根据从零开始的下标来访问字符串中的字符；过程 @racket[string-set!]
则用于修改可变字符串中的字符。

@examples[
(string-ref "Apple" 0)
(define s (make-string 5 #\.))
s
(string-set! s 2 #\u03BB)
s
]

@; String ordering and case operations are generally
@; @defterm{locale-independent}; that is, they work the same for all
@; users. A few @defterm{locale-dependent} operations are provided that
@; allow the way that strings are case-folded and sorted to depend on the
@; end-user's locale. If you're sorting strings, for example, use
@; @racket[string<?] or @racket[string-ci<?] if the sort result should be
@; consistent across machines and users, but use @racket[string-locale<?]
@; or @racket[string-locale-ci<?] if the sort is purely to order strings
@; for an end user.

字符串的排序和大小写转换操作通常与@defterm{地区无关}，也就是说，
它们对于所有用户的行为均相同。一些@defterm{地区相关}的操作允许字符串根据
最终用户的地区进行大小写归一（case-folding）和排序。例如，若你要排序字符串，
请使用 @racket[string<?]；如果要让排序结果在不同的机器和用户之间保持一致，请使用
@racket[string-ci<?]；但如果只是为最终用户排序字符串，请使用 @racket[string-locale<?]
或 @racket[string-locale-ci<?]。

@examples[
(string<? "apple" "Banana")
(string-ci<? "apple" "Banana")
(string-upcase "Stra\xDFe")
(parameterize ([current-locale "C"])
  (string-locale-upcase "Stra\xDFe"))
]

@; For working with plain ASCII, working with raw bytes, or
@; encoding/decoding Unicode strings as bytes, use
@; @seclink["bytestrings"]{byte strings}.

@; @refdetails["strings"]{strings and string procedures}

要使用 ASCII、原始字节序列或将 Unicode 编码/解码为字节序列，请使用
@seclink["bytestrings"]{字节串}。

@refdetails["strings"]{字符串及其处理}
