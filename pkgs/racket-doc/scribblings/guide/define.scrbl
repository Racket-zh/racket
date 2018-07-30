#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@(define def-eval (make-base-eval))

@; @title[#:tag "define"]{Definitions: @racket[define]}

@title[#:tag "define"]{定义：@racket[define]}

@; A basic definition has the form

基本定义的形式为

@specform[(define id expr)]{}

@; in which case @racket[_id] is bound to the result of
@; @racket[_expr].

此时 @racket[_id] 会被绑定到 @racket[_expr] 的结果上。

@defexamples[
#:eval def-eval
(define salutation (list-ref '("Hi" "Hello") (random 2)))
salutation
]

@;------------------------------------------------------------------------
@; @section{Function Shorthand}

@section{函数简写}

@; The @racket[define] form also supports a shorthand for function
@; definitions:

@racket[define] 形式也支持函数定义的简写：

@specform[(define (id arg ...) body ...+)]{}

@; which is a shorthand for

它简写自

@racketblock[
(define _id (lambda (_arg ...) _body ...+))
]

@defexamples[
#:eval def-eval
(define (greet name)
  (string-append salutation ", " name))
(greet "John")
]

@def+int[
#:eval def-eval
(define (greet first [surname "Smith"] #:hi [hi salutation])
  (string-append hi ", " first " " surname))
(greet "John")
(greet "John" #:hi "Hey")
(greet "John" "Doe")
]

@; The function shorthand via @racket[define] also supports a
@; @tech{rest argument} (i.e., a final argument to collect extra
@; arguments in a list):

通过 @racket[define] 定义的函数简写也支持@tech{剩余参数}
（即，最后一个参数将额外的参数收集在一个列表中）：

@specform[(define (id arg ... . rest-id) body ...+)]{}

@; which is a shorthand

它简写自

@racketblock[
(define _id (lambda (_arg ... . _rest-id) _body ...+))
]

@defexamples[
#:eval def-eval
(define (avg . l)
  (/ (apply + l) (length l)))
(avg 1 2 3)
]

@;------------------------------------------------------------------------
@; @section{Curried Function Shorthand}

@section{柯里化函数简写}

@; Consider the following @racket[make-add-suffix] function that takes a
@; string and returns another function that takes a string:

考虑以下 @racket[make-add-suffix] 函数，它接受一个字符串并返回另一个接受字符串的函数：

@def+int[
#:eval def-eval
(define make-add-suffix
  (lambda (s2)
    (lambda (s) (string-append s s2))))
]

@; Although it's not common, result of @racket[make-add-suffix] could be
@; called directly, like this:

尽管它并不常见，但 @racket[make-add-suffix] 的结果可被直接调用，就行这样：

@interaction[
#:eval def-eval
((make-add-suffix "!") "hello")
]

@; In a sense, @racket[make-add-suffix] is a function takes two
@; arguments, but it takes them one at a time. A function that takes some
@; of its arguments and returns a function to consume more is sometimes
@; called a @defterm{curried function}.

某种意义上来说，@racket[make-add-suffix] 是个接受两个参数的函数，
不过它一次只接受其中的一个。接受一部分参数并返回另一个函数来消耗更多参数的函数，
叫做@defterm{柯里化函数}。

@; Using the function-shorthand form of @racket[define],
@; @racket[make-add-suffix] can be written equivalently as

使用 @racket[define] 的函数简写形式，@racket[make-add-suffix] 可等价地写作

@racketblock[
(define (make-add-suffix s2)
  (lambda (s) (string-append s s2)))
]

@; This shorthand reflects the shape of the function call
@; @racket[(make-add-suffix "!")]. The @racket[define] form further
@; supports a shorthand for defining curried functions that reflects
@; nested function calls:

此简写反映了函数调用 @racket[(make-add-suffix "!")] 的形状。@racket[define]
形式进一步还支持定义柯里化函数的简写，该简写反映了嵌套的函数调用：

@def+int[
#:eval def-eval
(define ((make-add-suffix s2) s)
  (string-append s s2))
((make-add-suffix "!") "hello")
]
@defs+int[
#:eval def-eval
[(define louder (make-add-suffix "!"))
 (define less-sure (make-add-suffix "?"))]
(less-sure "really")
(louder "really")
]

@; The full syntax of the function shorthand for @racket[define] is as follows:

@racket[define] 的函数简写的完整语法如下：

@specform/subs[(define (head args) body ...+)
               ([head id
                      (head args)]
                [args (code:line arg ...)
                      (code:line arg ... @#,racketparenfont{.} rest-id)])]{}

@; The expansion of this shorthand has one nested @racket[lambda] form
@; for each @racket[_head] in the definition, where the innermost
@; @racket[_head] corresponds to the outermost @racket[lambda].

此简写展开后，定义中的每一个 @racket[_head] 都对应一层嵌套的 @racket[lambda]
形式，最内层的 @racket[_head] 对应最外层的 @racket[lambda]。


@;------------------------------------------------------------------------
@; @section[#:tag "multiple-values"]{Multiple Values and @racket[define-values]}

@section[#:tag "multiple-values"]{多值与 @racket[define-values]}

@; A Racket expression normally produces a single result, but some
@; expressions can produce multiple results. For example,
@; @racket[quotient] and @racket[remainder] each produce a single value,
@; but @racket[quotient/remainder] produces the same two values at once:

Racket 表达式通常只会产生一个结果，然而某些表达式可以产生多个结果。例如，
@racket[quotient] 和 @racket[remainder] 二者均会产生一个值，而
@racket[quotient/remainder] 则会一次产生与前二者结果相同的两个值：

@interaction[
#:eval def-eval
(quotient 13 3)
(remainder 13 3)
(quotient/remainder 13 3)
]

@; As shown above, the @tech{REPL} prints each result value on its own
@; line.

如上所示，@tech{REPL} 会在单独的行中打印每个值。

@; Multiple-valued functions can be implemented in terms of the
@; @racket[values] function, which takes any number of values and
@; returns them as the results:

多值函数可通过 @racket[values] 函数来实现，该函数接受任意数量的值并将它们作为结果返回：

@interaction[
#:eval def-eval
(values 1 2 3)
]
@def+int[
#:eval def-eval
(define (split-name name)
  (let ([parts (regexp-split " " name)])
    (if (= (length parts) 2)
        (values (list-ref parts 0) (list-ref parts 1))
        (error "not a <first> <last> name"))))
(split-name "Adam Smith")
]

@; The @racket[define-values] form binds multiple identifiers at once to
@; multiple results produced from a single expression:

@racket[define-values] 形式可将单个表达式产生的多个结果一次绑定到多个标识符：

@specform[(define-values (id ...) expr)]{}

@; The number of results produced by the @racket[_expr] must match the
@; number of @racket[_id]s.

@racket[_expr] 产生的结果数量必须与 @racket[_id] 的数量相匹配。

@defexamples[
#:eval def-eval
(define-values (given surname) (split-name "Adam Smith"))
given
surname
]

@; A @racket[define] form (that is not a function shorthand) is
@; equivalent to a @racket[define-values] form with a single @racket[_id].

非函数简写的 @racket[define] 形式等价于只有一个 @racket[_id] 的
@racket[define-values] 形式。

@; @refdetails["define"]{definitions}

@refdetails["define"]{定义}

@;------------------------------------------------------------------------
@; @section[#:tag "intdefs"]{Internal Definitions}

@section[#:tag "intdefs"]{内部定义}

@; When the grammar for a syntactic form specifies @racket[_body], then
@; the corresponding form can be either a definition or an expression.
@; A definition as a @racket[_body] is an @defterm{internal definition}.

当一个语法形式的文法中指定了 @racket[_body] 时，其对应的形式可以是定义或表达式。
作为 @racket[_body] 的定义叫做 @defterm{内部定义}。

@; Expressions and internal definitions in a @racket[_body] sequence can
@; be mixed, as long as the last @racket[_body] is an expression.

@racket[_body] 序列中的表达式和内部定义可以混合使用，只要最后一个 @racket[_body]
是表达式就行。

@; For example, the syntax of @racket[lambda] is

例如，@racket[lambda] 的语法为

@specform[
(lambda gen-formals
  body ...+)
]

@; so the following are valid instances of the grammar:

因此下面是有效的文法实例：

@racketblock[
(lambda (f)                (code:comment @#,elem{no definitions})
  (printf "running\n")
  (f 0))

(lambda (f)                (code:comment @#,elem{one definition})
  (define (log-it what)
    (printf "~a\n" what))
  (log-it "running")
  (f 0)
  (log-it "done"))

(lambda (f n)              (code:comment @#,elem{two definitions})
  (define (call n)
    (if (zero? n)
        (log-it "done")
        (begin
          (log-it "running")
          (f n)
          (call (- n 1)))))
  (define (log-it what)
    (printf "~a\n" what))
  (call n))
]

@; Internal definitions in a particular @racket[_body] sequence are
@; mutually recursive; that is, any definition can refer to any other
@; definition---as long as the reference isn't actually evaluated before
@; its definition takes place. If a definition is referenced too early,
@; an error occurs.

特定的 @racket[_body] 序列中的内部定义是可以互相递归的，也就是说，
任何定义都可以引用任何其它定义——只要引用在其定义之前不会被实际求值就行。
若定义被引用得太早，就会产生错误。

@defexamples[
(define (weird)
  (define x x)
  x)
(weird)
]

@; A sequence of internal definitions using just @racket[define] is
@; easily translated to an equivalent @racket[letrec] form (as introduced
@; in the next section). However, other definition forms can appear as a
@; @racket[_body], including @racket[define-values], @racket[struct] (see
@; @secref["define-struct"]) or @racket[define-syntax] (see
@; @secref["macros"]).

一系列只使用 @racket[define] 的内部定义很容易被翻译成等价的 @racket[letrec]
形式（下一节会介绍）。然而，其它定义形式可作为 @racket[_body] 出现，包括
@racket[define-values]、@racket[struct]（见 @secref["define-struct"]）或
@racket[define-syntax]（见 @secref["macros"]）。

@; @refdetails/gory["intdef-body"]{internal definitions}

@refdetails/gory["intdef-body"]{内部定义}

@; ----------------------------------------------------------------------

@close-eval[def-eval]
