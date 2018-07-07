#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "numbers"]{Numbers}

@title[#:tag "numbers"]{数值}

@; A Racket @deftech{number} is either exact or inexact:

Racket @deftech{数值} 分为精确和不精确两种：

@itemize[

@;  @item{An @defterm{exact} number is either

@;        @itemize[

@;        @item{an arbitrarily large or small integer, such as @racket[5],
@;              @racket[99999999999999999], or @racket[-17];}

@;        @item{a rational that is exactly the ratio of two arbitrarily
@;              small or large integers, such as @racket[1/2],
@;              @racket[99999999999999999/2], or @racket[-3/4]; or}

@;        @item{a complex number with exact real and imaginary parts
@;              (where the imaginary part is not zero), such as @racket[1+2i] or
@;              @racket[1/2+3/4i].}

@;        ]}

 @item{@defterm{精确}数值包括

       @itemize[

       @item{整数，大小任意。例如 @racket[5]、@racket[99999999999999999] 或
             @racket[-17]；}

       @item{有理数，即两个任意大小整数的比值。例如
             @racket[1/2]、@racket[99999999999999999/2] 或 @racket[-3/4]；}

       @item{复数，带有精确的实部和虚部（其中虚部非零）。例如 @racket[1+2i] 或
             @racket[1/2+3/4i]。}

       ]}

@;  @item{An @defterm{inexact} number is either

@;        @itemize[

@;         @item{an IEEE floating-point representation of a number, such
@;               as @racket[2.0] or @racket[3.14e87], where the IEEE
@;               infinities and not-a-number are written
@;               @racket[+inf.0], @racket[-inf.0], and @racket[+nan.0]
@;               (or @racketvalfont{-nan.0}); or}

@;         @item{a complex number with real and imaginary parts that are
@;               IEEE floating-point representations, such as
@;               @racket[2.0+3.0i] or @racket[-inf.0+nan.0i]; as a
@;               special case, an inexact complex number can have an
@;               exact zero real part with an inexact imaginary part.}

@;         ]}


 @item{@defterm{不精确}数值包括

       @itemize[

        @item{IEEE 浮点表示的数值。例如 @racket[2.0] 或 @racket[3.14e87]，
              其中 IEEE 无穷值和非数值写作 @racket[+inf.0]、@racket[-inf.0] 和
              @racket[+nan.0]（或 @racketvalfont{-nan.0}）；}

        @item{复数，带有 IEEE 浮点表示的实部和虚部。例如 @racket[2.0+3.0i] 或
              @racket[-inf.0+nan.0i]。作为特例，不精确的复数可拥有精确为零的实部
              和不精确的虚部。}

        ]}
]

@; Inexact numbers print with a decimal point or exponent specifier, and
@; exact numbers print as integers and fractions.  The same conventions
@; apply for reading number constants, but @litchar{#e} or
@; @litchar{#i} can prefix a number to force its parsing as an exact
@; or inexact number. The prefixes @litchar{#b}, @litchar{#o}, and
@; @litchar{#x} specify binary, octal, and hexadecimal
@; interpretation of digits.

不精确数值的打印形式带有小数点或指数说明符，而精确数值则打印为整数和分数形式。
同样的约定也适用于读取数值常量，不过数值可通过前缀 @litchar{#e} 或 @litchar{#i}
来分别强制解析为精确或不精确数值。前缀 @litchar{#b}、@litchar{#o} 和 @litchar{#x}
用于指示二进制、八进制和十六进制数字的解释。

@; @refdetails/gory["parse-number"]{the syntax of numbers}

@refdetails/gory["parse-number"]{数值语法}

@examples[
0.5
(eval:alts @#,racketvalfont{#e0.5} 1/2)
(eval:alts @#,racketvalfont{#x03BB} #x03BB)
]

@; Computations that involve an inexact number produce inexact results,
@; so that inexactness acts as a kind of taint on numbers. Beware,
@; however, that Racket offers no ``inexact booleans,'' so computations
@; that branch on the comparison of inexact numbers can nevertheless
@; produce exact results. The procedures @racket[exact->inexact] and
@; @racket[inexact->exact] convert between the two
@; types of numbers.

涉及不精确数值的计算会产生不精确的结果，这种不精确性就像数值上的污点。
然而请注意，Racket 并未提供“不精确的布尔值”，因此对不精确数值进行比较的分支计算
仍然能产生精确的结果。过程 @racket[exact->inexact] 和 @racket[inexact->exact]
可用于在这两种类型的数值间互相转换。

@examples[
(/ 1 2)
(/ 1 2.0)
(if (= 3.0 2.999) 1 2)
(inexact->exact 0.1)
]

@; Inexact results are also produced by procedures such as @racket[sqrt],
@; @racket[log], and @racket[sin] when an exact result would require
@; representing real numbers that are not rational. Racket can represent
@; only rational numbers and complex numbers with rational parts.

当试图将 @racket[sqrt]、@racket[log] 和 @racket[sin]
之类的过程产生的结果精确表示为非有理数的实数（即无理数、无穷值和非数值）时，
就会产生不精确的结果。Racket 只能将有理部分的结果表示为有理数和复数。

@examples[
(code:line (sin 0)   (code:comment @#,t{rational...}))
(code:line (sin 1/2) (code:comment @#,t{not rational...}))
]

@; In terms of performance, computations with small integers are
@; typically the fastest, where ``small'' means that the number fits into
@; one bit less than the machine's word-sized representation for signed
@; numbers. Computation with very large exact integers or with
@; non-integer exact numbers can be much more expensive than computation
@; with inexact numbers.

在性能方面，用小整数进行计算是最快的。此处“小”的程度指该数值的位长比机器
按字大小（word-sized）来表示带符号整数的位长少一位。用非常大的精确整数
或非整数进行计算的代价要比用非精确数的代价更高。

@def+int[
(define (sigma f a b)
  (if (= a b)
      0
      (+ (f a) (sigma f (+ a 1) b))))

(time (round (sigma (lambda (x) (/ 1 x)) 1 2000)))
(time (round (sigma (lambda (x) (/ 1.0 x)) 1 2000)))
]

@; The number categories @deftech{integer}, @deftech{rational},
@; @deftech{real} (always rational), and @deftech{complex} are defined in
@; the usual way, and are recognized by the procedures @racket[integer?],
@; @racket[rational?], @racket[real?], and @racket[complex?], in addition
@; to the generic @racket[number?]. A few mathematical procedures accept
@; only real numbers, but most implement standard extensions to complex
@; numbers.

数值的分类按通常的方式定义为@deftech{整数}、@deftech{有理数}、@deftech{实数}
（总是有理数）和@deftech{复数}，它们可使用过程
@racket[integer?]、@racket[rational?]、@racket[real?] 和 @racket[complex?]
以及一个通用的 @racket[number?] 来识别。有些数学过程只接受实数，
不过大部分都为复数实现了标准扩展。

@examples[
(integer? 5)
(complex? 5)
(integer? 5.0)
(integer? 1+2i)
(complex? 1+2i)
(complex? 1.0+2.0i)
(abs -5)
(abs -5+2i)
(sin -5+2i)
]

@; The @racket[=] procedure compares numbers for numerical equality. If
@; it is given both inexact and exact numbers to compare, it essentially
@; converts the inexact numbers to exact before comparing. The
@; @racket[eqv?] (and therefore @racket[equal?]) procedure, in contrast,
@; compares numbers considering both exactness and numerical equality.


过程 @racket[=] 用于比较数字的数值相等性。如果给定了不精确和精确的数进行比较，
它实际上会在比较前将不精确数转换为精确数。而 @racket[eqv?]（以及 @racket[equal?]）
则会在比较数值时同时考虑精确性和数值相等性。

@examples[
(= 1 1.0)
(eqv? 1 1.0)
]

@; Beware of comparisons involving inexact numbers, which by their nature
@; can have surprising behavior. Even apparently simple inexact numbers
@; may not mean what you think they mean; for example, while a base-2
@; IEEE floating-point number can represent @racket[1/2] exactly, it
@; can only approximate @racket[1/10]:

请注意涉及不精确数值的比较，根据它们的性质可能会有意料之外的行为。
即便显然很简单的不精确数值，其意思也可能与你所想的不同。例如，以 2 为底的
IEEE 可以精确地表示 @racket[1/2]，但却只能近似地表示 @racket[1/10]：

@examples[
(= 1/2 0.5)
(= 1/10 0.1)
(inexact->exact 0.1)
]

@; @refdetails["numbers"]{numbers and number procedures}

@refdetails["numbers"]{数值与数值过程}
