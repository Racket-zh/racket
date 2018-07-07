#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "bytestrings"]{Bytes and Byte Strings}

@title[#:tag "bytestrings"]{字节与字节串}

@; A @deftech{byte} is an exact integer between @racket[0] and
@; @racket[255], inclusive. The @racket[byte?] predicate recognizes
@; numbers that represent bytes.

@deftech{字节}是从 @racket[0] 到 @racket[255] 的精确整数。谓语 @racket[byte?]
用于识别表示字节的数值。

@examples[
(byte? 0)
(byte? 256)
]

@; A @deftech{byte string} is similar to a string---see
@; @secref["strings"]---but its content is a sequence of bytes
@; instead of characters. Byte strings can be used in applications that
@; process pure ASCII instead of Unicode text. The printed form of a
@; byte string supports such uses in particular, because a byte string
@; prints like the ASCII decoding of the byte string, but prefixed with a
@; @litchar{#}. Unprintable ASCII characters or non-ASCII bytes in the
@; byte string are written with octal notation.

@; @refdetails/gory["parse-string"]{the syntax of byte strings}

@deftech{字节串}类似于字符串（见@secref["strings"]），不过其内容为字节序列而非字符序列。
字节串可在处理纯 ASCII 而非 Unicode 的应用中使用。字节串的打印形式专门支持这种用法，
因为字节串的打印除了带有 @litchar{#} 前缀外，和字节串的解码一致。不可打印的 ASCII
字符或字节串中的非 ASCII 字节会被写作八进制记法。

@refdetails/gory["parse-string"]{字节串语法}

@examples[
#"Apple"
(bytes-ref #"Apple" 0)
(make-bytes 3 65)
(define b (make-bytes 2 0))
b
(bytes-set! b 0 1)
(bytes-set! b 1 255)
b
]

@; The @racket[display] form of a byte string writes its raw bytes to the
@; current output port (see @secref["i/o"]). Technically,
@; @racket[display] of a normal (i.e,. character) string prints the UTF-8
@; encoding of the string to the current output port, since output is
@; ultimately defined in terms of bytes; @racket[display] of a byte
@; string, however, writes the raw bytes with no encoding. Along the same
@; lines, when this documentation shows output, it technically shows the
@; UTF-8-decoded form of the output.

字节串的 @racket[display] 形式会将其原始字节写入到当前输出端口中（见
@secref["i/o"]）。技术上来说，正常串（即字符串）的 @racket[display] 形式会将
UTF-8 编码的该串打印到当前输出端口中，因为输出是以字节来定义的。然而，@racket[display]
一个字节串写出未经编码的原始字节。按照同样的思路，当本文档显式输出时，
从技术上来说，它显示的输出是 UTF-8 编码的形式。

@; @examples[
@; (display #"Apple")
@; (eval:alts (code:line (display @#,racketvalfont{"\316\273"})  (code:comment @#,t{same as @racket["\316\273"]}))
@;            (display "\316\273"))
@; (code:line (display #"\316\273") (code:comment @#,t{UTF-8 encoding of @elem["\u03BB"]}))
@; ]

@examples[
(display #"Apple")
(eval:alts (code:line (display @#,racketvalfont{"\316\273"})  (code:comment @#,t{与 @racket["\316\273"] 相同}))
           (display "\316\273"))
(code:line (display #"\316\273") (code:comment @#,t{@elem["\u03BB"] 的 UTF-8 编码}))
]

@; For explicitly converting between strings and byte strings, Racket
@; supports three kinds of encodings directly: UTF-8, Latin-1, and the
@; current locale's encoding. General facilities for byte-to-byte
@; conversions (especially to and from UTF-8) fill the gap to support
@; arbitrary string encodings.

为了显式地在字符串和字节串之间转换，Racket 直接支持了三种类型的编码：UTF-8、Latin-1
和当前地区的编码。字节到字节（特是从 UTF-8 和到 UTF-8）转换的通用功能用于填补任意编码之间的空隙。

@; @examples[
@; (bytes->string/utf-8 #"\316\273")
@; (bytes->string/latin-1 #"\316\273")
@; (code:line
@;  (parameterize ([current-locale "C"])  (code:comment @#,elem{C locale supports ASCII,})
@;    (bytes->string/locale #"\316\273")) (code:comment @#,elem{only, so...}))
@; (let ([cvt (bytes-open-converter "cp1253" (code:comment @#,elem{Greek code page})
@;                                  "UTF-8")]
@;       [dest (make-bytes 2)])
@;   (bytes-convert cvt #"\353" 0 1 dest)
@;   (bytes-close-converter cvt)
@;   (bytes->string/utf-8 dest))
@; ]

@examples[
(bytes->string/utf-8 #"\316\273")
(bytes->string/latin-1 #"\316\273")
(code:line
 (parameterize ([current-locale "C"])  (code:comment @#,elem{C 地区只支持 ASCII，})
   (bytes->string/locale #"\316\273")) (code:comment @#,elem{所以...}))
(let ([cvt (bytes-open-converter "cp1253" (code:comment @#,elem{希腊字母代码页})
                                 "UTF-8")]
      [dest (make-bytes 2)])
  (bytes-convert cvt #"\353" 0 1 dest)
  (bytes-close-converter cvt)
  (bytes->string/utf-8 dest))
]

@; @refdetails["bytestrings"]{byte strings and byte-string procedures}

@refdetails["bytestrings"]{字节串及其过程}
