#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "binding"]{Identifiers and Binding}

@title[#:tag "binding"]{标识符与绑定}

@; The context of an expression determines the meaning of identifiers
@; that appear in the expression. In particular, starting a module with
@; the language @racketmodname[racket], as in

表达式的上下文决定了该表达式中标识符的含义。具体来说，以语言
@racketmodname[racket] 开始的模块，即

@racketmod[racket]

@; means that, within the module, the identifiers described in this guide
@; start with the meaning described here: @racket[cons] refers to the
@; function that creates a pair, @racket[car] refers to the function
@; that extracts the first element of a pair, and so on.

表示从现在起，本指南中描述的标识符属于该模块，其意义为：@racket[cons]
指代用于创建序对的函数，@racket[car] 指代用于提取序对中第一个元素的函数，
以此类推。

@; @guideother{@secref["symbols"] introduces the syntax of
@; identifiers.}

@guideother{@secref["symbols"]中介绍了标识符的语法。}

@; Forms like @racket[define], @racket[lambda], and @racket[let]
@; associate a meaning with one or more identifiers; that is, they
@; @defterm{bind} identifiers. The part of the program for which the
@; binding applies is the @defterm{scope} of the binding. The set of
@; bindings in effect for a given expression is the expression's
@; @defterm{environment}.

像 @racket[define]、@racket[lambda] 和 @racket[let]
这类的形式用于将一个含义与一个或更多标识符相关联。即，它们用于
@defterm{绑定}标识符。程序中应用的绑定的部分即为该绑定的@defterm{作用域}。
对于一个给定的表达式，起作用的绑定的集合叫做该表达式的@defterm{环境}。

例如，在

@racketmod[
racket

(define f
  (lambda (x)
    (let ([y 5])
      (+ x y))))

(f 10)
]

@; the @racket[define] is a binding of @racket[f], the @racket[lambda]
@; has a binding for @racket[x], and the @racket[let] has a binding for
@; @racket[y]. The scope of the binding for @racket[f] is the entire
@; module; the scope of the @racket[x] binding is @racket[(let ([y 5]) (+
@; x y))]; and the scope of the @racket[y] binding is just @racket[(+ x
@; y)]. The environment of @racket[(+ x y)] includes bindings for
@; @racket[y], @racket[x], and @racket[f], as well as everything in
@; @racketmodname[racket].

中，@racket[define] 对 @racket[f] 进行了绑定，@racket[lambda] 对 @racket[x]
进行绑定，@racket[let] 对 @racket[y] 进行了绑定。@racket[f]
的绑定的作用域为整个模块；@racket[x] 的绑定的作用域为
@racket[(let ([y 5]) (+ x y))]，而 @racket[y] 的绑定的作用域只是
@racket[(+ x y)]。@racket[(+ x y)] 的环境包括 @racket[y]、@racket[x] 和
@racket[f]，以及 @racketmodname[racket] 中的任何东西。

@; A module-level @racket[define] can bind only identifiers that are not
@; already defined or @racket[require]d into the module. A local
@; @racket[define] or other binding forms, however, can give a new local
@; binding for an identifier that already has a binding; such a binding
@; @deftech{shadows} the existing binding.

模块级的 @racket[define] 只能绑定尚未定义或通过 @racket[require]
引入到模块中的标识符。然而局部的 @racket[define]
定义或其它绑定形式仍可为已经绑定的标识符赋予新的局部绑定，
这种绑定会@deftech{遮蔽}既有的绑定。

@defexamples[
(define f
  (lambda (append)
    (define cons (append "ugly" "confusing"))
    (let ([append 'this-was])
      (list append cons))))
(f list)
]

@; Similarly, a module-level @racket[define] can @tech{shadow} a binding
@; from the module's language. For example, @racket[(define cons 1)] in a
@; @racketmodname[racket] module shadows the @racket[cons] that is
@; provided by @racketmodname[racket]. Intentionally shadowing a language
@; binding is rarely a good idea---especially for widely used bindings
@; like @racket[cons]---but shadowing relieves a programmer from having
@; to avoid every obscure binding that is provided by a language.

同样，模块级的 @racket[define] 定义也可@tech{shadow}遮蔽模块语言中的绑定。
例如，@racketmodname[racket] 模块中的 @racket[(define cons 1)] 会遮蔽
@racketmodname[racket] 提供的 @racket[cons]。故意遮蔽语言中的绑定通常
并不是什么好主意，特别是 @racket[cons] 这种广泛使用的绑定。
不过遮蔽能够让程序员无须刻意避开语言中每一个隐蔽的绑定。

@; Even identifiers like @racket[define] and @racket[lambda] get their
@; meanings from bindings, though they have @defterm{transformer}
@; bindings (which means that they indicate syntactic forms) instead of
@; value bindings. Since @racket[define] has a transformer binding, the
@; identifier @racketidfont{define} cannot be used by itself to get a
@; value. However, the normal binding for @racketidfont{define} can be
@; shadowed.

即便像 @racket[define] 和 @racket[lambda] 这样的标识符也可通过绑定拥有新的的意义，
虽然它们拥有的是@defterm{变换器}绑定（意思是它们表示语法形式）而非值绑定。
由于 @racket[define] 拥有变换器绑定，因此标识符 @racketidfont{define}
本身无法被用来获取值。然而，@racketidfont{define} 的正常绑定可以被遮蔽。

@examples[
define
(eval:alts (let ([@#,racketidfont{define} 5]) @#,racketidfont{define}) (let ([define 5]) define))
]

@; Again, shadowing standard bindings in this way is rarely a good idea, but the
@; possibility is an inherent part of Racket's flexibility.

再次提醒，用这种方式遮蔽标准绑定通常并不是什么好主意，不过这种能力是
Racket 的灵活性中固有的部分。
