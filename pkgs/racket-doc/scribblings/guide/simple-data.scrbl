#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title{Simple Values}

@title{简单的值}

@; Racket values include numbers, booleans, strings, and byte strings. In
@; DrRacket and documentation examples (when you read the documentation
@; in color), value expressions are shown in green.

Racket 值包括数值、布尔值、字符串和字节串（Byte Strings）。在 DrRacket
和文档示例中（当你在着色状态下阅读文档时），值表达式以绿色显示。

@; @defterm{Numbers} are written in the usual way, including fractions
@; and imaginary numbers:

@; @moreguide["numbers"]{numbers}

@defterm{数值}以通常的方式书写，包括分数和虚数：

@moreguide["numbers"]{数值}

@racketblock[
1       3.14
1/2     6.02e+23
1+2i    9999999999999999999999
]

@; @defterm{Booleans} are @racket[#t] for true and @racket[#f] for
@; false. In conditionals, however, all non-@racket[#f] values are
@; treated as true.

@; @moreguide["booleans"]{booleans}

@defterm{布尔值}用@racket[#t]表示真，用@racket[#f]表示假。
然而在条件表达式（Conditionals）中，所有非@racket[#f]的值均被视为真。

@moreguide["booleans"]{布尔值}

@; @defterm{Strings} are written between doublequotes. Within a string,
@; backslash is an escaping character; for example, a backslash followed
@; by a doublequote includes a literal doublequote in the string. Except
@; for an unescaped doublequote or backslash, any Unicode character can
@; appear in a string constant.

@; @moreguide["strings"]{strings}

@defterm{字符串}写在双引号 @racket[""] 之间。字符串中以反斜杠 @racket[\]
作为转义字符。例如，字符串中的一个反斜杠后跟一个双引号 @racket["\""]
即表示双引号字面量（Literals）。除未转义的双引号和反斜杠外，任何 Unicode
字符均可出现在字符串常量中。

@moreguide["strings"]{字符串}

@racketblock[
"Hello, world!"
"Benjamin \"Bugsy\" Siegel"
"\u03BBx:(\u03BC\u03B1.\u03B1\u2192\u03B1).xx"
]

@; When a constant is evaluated in the @tech{REPL}, it typically prints the same
@; as its input syntax. In some cases, the printed form is a normalized
@; version of the input syntax. In documentation and in DrRacket's @tech{REPL},
@; results are printed in blue instead of green to highlight the
@; difference between an input expression and a printed result.

当常量在 @tech{REPL} 中求值时，其打印的结果通常与输入的语法相同。
在某些情况下，打印的形式为输入语法的规范化版本。在文档 和 DrRacket 的
@tech{REPL} 中，求值结果以蓝色而非绿色来打印，以便突出输入的表达式与打印结果之间的不同。

@examples[
(eval:alts (unsyntax (racketvalfont "1.0000")) 1.0000)
(eval:alts (unsyntax (racketvalfont "\"Bugs \\u0022Figaro\\u0022 Bunny\"")) "Bugs \u0022Figaro\u0022 Bunny")
]
