#lang scribble/doc
@(require scribble/manual scribble/eval racket/list "guide-utils.rkt"

          (for-label racket/list
                     (only-in racket/class is-a?)))

@(define list-eval (make-base-eval))
@(interaction-eval #:eval list-eval (require racket/list))

@; @title{Pairs, Lists, and Racket Syntax}

@title{序对、列表和 Racket 语法}

@; The @racket[cons] function actually accepts any two values, not just
@; a list for the second argument. When the second argument is not
@; @racket[empty] and not itself produced by @racket[cons], the result prints
@; in a special way. The two values joined with @racket[cons] are printed
@; between parentheses, but with a dot (i.e., a period surrounded by
@; whitespace) in between:

@racket[cons] 函数实际上接受两个任意值，而不止是一个列表作为第二个参数。
当第二个参数非 @racket[empty] 且自身不是由 @racket[cons] 产生时，
其结果会打印为特殊的形式。由 @racket[cons] 结合的两个值会打印在括号中，
不过它们之间会有个点（即一个两侧为空格的英文句点）：

@interaction[(cons 1 2) (cons "banana" "split")]

@; Thus, a value produced by @racket[cons] is not always a list. In
@; general, the result of @racket[cons] is a @defterm{pair}. The more
@; traditional name for the @racket[cons?] function is @racket[pair?],
@; and we'll use the traditional name from now on.

因此，由 @racket[cons] 产生的值并不总是列表。通常，@racket[cons] 的结果是一个
@racket[序对]。@racket[cons?] 函数更传统的名字是 @racket[pair?]，
我们之后会使用这个传统的名字。

@; The name @racket[rest] also makes less sense for non-list pairs; the
@; more traditional names for @racket[first] and @racket[rest] are
@; @racket[car] and @racket[cdr], respectively. (Granted, the traditional
@; names are also nonsense. Just remember that ``a'' comes before ``d,''
@; and @racket[cdr] is pronounced ``could-er.'')

@racket[rest] 对非列表的序对也没什么意义。@racket[first] 和 @racket[rest]
更传统的名字分别是 @racket[car] 和 @racket[cdr]。（不过，传统的名字也没什么意义。
你只要记住“a”在“d”前面，@racket[cdr]发音为“could-er”就好了。）

@examples[
#:eval list-eval
(car (cons 1 2))
(cdr (cons 1 2))
(pair? empty)
(pair? (cons 1 2))
(pair? (list 1 2 3))
]

@close-eval[list-eval]

@; Racket's pair datatype and its relation to lists is essentially a
@; historical curiosity, along with the dot notation for printing and the
@; funny names @racket[car] and @racket[cdr]. Pairs are deeply wired into
@; to the culture, specification, and implementation of Racket, however,
@; so they survive in the language.

Racket 的序对数据类型和它与列表的关系，连同打印时的点号记法和滑稽的名字
@racket[car] 和 @racket[cdr] 基本上都是历史的奇妙产物。
序对深深地刻印在了 Racket 的文化、规范和实现中，它们因而在语言中得以留存。

@; You are perhaps most likely to encounter a non-list pair when making a
@; mistake, such as accidentally reversing the arguments to
@; @racket[cons]:

你很可能因为非列表序对而犯错，例如不小心弄反了 @racket[cons] 的参数：

@interaction[(cons (list 2 3) 1) (cons 1 (list 2 3))]

@; Non-list pairs are used intentionally, sometimes. For example, the
@; @racket[make-hash] function takes a list of pairs, where the
@; @racket[car] of each pair is a key and the @racket[cdr] is an
@; arbitrary value.

有时我们需要特意去使用非列表序。例如，@racket[make-hash] 函数接受一个序对的列表，
其中每个序对的 @racket[car] 为键，@racket[cdr] 为值。

@; The only thing more confusing to new Racketeers than non-list pairs is
@; the printing convention for pairs where the second element @italic{is}
@; a pair, but @italic{is not} a list:

比非列表序对还要让 Racket 新手感到困惑的是另一种序对的打印约定，其第二个元素为
@bold{序对}而非@bold{列表}：

@interaction[(cons 0 (cons 1 2))]

@; In general, the rule for printing a pair is as follows: use the dot
@; notation unless the dot is immediately followed by an open
@; parenthesis. In that case, remove the dot, the open parenthesis, and the
@; matching close parenthesis. Thus, @racketresultfont[#:decode? #f]{'(0 . (1 . 2))}
@; becomes @racketresult['(0 1 . 2)], and
@; @racketresultfont[#:decode? #f]{'(1 . (2 . (3 . ())))} becomes @racketresult['(1 2 3)].

通常，序对的打印遵循如下规则：使用点号记法，除非点号后面紧跟着开括号，
而在这种情况下，点号、紧跟的开括号以及匹配的闭括号会被省略。因此
@racketresultfont[#:decode? #f]{'(0 . (1 . 2))} 会打印为 @racketresult['(0 1 . 2)]，
而 @racketresultfont[#:decode? #f]{'(1 . (2 . (3 . ())))} 则会打印为 @racketresult['(1 2 3)]。

@;------------------------------------------------------------------------
@; @section[#:tag "quoting-lists"]{Quoting Pairs and Symbols with @racket[quote]}

@section[#:tag "quoting-lists"]{用 @racket[quote] 引用序对和符号}

@; A list prints with a quote mark before it, but if an element of a list
@; is itself a list, then no quote mark is printed for the inner list:

列表在打印时会在前面标一个单引号。但如果列表的元素本身也是列表，那么内部的列表前面则不会有单引号：

@interaction[
(list (list 1) (list 2 3) (list 4))
]

@; For nested lists, especially, the @racket[quote] form lets you write a
@; list as an expression in essentially the same way that the list
@; prints:

特别来说，对于嵌套列表而言，@racket[qoute] 形式能让你将列表写成表达式，
其形式基本上与列表的打印形式相同：

@interaction[
(eval:alts (@#,racket[quote] ("red" "green" "blue")) '("red" "green" "blue"))
(eval:alts (@#,racket[quote] ((1) (2 3) (4))) '((1) (2 3) (4)))
(eval:alts (@#,racket[quote] ()) '())
]

@; The @racket[quote] form works with the dot notation, too, whether the
@; quoted form is normalized by the dot-parenthesis elimination rule or
@; not:

无论列表的引用形式是否会被点号-括号消除规则正规化，@racket[qoute]
形式都可以与点号形式配合使用：

@interaction[
(eval:alts (@#,racket[quote] (1 . 2)) '(1 . 2))
(eval:alts (@#,racket[quote] (0 @#,racketparenfont{.} (1 . 2))) '(0 . (1 . 2)))
]

@; Naturally, lists of any kind can be nested:

自然，任何种类的列表均可以嵌套：

@interaction[
(list (list 1 2 3) 5 (list "a" "b" "c"))
(eval:alts (@#,racket[quote] ((1 2 3) 5 ("a" "b" "c"))) '((1 2 3) 5 ("a" "b" "c")))
]

@; If you wrap an identifier with @racket[quote], then you get output
@; that looks like an identifier, but with a @litchar{'} prefix:

如果你用 @racket[quote] 包裹了标识符，那么其输出形式类似于带有 @litchar{'} 前缀的标识符：

@interaction[
(eval:alts (@#,racket[quote] jane-doe) 'jane-doe)
]

@; A value that prints like a quoted identifier is a @defterm{symbol}. In the
@; same way that parenthesized output should not be confused with
@; expressions, a printed symbol should not be confused with an
@; identifier. In particular, the symbol @racket[(@#,racket[quote]
@; @#,racketidfont{map})] has nothing to do with the @racketidfont{map}
@; identifier or the predefined function that is bound to
@; @racket[map], except that the symbol and the identifier happen
@; to be made up of the same letters.

打印形式为带有单引号前缀的标识符的值，叫做 @defterm{符号}。
同带括号的输出不应与表达式混淆一样，符号的打印也不应当与标识符混淆。
具体来说，除了字母相同外，符号 @racket[(@#,racket[quote] @#,racketidfont{map})]
同标识符 @racketidfont{map} 或绑定到 @racket[map] 的预定义函数之间没有任何关系。

@; Indeed, the intrinsic value of a symbol is nothing more than its
@; character content. In this sense, symbols and strings are almost the
@; same thing, and the main difference is how they print. The functions
@; @racket[symbol->string] and @racket[string->symbol] convert between
@; them.

实际上，符号固有的值除了其字符常量外再无其它。从这个意义上来说，符号和字符串几乎是一样的，
而它们的主要区别就是打印的形式。函数 @racket[symbol->string] 和 @racket[string->symbol]
可以在二者之间互相转换。

@examples[
map
(eval:alts (@#,racket[quote] @#,racketidfont{map}) 'map)
(eval:alts (symbol? (@#,racket[quote] @#,racketidfont{map})) (symbol? 'map))
(symbol? map)
(procedure? map)
(string->symbol "map")
(eval:alts (symbol->string (@#,racket[quote] @#,racketidfont{map})) (symbol->string 'map))
]

@; In the same way that @racket[quote] for a list automatically applies
@; itself to nested lists, @racket[quote] on a parenthesized sequence of
@; identifiers automatically applies itself to the identifiers to create
@; a list of symbols:

同 @racket[quote] 会自动应用到嵌套的列表内一样，对于括号括住的标识符序列来说，
它也会自动应用到其中的标识符上来创建出符号列表：


@interaction[
(eval:alts (car (@#,racket[quote] (@#,racketidfont{road} @#,racketidfont{map}))) (car '(road map)))
(eval:alts (symbol? (car (@#,racket[quote] (@#,racketidfont{road} @#,racketidfont{map})))) (symbol? (car '(road map))))
]

@; When a symbol is inside a list that is printed with
@; @litchar{'}, the @litchar{'} on the symbol is omitted, since
@; @litchar{'} is doing the job already:

当符号在以 @litchar{'} 打印的列表中时，符号前的 @litchar{'} 会被省略，
因为 @litchar{'} 已经自动做了这件事：

@interaction[
(eval:alts (@#,racket[quote] (@#,racketidfont{road} @#,racketidfont{map})) '(road map))
]

@; The @racket[quote] form has no effect on a literal expression such as
@; a number or string:

@racket[quote] 形式对数值或字符串之类的字面量表达式没有效果：

@interaction[
(eval:alts (@#,racket[quote] 42) 42)
(eval:alts (@#,racket[quote] "on the record") "on the record")
]

@;------------------------------------------------------------------------
@; @section{Abbreviating @racket[quote] with @racketvalfont{@literal{'}}}

@section{将 @racket[quote] 简写为 @racketvalfont{@literal{'}}}

@; As you may have guessed, you can abbreviate a use of
@; @racket[quote] by just putting @litchar{'} in front of a form to
@; quote:

如你所料，你可以将 @racket[quote] 简写为将 @litchar{'} 放在表达式前面来引用它：

@interaction[
'(1 2 3)
'road
'((1 2 3) road ("a" "b" "c"))
]

@; In the documentation, @litchar{'} within an expression is printed in green along with the
@; form after it, since the combination is an expression that is a
@; constant. In DrRacket, only the @litchar{'} is colored green. DrRacket
@; is more precisely correct, because the meaning of @racket[quote] can
@; vary depending on the context of an expression. In the documentation,
@; however, we routinely assume that standard bindings are in scope, and
@; so we paint quoted forms in green for extra clarity.

在文档中，表达式中的 @litchar{'} 及其后面的形式会打印为绿色，因为这种组合其实初春贯彻常量表达式。
在 DrRacket 中，只有 @litchar{'} 会显示为绿色。DrRacket 要更加精准正确，因为 @racket[quote]
的意思会随表达式的上下文而不同。然而在文档中，我们通常假定标准的绑定是在作用域内的，
因此为了更加清楚，我们就把引用的形式渲染成了绿色。

@; A @litchar{'} expands to a @racket[quote] form in quite a literal
@; way. You can see this if you put a @litchar{'} in front of a form that has a
@; @litchar{'}:

@litchar{'} 会以相当字面的方式展开为 @racket[quote] 形式。如果你在带有 @litchar{'}
的形式前面再加一个 @litchar{'}，就会看到这一点：

@interaction[
(car ''road)
(eval:alts (car '(@#,racketvalfont{quote} @#,racketvalfont{road})) 'quote)
]

@; The @litchar{'} abbreviation works in output as well as input. The
@; @tech{REPL}'s printer recognizes the symbol @racket['quote] as the
@; first element of a two-element list when printing output, in which
@; case it uses @racketidfont{'} to print the output:

@litchar{'} 简写在输出时的行为与输入时一样。@tech{REPL} 的打印器在打印输出时，
会将符号 @racket['quote] 识别为一个两元素列表的第一个元素，此时它会使用
@racketidfont{'} 来打印输出：

@interaction[
(eval:alts (@#,racketvalfont{quote} (@#,racketvalfont{quote} @#,racketvalfont{road})) ''road)
(eval:alts '(@#,racketvalfont{quote} @#,racketvalfont{road}) ''road)
''road
]

@; FIXME:
@; warning about how "quote" creates constant data, which is subtly
@; different than what "list" creates

@;------------------------------------------------------------------------
@; @section[#:tag "lists-and-syntax"]{Lists and Racket Syntax}

@section[#:tag "lists-and-syntax"]{列表与 Racket 语法}

@; Now that you know the truth about pairs and lists, and now that you've
@; seen @racket[quote], you're ready to understand the main way in which
@; we have been simplifying Racket's true syntax.

现在你已经知道了序对和列表的真相，也见过了 @racket[quote]，
你已经准备好理解我们简化真正的 Racket 语法的主要方式了。

@; The syntax of Racket is not defined directly in terms of character
@; streams. Instead, the syntax is determined by two layers:

Racket 的语法并不是直接根据字符流来定义的，而是由两个层次来确定的：

@itemize[

@;  @item{a @deftech{reader} layer, which turns a sequence of characters
@;        into lists, symbols, and other constants; and}

@;  @item{an @deftech{expander} layer, which processes the lists, symbols,
@;        and other constants to parse them as an expression.}

 @item{@deftech{读取器}层，它将字符序列转换为列表、符号和其它常量；以及}

 @item{@deftech{展开器}层，它对列表、符号和其它常量进行处理并解析为表达式。}

]

@; The rules for printing and reading go together. For example, a list is
@; printed with parentheses, and reading a pair of parentheses produces a
@; list. Similarly, a non-list pair is printed with the dot notation, and
@; a dot on input effectively runs the dot-notation rules in reverse to
@; obtain a pair.

打印和读取的规则是相辅相成的。例如，列表会打印为带括号的形式，
而读取一对括号会产生一个列表。同样，非列表序对会打印为点号记法，
而输入点号实际上会反向执行点号记法的规则，从而获取一个序对。

@; One consequence of the read layer for expressions is that you can use
@; the dot notation in expressions that are not quoted forms:

读取层作用于表达式的一个结果是，你可以在非引用形式的表达式中使用点号记法：

@interaction[
(eval:alts (+ 1 . @#,racket[(2)]) (+ 1 2))
]

@; This works because @racket[(+ 1 . @#,racket[(2)])] is just another
@; way of writing @racket[(+ 1 2)]. It is practically never a good idea
@; to write application expressions using this dot notation; it's just a
@; consequence of the way Racket's syntax is defined.

这样可行是因为 @racket[(+ 1 . @#,racket[(2)])] 不过是 @racket[(+ 1 2)]
的另一种写法。在实践中，使用这种点号记法来编写应用表达式绝对不是个好主意，
这只是 Racket 语法定义方式的一个结果而已。

@; Normally, @litchar{.} is allowed by the reader only with a
@; parenthesized sequence, and only before the last element of the
@; sequence. However, a pair of @litchar{.}s can also appear around a
@; single element in a parenthesized sequence, as long as the element is
@; not first or last. Such a pair triggers a reader conversion that moves
@; the element between @litchar{.}s to the front of the list. The
@; conversion enables a kind of general infix notation:

通常，在括号括住的序列中，读取器只允许在最后一个元素之前使用 @litchar{.}。
然而，在括号括住的序列中，一对 @litchar{.} 也可以出现在单个元素两侧，
只要该元素不是第一个或最后一个几个。这种用法会触发读取器进行转换，
将两个 @litchar{.} 中间的元素移到列表的最前面。这种转换赋予了我们使用通用的中缀记法的能力：

@interaction[
(1 . < . 2)
'(1 . < . 2)
]

@; This two-dot convention is non-traditional, and it has essentially
@; nothing to do with the dot notation for non-list pairs. Racket
@; programmers use the infix convention sparingly---mostly for asymmetric
@; binary operators such as @racket[<] and @racket[is-a?].

这种两个点号的约定并不是传统的，它与非列表序对中的点号记法实际上也没什么关系。
Racket 程序员对中缀约定的使用非常保守---大多用于非对称的二元运算符，例如
@racket[<] 和 @racket[is-a?]。
