#lang scribble/doc
@(require scribble/manual scribble/eval scribble/bnf "guide-utils.rkt")

@(define ex-eval (make-base-eval))

@; @title[#:tag "syntax-overview"]{Simple Definitions and Expressions}

@title[#:tag "syntax-overview"]{简单的定义与表达式}

@; A program module is written as

程序模块的形式为：

@racketblock[
@#,BNF-seq[@litchar{#lang} @nonterm{langname} @kleenestar{@nonterm{topform}}]
]

@; where a @nonterm{topform} is either a @nonterm{definition} or an
@; @nonterm{expr}. The @tech{REPL} also evaluates @nonterm{topform}s.

其中 @nonterm{topform} 为 @nonterm{definition} 或 @nonterm{expr} 二者之一。@tech{REPL}
也会对 @nonterm{topform} 进行求值。

@; In syntax specifications, text with a gray background, such as
@; @litchar{#lang}, represents literal text. Whitespace must appear
@; between such literals and nonterminals like @nonterm{id},
@; except that whitespace is not required before or after @litchar{(},
@; @litchar{)}, @litchar{[}, or @litchar{]}.  A @index['("comments")]{comment}, which starts
@; with @litchar{;} and runs until the end of the line, is treated the
@; same as whitespace.

@; @refdetails["parse-comment"]{different forms of comments}

在语法规范中，灰色背景的文本（如 @litchar{#lang}）表示文本字面量。
文本字面量和 @nonterm{id} 之类的非终止符（Nonterminals）之间必须有空格；
在 @litchar{(}、@litchar{)}、@litchar{[} 或 @litchar{]} 的前后则不必有空格。

@refdetails["parse-comment"]{注释的不同形式}

@; Following the usual conventions, @kleenestar{} in a grammar means zero
@; or more repetitions of the preceding element, @kleeneplus{} means one
@; or more repetitions of the preceding element, and @BNF-group{} groups
@; a sequence as an element for repetition.

按照约定，文法中的 @kleenestar{} 表示前一元素的零次或多次重复，@kleeneplus{}
表示前一元素的一次或多次重复，而 @BNF-group{} 则对一个序列进行分组，以作为一个元素用于重复。

@(define val-defn-stx
   @BNF-seq[@litchar{(}@litchar{define} @nonterm{id} @nonterm{expr} @litchar{)}])
@(define fun-defn-stx
   @BNF-seq[@litchar{(}@litchar{define} @litchar{(} @nonterm{id} @kleenestar{@nonterm{id}} @litchar{)}
                  @kleeneplus{@nonterm{expr}} @litchar{)}])
@(define fun-defn2-stx
   @BNF-seq[@litchar{(}@litchar{define} @litchar{(} @nonterm{id} @kleenestar{@nonterm{id}} @litchar{)}
            @kleenestar{@nonterm{definition}} @kleeneplus{@nonterm{expr}} @litchar{)}])
@(define app-expr-stx @BNF-seq[@litchar{(} @nonterm{id} @kleenestar{@nonterm{expr}} @litchar{)}])
@(define app2-expr-stx @BNF-seq[@litchar{(} @nonterm{expr} @kleenestar{@nonterm{expr}} @litchar{)}])
@(define if-expr-stx @BNF-seq[@litchar{(} @litchar{if} @nonterm{expr} @nonterm{expr} @nonterm{expr} @litchar{)}])

@(define lambda-expr-stx @BNF-seq[@litchar{(} @litchar{lambda} @litchar{(} @kleenestar{@nonterm{id}} @litchar{)}
                                              @kleeneplus{@nonterm{expr}} @litchar{)}])
@(define lambda2-expr-stx
   @BNF-seq[@litchar{(} @litchar{lambda} @litchar{(} @kleenestar{@nonterm{id}} @litchar{)}
            @kleenestar{@nonterm{definition}} @kleeneplus{@nonterm{expr}} @litchar{)}])
@(define and-expr-stx @BNF-seq[@litchar{(} @litchar{and} @kleenestar{@nonterm{expr}} @litchar{)}])
@(define or-expr-stx @BNF-seq[@litchar{(} @litchar{or} @kleenestar{@nonterm{expr}} @litchar{)}])
@(define cond-expr-stx @BNF-seq[@litchar{(} @litchar{cond}
                                @kleenestar{@BNF-group[@litchar{[} @nonterm{expr} @kleenestar{@nonterm{expr}} @litchar{]}]}
                                @litchar{)}])
@(define (make-let-expr-stx kw)
   @BNF-seq[@litchar{(} kw @litchar{(}
            @kleenestar{@BNF-group[@litchar{[} @nonterm{id} @nonterm{expr} @litchar{]}]}
            @litchar{)}
            @kleeneplus{@nonterm{expr}} @litchar{)}])
@(define let-expr-stx (make-let-expr-stx @litchar{let}))
@(define let*-expr-stx (make-let-expr-stx @litchar{let*}))

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section{Definitions}

@section{定义}

@; A definition of the form

@; @moreguide["define"]{definitions}

定义（Definition）的形式为：

@moreguide["define"]{定义}

@racketblock[@#,val-defn-stx]

它将 @nonterm{id} 绑定到 @nonterm{expr} 的结果上。而

@racketblock[@#,fun-defn-stx]

@; binds the first @nonterm{id} to a function (also called a
@; @defterm{procedure}) that takes arguments as named by the remaining
@; @nonterm{id}s. In the function case, the @nonterm{expr}s are the body
@; of the function. When the function is called, it returns the result of
@; the last @nonterm{expr}.

则将第一个 @nonterm{id} 绑定到一个函数（亦称为@defterm{过程}）上，该函数接受以其余
@nonterm{id} 为名的参数。对于这种函数的情况，@nonterm{expr} 即为其函数体。
当该函数被调用时，它返回最后一个 @nonterm{expr} 的结果。

@; @defexamples[
@; #:eval ex-eval
@; (code:line (define pie 3)             (code:comment @#,t{defines @racket[pie] to be @racket[3]}))
@; (code:line (define (piece str)        (code:comment @#,t{defines @racket[piece] as a function})
@;              (substring str 0 pie))   (code:comment @#,t{ of one argument}))
@; pie
@; (piece "key lime")
@; ]

@defexamples[
#:eval ex-eval
(code:line (define pie 3)             (code:comment @#,t{将 @racket[pie] 定义为 @racket[3]}))
(code:line (define (piece str)        (code:comment @#,t{将 @racket[piece] 定义为})
             (substring str 0 pie))   (code:comment @#,t{接受一个参数的函数}))
pie
(piece "key lime")
]

@; Under the hood, a function definition is really the same as a
@; non-function definition, and a function name does not have to be
@; used in a function call. A function is just another kind of value,
@; though the printed form is necessarily less complete than the printed
@; form of a number or string.

在底层，函数定义与非函数定义其实是相同的。而在函数调用中，函数名也不是必需的。
函数只是另一种值，虽然其打印的形式肯定没有数值或字符串那么完整。

@examples[
#:eval ex-eval
piece
substring
]

@; A function definition can include multiple expressions for the
@; function's body. In that case, only the value of the last expression
@; is returned when the function is called. The other expressions are
@; evaluated only for some side-effect, such as printing.

函数定义的函数体中可包含多个表达式。在此情况下，当该函数被调用时，
只有最后一个表达式的值会被返回。其它表达式的求值仅用于某些副作用
（side-effect），例如打印等。

@defexamples[
#:eval ex-eval
(define (bake flavor)
  (printf "preheating oven...\n")
  (string-append flavor " pie"))
(bake "apple")
]

@; Racket programmers prefer to avoid side-effects, so a definition usually
@; has just one expression in its body. It's
@; important, though, to understand that multiple expressions are allowed
@; in a definition body, because it explains why the following
@; @racket[nobake] function fails to include its argument in its result:

Racket 程序员更倾向于避免副作用，因此定义体（Definition Body）中通常只有一个表达式。
不过，了解定义体中允许多个表达式也很重要，因为它解释了下面的 @racket[nobake]
函数在将其参数包含在结果中时为何会失败：

@def+int[
#:eval ex-eval
(define (nobake flavor)
  string-append flavor "jello")
(nobake "green")
]

@; Within @racket[nobake], there are no parentheses around
@; @racket[string-append flavor "jello"], so they are three separate
@; expressions instead of one function-call expression. The expressions
@; @racket[string-append] and @racket[flavor] are evaluated, but the
@; results are never used. Instead, the result of the function is just
@; the result of the final expression, @racket["jello"].


在 @racket[nobake] 中，@racket[string-append flavor "jello"] 没有被括号括住，
因此该函数体中有三个独立的表达式，而非只有一个函数调用表达式。虽然表达式
@racket[string-append] 和 @racket[flavor] 会被求值，但它们的结果永远不会被使用。
而该函数的结果只不过是最后一个表达式的结果，即 @racket["jello"]。

@; ----------------------------------------------------------------------
@; @section[#:tag "indentation"]{An Aside on Indenting Code}

@section[#:tag "indentation"]{关于代码缩进的提示}

@; Line breaks and indentation are not significant for parsing Racket
@; programs, but most Racket programmers use a standard set of conventions
@; to make code more readable. For example, the body of a definition is
@; typically indented under the first line of the definition. Identifiers
@; are written immediately after an open parenthesis with no extra space,
@; and closing parentheses never go on their own line.

换行和缩进对于 Racket 程序的解析来说并不重要，不过大部分 Racket
程序员都会使用一套标准的约定来提高代码可读性。例如，定义体通常在该定义的第一行下方开始缩进。
标识符（Identifiers）通常紧跟在开括号之后，中间没有额外的空格，而闭括号则从不独占一行。

@; DrRacket automatically indents according to the standard style when
@; you type Enter in a program or @tech{REPL} expression. For example, if you
@; hit Enter after typing @litchar{(define (greet name)}, then DrRacket
@; automatically inserts two spaces for the next line.  If you change a
@; region of code, you can select it in DrRacket and hit Tab, and
@; DrRacket will re-indent the code (without inserting any line breaks).
@; Editors like Emacs offer a Racket or Scheme mode with similar indentation
@; support.

当你在程序或 @tech{REPL} 中敲 Enter 键时，DrRacket 会按照标准风格自动缩进。
例如，如果你在键入 @litchar{(define (greet name)} 后敲 Enter 键，那么 DrRacket
会自动为下一行插入两个空格。如果你要更改一片区域内的代码，可以在 DrRacket
中选中它们后敲 Tab 键，DrRacket 会重新缩进这片代码（但不会插入任何换行）。
Emacs 这类的编辑器提供了 Racket 或 Scheme 模式，它们支持类似的缩进方式。

@; Re-indenting not only makes the code easier to read, it gives you
@; extra feedback that your parentheses match in the way that you
@; intended. For example, if you leave out a closing parenthesis after
@; the last argument to a function, automatic indentation starts the
@; next line under the first argument, instead of under the
@; @racket[define] keyword:

重新缩进不仅能让你的代码更加易读，它还能提供额外的反馈，例如括号是否按预期匹配。
例如，如果你在函数的最后一个参数之后遗漏了一个闭括号括号，
那么自动缩进会在第一个参数的正下方开始下一行，而不会在 @racket[define] 关键字下开始：

@racketblock[
(define (halfbake flavor
                  (string-append flavor " creme brulee")))
]

@; In this case, indentation helps highlight the mistake. In other cases,
@; where the indentation may be normal while an open parenthesis has no
@; matching close parenthesis, both @exec{racket} and DrRacket use the
@; source's indentation to suggest where a parenthesis might be missing.

在这种情况下，缩进有助于突出错误。在其它情况下，当一个开括号没有匹配的闭括号时，
缩进的地方可能是正常的，@exec{racket} 和 DrRacket 会使用源码的缩进来提示可能缺少括号的地方。

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section{Identifiers}

@section{标识符}

@; Racket's syntax for identifiers is especially liberal. Excluding the
@; special characters

@; @moreguide["binding"]{identifiers}

Racket 标识符的语法相当自由。除特殊字符

@t{
  @hspace[2] @litchar{(} @litchar{)} @litchar{[} @litchar{]}
  @litchar["{"] @litchar["}"]
  @litchar{"} @litchar{,} @litchar{'} @litchar{`}
  @litchar{;} @litchar{#} @litchar{|} @litchar{\}
}

@; and except for the sequences of characters that make number constants,
@; almost any sequence of non-whitespace characters forms an
@; @nonterm{id}. For example @racketid[substring] is an
@; identifier. Also, @racketid[string-append] and @racketid[a+b] are
@; identifiers, as opposed to arithmetic expressions. Here are several
@; more examples:

和构成数值常量的字符序列外，几乎任何非空白字符序列都能构成 @nonterm{id}。
例如 @racketid[substring] 就是个标识符。@racketid[string-append] 和
@racketid[a+b] 也是标识符，而非算术表达式。下面还有一些示例：

@racketblock[
@#,racketid[+]
@#,racketid[Hfuhruhurr]
@#,racketid[integer?]
@#,racketid[pass/fail]
@#,racketid[john-jacob-jingleheimer-schmidt]
@#,racketid[a-b-c+1-2-3]
]

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section{Function Calls@aux-elem{ (Procedure Applications)}}

@section{函数调用@aux-elem{（过程应用）}}

@; We have already seen many function calls, which are called
@; @defterm{procedure applications} in more traditional
@; terminology. The syntax of a function call is

@; @moreguide["application"]{function calls}

我们已经见过一些函数调用了，更传统的术语称之为@defterm{过程应用}。函数调用的语法为：

@moreguide["application"]{函数调用}

@racketblock[
#,app-expr-stx
]

@; where the number of @nonterm{expr}s determines the number of
@; arguments supplied to the function named by @nonterm{id}.

其中 @nonterm{expr} 的数量决定了提供给名为 @nonterm{id} 的函数的参数个数。

@; The @racketmodname[racket] language pre-defines many function
@; identifiers, such as @racket[substring] and
@; @racket[string-append]. More examples are below.

@racketmodname[racket] 语言预定义了很多函数标识符，例如 @racket[substring]
和 @racket[string-append]。更多示例见下。

@; In example Racket code throughout the documentation, uses of
@; pre-defined names are hyperlinked to the reference manual. So, you can
@; click on an identifier to get full details about its use.

Racket 示例代码贯穿了整个文档，其中用到的预定义名被超链接到了参考手册（Reference Manual）。
因此，你可以点击标识符来获取关于其用法的完整详情。

@; @interaction[
@; (code:line (string-append "rope" "twine" "yarn")  (code:comment @#,t{append strings}))
@; (code:line (substring "corduroys" 0 4)            (code:comment @#,t{extract a substring}))
@; (code:line (string-length "shoelace")             (code:comment @#,t{get a string's length}))
@; (code:line (string? "Ceci n'est pas une string.") (code:comment @#,t{recognize strings}))
@; (string? 1)
@; (code:line (sqrt 16)                              (code:comment @#,t{find a square root}))
@; (sqrt -16)
@; (code:line (+ 1 2)                                (code:comment @#,t{add numbers}))
@; (code:line (- 2 1)                                (code:comment @#,t{subtract numbers}))
@; (code:line (< 2 1)                                (code:comment @#,t{compare numbers}))
@; (>= 2 1)
@; (code:line (number? "c'est une number")           (code:comment @#,t{recognize numbers}))
@; (number? 1)
@; (code:line (equal? 6 "half dozen")                (code:comment @#,t{compare anything}))
@; (equal? 6 6)
@; (equal? "half dozen" "half dozen")
@; ]

@interaction[
(code:line (string-append "rope" "twine" "yarn")  (code:comment @#,t{连接字符串}))
(code:line (substring "corduroys" 0 4)            (code:comment @#,t{提取子字符串}))
(code:line (string-length "shoelace")             (code:comment @#,t{获取字符串长度}))
(code:line (string? "Ceci n'est pas une string.") (code:comment @#,t{识别字符串}))
(string? 1)
(code:line (sqrt 16)                              (code:comment @#,t{查找平方根}))
(sqrt -16)
(code:line (+ 1 2)                                (code:comment @#,t{数值相加}))
(code:line (- 2 1)                                (code:comment @#,t{数值相减}))
(code:line (< 2 1)                                (code:comment @#,t{数值比较}))
(>= 2 1)
(code:line (number? "c'est une number")           (code:comment @#,t{识别数字}))
(number? 1)
(code:line (equal? 6 "half dozen")                (code:comment @#,t{比较相等性}))
(equal? 6 6)
(equal? "half dozen" "half dozen")
]

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section{Conditionals with @racket[if], @racket[and], @racket[or], and @racket[cond]}

@section{条件分支与 @racket[if]、@racket[and]、@racket[or] 和 @racket[cond]}

@; The next simplest kind of expression is an @racket[if] conditional:

下一种最简单的表达式为 @racket[if] 条件分支：

@racketblock[
#,if-expr-stx
]

@; @moreguide["conditionals"]{conditionals}

@moreguide["conditionals"]{条件分支}

@; The first @nonterm{expr} is always evaluated. If it produces a
@; non-@racket[#f] value, then the second @nonterm{expr} is
@; evaluated for the result of the whole @racket[if] expression, otherwise
@; the third @nonterm{expr} is evaluated for the result.

第一个 @nonterm{expr} 总是会被求值。如果它产生了非 @racket[#f] 的值，那么第二个
@nonterm{expr} 即求值为整个 @racket[if] 表达式的结果；否则，第三个
@nonterm{expr} 即求值为整个表达式的结果。

@examples[
(if (> 2 3)
    "bigger"
    "smaller")
]

@def+int[
(define (reply s)
  (if (equal? "hello" (substring s 0 5))
      "hi!"
      "huh?"))
(reply "hello racket")
(reply "\u03BBx:(\u03BC\u03B1.\u03B1\u2192\u03B1).xx")
]

@; Complex conditionals can be formed by nesting @racket[if]
@; expressions. For example, you could make the @racket[reply] function
@; work when given non-strings:

复杂的条件分支可通过嵌条 @racket[if] 表达式构成。例如，你可以让 @racket[reply]
函数在收到非字符串时仍然能够工作：

@racketblock[
(define (reply s)
  (if (string? s)
      (if (equal? "hello" (substring s 0 5))
          "hi!"
          "huh?")
      "huh?"))
]

@; Instead of duplicating the @racket["huh?"] case, this function is
@; better written as

我们不必重复 @racket["huh?"] 的情况，因为此函数可写成更好的形式：

@racketblock[
(define (reply s)
  (if (if (string? s)
          (equal? "hello" (substring s 0 5))
          #f)
      "hi!"
      "huh?"))
]

@; but these kinds of nested @racket[if]s are difficult to read.  Racket
@; provides more readable shortcuts through the @racket[and] and
@; @racket[or] forms, which work with any number of expressions:

@; @moreguide["and+or"]{@racket[and] and @racket[or]}

然而这种嵌套的 @racket[if] 却难以阅读。Racket 通过 @racket[and] 和 @racket[or]
的形式提供了更加可读的简写，它们可以配合任意数量的表达式使用：

@moreguide["and+or"]{@racket[and] 和 @racket[or]}

@racketblock[
#,and-expr-stx
#,or-expr-stx
]

@; The @racket[and] form short-circuits: it stops and returns @racket[#f]
@; when an expression produces @racket[#f], otherwise it keeps
@; going. The @racket[or] form similarly short-circuits when it
@; encounters a true result.

@racket[and] 形式遵循短路（short-circuits）求值：当表达式产生了 @racket[#f]
时，它会停止并返回 @racket[#f]，否则会继续求值。@racket[or]
形式在遇到求值为真的结果时同样会短路。

@defexamples[
(define (reply s)
  (if (and (string? s)
           (>= (string-length s) 5)
           (equal? "hello" (substring s 0 5)))
      "hi!"
      "huh?"))
(reply "hello racket")
(reply 17)
]

@; Another common pattern of nested @racket[if]s involves a sequence of
@; tests, each with its own result:

另一种嵌套 @racket[if] 的通用模式是调用一系列测试，其中每个测试都有自己的结果：

@racketblock[
(define (reply-more s)
  (if (equal? "hello" (substring s 0 5))
      "hi!"
      (if (equal? "goodbye" (substring s 0 7))
          "bye!"
          (if (equal? "?" (substring s (- (string-length s) 1)))
              "I don't know"
              "huh?"))))
]

@; The shorthand for a sequence of tests is the @racket[cond] form:

这种一系列测试的简写为 @racket[cond] 形式：

@moreguide["cond"]{@racket[cond]}

@racketblock[
#,cond-expr-stx
]

@; A @racket[cond] form contains a sequence of clauses between square
@; brackets. In each clause, the first @nonterm{expr} is a test
@; expression. If it produces true, then the clause's remaining
@; @nonterm{expr}s are evaluated, and the last one in the clause provides
@; the answer for the entire @racket[cond] expression; the rest of the
@; clauses are ignored. If the test @nonterm{expr} produces @racket[#f],
@; then the clause's remaining @nonterm{expr}s are ignored, and
@; evaluation continues with the next clause. The last clause can use
@; @racket[else] as a synonym for a @racket[#t] test expression.

@racket[cond] 形式在方括号中包含了一系列从句。每个从句的第一个 @nonterm{expr}
均为测试表达式。如果它产生真，那么该从句中剩余的 @nonterm{expr} 就会被求值，
而该从句中最后一个表达式的结果即为整个 @racket[cond] 表达式的结果；其余的从句则会被忽略。
如果测试 @nonterm{expr} 产生了 @racket[#f]，那么该从句中剩余的 @nonterm{expr} 就会被忽略，
而求值会继续执行下一个从句。最后一个从句可使用 @racket[else] 作为求值为 @racket[#t]
的测试表达式的别名。

@; Using @racket[cond], the @racket[reply-more] function can be more
@; clearly written as follows:

使用 @racket[cond] 表达式，@racket[reply-more] 函数的写法可以更加清晰：

@def+int[
(define (reply-more s)
  (cond
   [(equal? "hello" (substring s 0 5))
    "hi!"]
   [(equal? "goodbye" (substring s 0 7))
    "bye!"]
   [(equal? "?" (substring s (- (string-length s) 1)))
    "I don't know"]
   [else "huh?"]))
(reply-more "hello racket")
(reply-more "goodbye cruel world")
(reply-more "what is your favorite color?")
(reply-more "mine is lime green")
]

@; The use of square brackets for @racket[cond] clauses is a
@; convention. In Racket, parentheses and square brackets are actually
@; interchangeable, as long as @litchar{(} is matched with @litchar{)} and
@; @litchar{[} is matched with @litchar{]}. Using square brackets in a
@; few key places makes Racket code even more readable.

在 @racket[cond] 从句中使用方括号是一种约定。在 Racket 中，圆括号和方括号其实是可以互换的，
只要 @litchar{(} 与 @litchar{)} 匹配，@litchar{[} 与 @litchar{]}匹配即可。
在一些关键的地方使用方括号可以让 Racket 代码更加易读。

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section{Function Calls, Again}

@section{再谈函数调用}

@; In our earlier grammar of function calls, we oversimplified.  The
@; actual syntax of a function call allows an arbitrary
@; expression for the function, instead of just an @nonterm{id}:

@; @moreguide["application"]{function calls}

之前我们过度简化了函数调用的语法。函数调用的实际语法允许任意表达式，而不只有
@nonterm{id}：

@moreguide["application"]{函数调用}

@racketblock[
#,app2-expr-stx
]

@; The first @nonterm{expr} is often an @nonterm{id}, such
@; as @racket[string-append] or @racket[+], but it can be anything that
@; evaluates to a function. For example, it can be a conditional
@; expression:

第一个 @nonterm{expr} 通常为 @nonterm{id}，例如 @racket[string-append] 或
@racket[+]，不过它可以是任何求值为函数的东西。例如，它可以是条件表达式：

@def+int[
(define (double v)
  ((if (string? v) string-append +) v v))
(double "mnah")
(double 5)
]

@; Syntactically, the first expression in a function call could
@; even be a number---but that leads to an error, since a number is not a
@; function.

单从语法上来说，函数调用中的第一个表达式甚至可以是数字---不过这会产生错误，
因为数字并不是一个函数。

@interaction[(1 2 3 4)]

@; When you accidentally omit a function name or when you use
@; extra parentheses around an expression, you'll most often get an ``expected
@; a procedure'' error like this one.

如果你不小心忽略了函数名，或者在表达式外使用了额外的括号，那么你通常就会得到这种
“expected a procedure（需要一个过程）”的错误。

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section{Anonymous Functions with @racket[lambda]}

@section{匿名函数与 @racket[lambda]}

@; Programming in Racket would be tedious if you had to name all of your
@; numbers. Instead of writing @racket[(+ 1 2)], you'd have to write

@; @moreguide["lambda"]{@racket[lambda]}

如果你必须命名所有的数值，那么用 Racket 编程就太过无聊了。
如果你不用 @racket[(+ 1 2)]，那么必须这样写：

@moreguide["lambda"]{@racket[lambda]}

@interaction[
(define a 1)
(define b 2)
(+ a b)
]

@; It turns out that having to name all your functions can be tedious,
@; too. For example, you might have a function @racket[twice] that takes
@; a function and an argument. Using @racket[twice] is convenient if you
@; already have a name for the function, such as @racket[sqrt]:

事实证明，命名所有的函数同样也很无聊。例如，你有个函数 @racket[twice]，
它接受另一个函数作为参数。如果作为参数的函数已经有了名字（如 @racket[sqrt]），
那么使用 @racket[twice] 会很方便：

@def+int[
#:eval ex-eval
(define (twice f v)
  (f (f v)))
(twice sqrt 16)
]

@; If you want to call a function that is not yet defined, you could
@; define it, and then pass it to @racket[twice]:

如果你想要调用一个尚未定义的函数，那么必须先定义它才能传入
@racket[twice] 中：

@def+int[
#:eval ex-eval
(define (louder s)
  (string-append s "!"))
(twice louder "hello")
]

@; But if the call to @racket[twice] is the only place where
@; @racket[louder] is used, it's a shame to have to write a whole
@; definition. In Racket, you can use a @racket[lambda] expression to
@; produce a function directly. The @racket[lambda] form is followed by
@; identifiers for the function's arguments, and then the function's
@; body expressions:

但如果对 @racket[twice] 的调用是唯一使用 @racket[louder] 的地方，
那么完全没必要写下它的完整定义。在 Racket 中，你可以用 @racket[lambda]
表达式来直接产生一个函数。@racket[lambda] 形式后面紧跟着函数参数的标识符，
之后是函数体表达式：

@racketblock[
#,lambda-expr-stx
]

@; Evaluating a @racket[lambda] form by itself produces a function:

对 @racket[lambda] 形式自身进行求值会产生一个函数：

@interaction[(lambda (s) (string-append s "!"))]

@; Using @racket[lambda], the above call to @racket[twice] can be
@; re-written as

上面对 @racket[twice] 的调用可通过 @racket[lambda] 重写为：

@interaction[
#:eval ex-eval
(twice (lambda (s) (string-append s "!"))
       "hello")
(twice (lambda (s) (string-append s "?!"))
       "hello")
]

Another use of @racket[lambda] is as a result for a function that
generates functions:

@racket[lambda] 还可用于构造出生成函数作为结果的函数：

@def+int[
#:eval ex-eval
(define (make-add-suffix s2)
  (lambda (s) (string-append s s2)))
(twice (make-add-suffix "!") "hello")
(twice (make-add-suffix "?!") "hello")
(twice (make-add-suffix "...") "hello")
]

@; Racket is a @defterm{lexically scoped} language, which means that
@; @racket[s2] in the function returned by @racket[make-add-suffix]
@; always refers to the argument for the call that created the
@; function. In other words, the @racket[lambda]-generated function
@; ``remembers'' the right @racket[s2]:

Racket 是一个带有@defterm{词法作用域}的语言，这表示 @racket[make-add-suffix]
返回的函数中的 @racket[s2] 总是会引述创建该函数的调用的参数。换句话说，
被生成的 @racket[lambda] 函数“记住了”正确的 @racket[s2]：

@interaction[
#:eval ex-eval
(define louder (make-add-suffix "!"))
(define less-sure (make-add-suffix "?"))
(twice less-sure "really")
(twice louder "really")
]

@; We have so far referred to definitions of the form @racket[(define
@; @#,nonterm{id} @#,nonterm{expr})] as ``non-function
@; definitions.'' This characterization is misleading, because the
@; @nonterm{expr} could be a @racket[lambda] form, in which case
@; the definition is equivalent to using the ``function'' definition
@; form. For example, the following two definitions of @racket[louder]
@; are equivalent:

目前我们只是将形如 @racket[(define @#,nonterm{id} @#,nonterm{expr})]
的定义当做“非函数定义”，然而这种刻画方式是具有误导性的。由于 @nonterm{expr}
可以是 @racket[lambda] 的形式，因此在这种情况下，其定义等价于使用“函数”形式的定义。
例如，以下两种 @racket[louder] 的定义是等价的：

@defs+int[
#:eval ex-eval
[(define (louder s)
   (string-append s "!"))
 code:blank
 (define louder
   (lambda (s)
     (string-append s "!")))]
louder
]

@; Note that the expression for @racket[louder] in the second case is an
@; ``anonymous'' function written with @racket[lambda], but, if
@; possible, the compiler infers a name, anyway, to make printing and
@; error reporting as informative as possible.

请注意在第二种情况下，@racket[louder] 的表达式为使用 @racket[lambda]
编写的“匿名函数”。单如果可能的话，编译器总是会推断出一个名字，
以使其打印结果和错误报告的信息尽可能地丰富。

@;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@; @section[#:tag "local-binding-intro"]{Local Binding with
@;          @racket[define], @racket[let], and @racket[let*]}

@section[#:tag "local-binding-intro"]{局部绑定与
         @racket[define]、@racket[let] 和 @racket[let*]}

@; It's time to retract another simplification in our grammar of
@; Racket. In the body of a function, definitions can appear before the
@; body expressions:

@; @moreguide["intdefs"]{local (internal) definitions}

现在是时候丰富我们对 Racket 语法的简单认知了。在函数体中，定义可以出现在主体表达式之前：

@moreguide["intdefs"]{局部（内部）定义}

@racketblock[
#,fun-defn2-stx
#,lambda2-expr-stx
]

@; Definitions at the start of a function body are local to the
@; function body.

@; @defexamples[
@; (define (converse s)
@;   (define (starts? s2) (code:comment @#,t{local to @racket[converse]})
@;     (define len2 (string-length s2))  (code:comment @#,t{local to @racket[starts?]})
@;     (and (>= (string-length s) len2)
@;          (equal? s2 (substring s 0 len2))))
@;   (cond
@;    [(starts? "hello") "hi!"]
@;    [(starts? "goodbye") "bye!"]
@;    [else "huh?"]))
@; (converse "hello!")
@; (converse "urp")
@; (eval:alts (code:line starts? (code:comment @#,t{outside of @racket[converse], so...}))
@;            (parameterize ([current-namespace (make-base-namespace)]) (eval 'starts?)))
@; ]

函数体起始处的定义为函数体的局部定义。

@defexamples[
(define (converse s)
  (define (starts? s2) (code:comment @#,t{局限于 @racket[converse] 中})
    (define len2 (string-length s2))  (code:comment @#,t{局限于 @racket[starts?] 中})
    (and (>= (string-length s) len2)
         (equal? s2 (substring s 0 len2))))
  (cond
   [(starts? "hello") "hi!"]
   [(starts? "goodbye") "bye!"]
   [else "huh?"]))
(converse "hello!")
(converse "urp")
(eval:alts (code:line starts? (code:comment @#,t{在 @racket[converse] 之外，所以...}))
           (parameterize ([current-namespace (make-base-namespace)]) (eval 'starts?)))
]

@; Another way to create local bindings is the @racket[let] form. An
@; advantage of @racket[let] is that it can be used in any expression
@; position. Also, @racket[let] binds many identifiers at once, instead
@; of requiring a separate @racket[define] for each identifier.

@; @moreguide["intdefs"]{@racket[let] and @racket[let*]}

创建局部绑定的另一种方式是使用 @racket[let] 形式。@racket[let]
的一个优点是它可以在表达式中的任何地方使用。此外，@racket[let]
可一次绑定多个标识符，而无需用 @racket[define] 分别定义每个标识符。

@moreguide["intdefs"]{@racket[let] 和 @racket[let*]}

@racketblock[
#,let-expr-stx
]

@; Each binding clause is an @nonterm{id} and an
@; @nonterm{expr} surrounded by square brackets, and the
@; expressions after the clauses are the body of the @racket[let]. In
@; each clause, the @nonterm{id} is bound to the result of the
@; @nonterm{expr} for use in the body.

每个绑定从句都是用方括号括住的一对 @nonterm{id} 和 @nonterm{expr}，
从句之后的表达式则是 @racket[let] 的主体。在每个从句中，@nonterm{id}
均被绑定为 @nonterm{expr} 的结果以用在主体中。

@interaction[
(let ([x (random 4)]
      [o (random 4)])
  (cond
   [(> x o) "X wins"]
   [(> o x) "O wins"]
   [else "cat's game"]))
]

@; The bindings of a @racket[let] form are available only in the body of
@; the @racket[let], so the binding clauses cannot refer to each
@; other. The @racket[let*] form, in contrast, allows later clauses to
@; use earlier bindings:

@racket[let] 形式中的绑定只能在 @racket[let] 的主体中使用，因此绑定从句无法互相引述。
而 @racket[let*] 形式则允许后面的从句使用前面的绑定：

@interaction[
(let* ([x (random 4)]
       [o (random 4)]
       [diff (number->string (abs (- x o)))])
  (cond
   [(> x o) (string-append "X wins by " diff)]
   [(> o x) (string-append "O wins by " diff)]
   [else "cat's game"]))
]

@; ----------------------------------------------------------------------

@close-eval[ex-eval]
