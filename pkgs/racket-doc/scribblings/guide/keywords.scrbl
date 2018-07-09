#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "keywords"]{Keywords}

@title[#:tag "keywords"]{关键字}

@; A @deftech{keyword} value is similar to a symbol (see
@; @secref["symbols"]), but its printed form is prefixed with
@; @litchar{#:}.

@; @refdetails/gory["parse-keyword"]{the syntax of keywords}

@deftech{关键字} 值类似于符号（见@secref["symbols"]），不过其打印形式带有
@litchar{#:} 前缀。

@refdetails/gory["parse-keyword"]{关键字语法}

@examples[
(string->keyword "apple")
'#:apple
(eq? '#:apple (string->keyword "apple"))
]

@; More precisely, a keyword is analogous to an identifier; in the same
@; way that an identifier can be quoted to produce a symbol, a keyword
@; can be quoted to produce a value. The same term ``keyword'' is used in
@; both cases, but we sometimes use @defterm{keyword value} to refer more
@; specifically to the result of a quote-keyword expression or of
@; @racket[string->keyword]. An unquoted keyword is not an expression,
@; just as an unquoted identifier does not produce a symbol:

更确切地说，关键字类似于标识符。标识符可通过引述来产生符号，
而关键字可通过引述来产生值。术语“关键字”会在两种情景下使用，不过有时我们使用
@defterm{关键字值}来更具体地指代引述的关键字表达式的结果或 @racket[string->keyword]
的结果。正如未引述的标识符不会产生符号，未引述的关键字也不是表达式：

@examples[
not-a-symbol-expression
#:not-a-keyword-expression
]

@; Despite their similarities, keywords are used in a different way than
@; identifiers or symbols. Keywords are intended for use (unquoted) as
@; special markers in argument lists and in certain syntactic forms.  For
@; run-time flags and enumerations, use symbols instead of keywords.  The
@; example below illustrates the distinct roles of keywords and symbols.

尽管关键字与标识符或符号很相似，但它们却有着不同的用途。
（未引述的）关键字的目的是在参数列表和具体的语法形式中用作特殊标记。
对于运行时标注（flags）和枚举，请使用符号而非关键字。
下面的例子展示了关键字和符号在用法上的区别。

@; @examples[
@; (code:line (define dir (find-system-path 'temp-dir)) (code:comment @#,t{not @racket['#:temp-dir]}))
@; (with-output-to-file (build-path dir "stuff.txt")
@;   (lambda () (printf "example\n"))
@;   (code:comment @#,t{optional @racket[#:mode] argument can be @racket['text] or @racket['binary]})
@;   #:mode 'text
@;   (code:comment @#,t{optional @racket[#:exists] argument can be @racket['replace], @racket['truncate], ...})
@;   #:exists 'replace)
@; ]

@examples[
(code:line (define dir (find-system-path 'temp-dir)) (code:comment @#,t{而非 @racket['#:temp-dir]}))
(with-output-to-file (build-path dir "stuff.txt")
  (lambda () (printf "example\n"))
  (code:comment @#,t{可选的 @racket[#:mode] 可以是 @racket['text] 或 @racket['binary]})
  #:mode 'text
  (code:comment @#,t{可选的 @racket[#:exists]参数可以是 @racket['replace], @racket['truncate], ...})
  #:exists 'replace)
]

@interaction-eval[(delete-file (build-path (find-system-path 'temp-dir) "stuff.txt"))]
