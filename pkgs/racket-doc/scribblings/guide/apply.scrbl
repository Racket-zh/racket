#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "application"]{Function Calls@aux-elem{ (Procedure Applications)}}

@title[#:tag "application"]{函数调用@aux-elem{（过程应用）}}

@; An expression of the form

对于形式为

@specsubform[
(proc-expr arg-expr ...)
]

@; is a function call---also known as a @defterm{procedure
@; application}---when @racket[_proc-expr] is not an identifier that is
@; bound as a syntax transformer (such as @racket[if] or
@; @racket[define]).

的表达式，当 @racket[_proc-expr] 不是作为语法变换器（如 @racket[if]
或 @racket[define]）来绑定的标识符时，它就是一个函数调用，另称为@defterm{过程应用}。

@; @section{Evaluation Order and Arity}

@section{求值顺序与参数量}

@; A function call is evaluated by first evaluating the
@; @racket[_proc-expr] and all @racket[_arg-expr]s in order (left to
@; right). Then, if @racket[_proc-expr] produces a function that accepts
@; as many arguments as supplied @racket[_arg-expr]s, the function is
@; called. Otherwise, an exception is raised.

函数调用首先会按从左到右的顺序对 @racket[_proc-expr] 和所有的 @racket[_arg-expr]
进行求值。接着，如果 @racket[_proc-expr] 产生的函数所接受的参数数量与
@racket[_arg-expr] 所支持的相同，那么该函数就会被调用。否则就会触发一个异常。

@examples[
(cons 1 null)
(+ 1 2 3)
(cons 1 2 3)
(1 2 3)
]

@; Some functions, such as @racket[cons], accept a fixed number of
@; arguments. Some functions, such as @racket[+] or @racket[list], accept
@; any number of arguments. Some functions accept a range of argument
@; counts; for example @racket[substring] accepts either two or three
@; arguments. A function's @idefterm{arity} is the number of arguments
@; that it accepts.

有些函数如 @racket[cons] 接受固定数量的参数；有些函数如 @racket[+]
或 @racket[list] 则接受任意数量的参数。还有些函数接受一定数量范围内的参数，
例如 @racket[substring] 接受两个或三个参数。
函数的@idefterm{参数量}（或称元数）即为该函数所接受的参数数量。

@; @;------------------------------------------------------------------------
@; @section[#:tag "keyword-args"]{Keyword Arguments}

@;------------------------------------------------------------------------
@section[#:tag "keyword-args"]{关键字参数}

@; Some functions accept @defterm{keyword arguments} in addition to
@; by-position arguments. For that case, an @racket[_arg] can be an
@; @racket[_arg-keyword _arg-expr] sequence instead of just a
@; @racket[_arg-expr]:

除了位置固定的参数外，有些函数还接受@defterm{关键字参数}。此时，@racket[_arg]
可以是一个 @racket[_arg-keyword _arg-expr] 序列而非只是一个 @racket[_arg-expr]：

@; @guideother{@secref["keywords"] introduces keywords.}

@guideother{@secref["keywords"]介绍了关键字。}

@specform/subs[
(_proc-expr arg ...)
([arg arg-expr
      (code:line arg-keyword arg-expr)])
]

@; For example,

例如，

@racketblock[(go "super.rkt" #:mode 'fast)]

@; calls the function bound to @racket[go] with @racket["super.rkt"] as a
@; by-position argument, and with @racket['fast] as an argument
@; associated with the @racket[#:mode] keyword. A keyword is implicitly
@; paired with the expression that follows it.

会以 @racket["super.rkt"] 作为位置固定的参数，以 @racket['fast] 作为关联到
@racket[#:mode] 关键字的参数，调用绑定到 @racket[go] 的函数。
关键字会隐式地与紧随其后的表达式配对。

@; Since a keyword by itself is not an expression, then

由于关键字本身并非表达式，因此

@racketblock[(go "super.rkt" #:mode #:fast)]

@; is a syntax error. The @racket[#:mode] keyword must be followed by an
@; expression to produce an argument value, and @racket[#:fast] is not an
@; expression.

会产生语法错误。@racket[#:mode] 关键字必须后跟一个表达式来产生一个参数值，
然而 @racket[#:fast] 并不是一个表达式。

@; The order of keyword @racket[_arg]s determines the order in which
@; @racket[_arg-expr]s are evaluated, but a function accepts keyword
@; arguments independent of their position in the argument list. The
@; above call to @racket[go] can be equivalently written

关键字 @racket[_arg] 的顺序决定了 @racket[_arg-expr] 求值的顺序，
然而函数接受的关键字参数与其在参数列表中的位置无关。上面对 @racket[go]
的调用可以等价地写作：

@racketblock[(go #:mode 'fast "super.rkt")]

@; @refdetails["application"]{procedure applications}

@refdetails["application"]{过程应用}

@; @;------------------------------------------------------------------------
@; @section[#:tag "apply"]{The @racket[apply] Function}

@;------------------------------------------------------------------------
@section[#:tag "apply"]{@racket[apply] 函数}

@; The syntax for function calls supports any number of arguments, but a
@; specific call always specifies a fixed number of arguments. As a
@; result, a function that takes a list of arguments cannot directly
@; apply a function like @racket[+] to all of the items in a list:

函数调用的语法支持任意数量的参数，然而具体的调用总是指定固定数量的参数。
结果就是，接受一个参数列表的函数无法直接将 @racket[+] 这类的函数应用到列表中所有的项上：

@; @def+int[
@; (define (avg lst) (code:comment @#,elem{doesn't work...})
@;   (/ (+ lst) (length lst)))
@; (avg '(1 2 3))
@; ]

@; @def+int[
@; (define (avg lst) (code:comment @#,elem{doesn't always work...})
@;   (/ (+ (list-ref lst 0) (list-ref lst 1) (list-ref lst 2))
@;      (length lst)))
@; (avg '(1 2 3))
@; (avg '(1 2))
@; ]

@def+int[
(define (avg lst) (code:comment @#,elem{不行...})
  (/ (+ lst) (length lst)))
(avg '(1 2 3))
]

@def+int[
(define (avg lst) (code:comment @#,elem{还是不行...})
  (/ (+ (list-ref lst 0) (list-ref lst 1) (list-ref lst 2))
     (length lst)))
(avg '(1 2 3))
(avg '(1 2))
]

@; The @racket[apply] function offers a way around this restriction. It
@; takes a function and a @italic{list} argument, and it applies the
@; function to the values in the list:

@racket[apply] 函数提供了一种绕过此限制的方式。它接受一个函数和一个
@italic{列表}参数，并将该函数应用到列表中的值上：

@def+int[
(define (avg lst)
  (/ (apply + lst) (length lst)))
(avg '(1 2 3))
(avg '(1 2))
(avg '(1 2 3 4))
]

@; As a convenience, the @racket[apply] function accepts additional
@; arguments between the function and the list. The additional arguments
@; are effectively @racket[cons]ed onto the argument list:

为了方便，@racket[apply] 函数还接受位于函数和列表之间的附加参数。
附加的参数实际上会被 @racket[cons] 到参数列表上：

@def+int[
(define (anti-sum lst)
  (apply - 0 lst))
(anti-sum '(1 2 3))
]

@; The @racket[apply] function accepts keyword arguments, too, and it
@; passes them along to the called function:

@racket[apply] 函数还接受关键字参数，它会将它们一同传递给被调用函数：

@racketblock[
(apply go #:mode 'fast '("super.rkt"))
(apply go '("super.rkt") #:mode 'fast)
]

@; Keywords that are included in @racket[apply]'s list argument do not
@; count as keyword arguments for the called function; instead, all arguments in
@; this list are treated as by-position arguments. To pass a list of
@; keyword arguments to a function, use
@; the @racket[keyword-apply] function, which accepts a function to apply
@; and three lists. The first two lists are in parallel, where the first
@; list contains keywords (sorted by @racket[keyword<?]), and the second
@; list contains a corresponding argument for each keyword. The third
@; list contains by-position function arguments, as for @racket[apply].

@racket[apply] 列表参数中包含的关键字并不会被当做被调用函数的关键字参数，
而是会将该列表中的所有参数都当做位置固定的参数。要向函数传递一个关键字参数列表，
请使用 @racket[keyword-apply] 函数，它接受一个要应用的函数和三个列表。
前两个列表是平行的，其中第一个列表包含关键字（按 @racket[keyword<?] 排序）。
第二个列表包含与每个关键字相对应的参数。第三个列表则包含位置固定的函数参数，
与 @racket[apply] 相同。

@racketblock[
(keyword-apply go
               '(#:mode)
               '(fast)
               '("super.rkt"))
]
