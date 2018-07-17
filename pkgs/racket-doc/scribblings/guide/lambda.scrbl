#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@(define greet-eval (make-base-eval))

@; @title[#:tag "lambda"]{Functions@aux-elem{ (Procedures)}: @racket[lambda]}

@title[#:tag "lambda"]{函数@aux-elem{（过程）}：@racket[lambda]}

@; A @racket[lambda] expression creates a function. In the simplest
@; case, a @racket[lambda] expression has the form

@racket[lambda] 表达式用于创建函数。@racket[lambda] 表达式的最简形式为

@specform[
(lambda (arg-id ...)
  body ...+)
]

@; A @racket[lambda] form with @math{n} @racket[_arg-id]s accepts
@; @math{n} arguments:

带有 @math{n} 个 @racket[_arg-id] 的 @racket[lambda] 形式接受 @math{n} 个参数：

@interaction[
((lambda (x) x)
 1)
((lambda (x y) (+ x y))
 1 2)
((lambda (x y) (+ x y))
 1)
]

@;------------------------------------------------------------------------
@; @section[#:tag "rest-args"]{Declaring a Rest Argument}

@section[#:tag "rest-args"]{声明剩余参数}

@; A @racket[lambda] expression can also have the form

@racket[lambda] 表达式可拥有形式

@specform[
(lambda rest-id
  body ...+)
]

@; That is, a @racket[lambda] expression can have a single
@; @racket[_rest-id] that is not surrounded by parentheses. The resulting
@; function accepts any number of arguments, and the arguments are put
@; into a list bound to @racket[_rest-id].

即，@racket[lambda] 表达式可拥有单个没有括号括住的 @racket[_rest-id]。
其结果函数接受任意数量的参数，这些参数会作为列表绑定到 @racket[_rest-id]。

@examples[
((lambda x x)
 1 2 3)
((lambda x x))
((lambda x (car x))
 1 2 3)
]

@; Functions with a @racket[_rest-id] often use @racket[apply] to call
@; another function that accepts any number of arguments.

@; @guideother{@secref["apply"] describes @racket[apply].}

带有 @racket[_rest-id] 的函数通常使用 @racket[apply]
来调用另一个接受任意数量参数的函数。

@guideother{@secref["apply"] 中描述了 @racket[apply]。}

@defexamples[
(define max-mag
  (lambda nums
    (apply max (map magnitude nums))))

(max 1 -2 0)
(max-mag 1 -2 0)
]

@; The @racket[lambda] form also supports required arguments combined
@; with a @racket[_rest-id]:

@racket[lambda] 形式也支持所需参数与 @racket[_rest-id] 结合的形式：

@specform[
(lambda (arg-id ...+ . rest-id)
  body ...+)
]

@; The result of this form is a function that requires at least as many
@; arguments as @racket[_arg-id]s, and also accepts any number of
@; additional arguments.

此形式的结果是一个函数，该函数需要的参数量至少与 @racket[_arg-id] 一样多，
此外它还介绍任意数量的附加参数。

@defexamples[
(define max-mag
  (lambda (num . nums)
    (apply max (map magnitude (cons num nums)))))

(max-mag 1 -2 0)
(max-mag)
]

@; A @racket[_rest-id] variable is sometimes called a @deftech{rest
@; argument}, because it accepts the ``rest'' of the function arguments.

变量 @racket[_rest-id] 有时被称作@deftech{剩余参数}，因为它接受函数参数的
“剩余”部分。

@;------------------------------------------------------------------------
@; @section{Declaring Optional Arguments}

@section{声明可选参数}

@; Instead of just an identifier, an argument (other than a rest
@; argument) in a @racket[lambda] form can be specified with an
@; identifier and a default value:

@racket[lambda] 形式中除剩余参数外的参数不仅可以只有标识符，
还可以有指定了默认值的标识符。

@specform/subs[
(lambda gen-formals
  body ...+)
([gen-formals (arg ...)
              rest-id
              (arg ...+ . rest-id)]
 [arg arg-id
      [arg-id default-expr]])
]{}

@; An argument of the form @racket[[arg-id default-expr]] is
@; optional. When the argument is not supplied in an application,
@; @racket[_default-expr] produces the default value. The
@; @racket[_default-expr] can refer to any preceding @racket[_arg-id],
@; and every following @racket[_arg-id] must have a default as well.

形式 @racket[[arg-id default-expr]] 的参数是可选的。当在一次应用中该参数并未提供时，
@racket[_default-expr] 就会产生默认的值。@racket[_default-expr] 中可引用前面的任何
@racket[_arg-id]，而任何之后的 @racket[_arg-id] 也都必须拥有默认值。

@defexamples[
(define greet
  (lambda (given [surname "Smith"])
    (string-append "Hello, " given " " surname)))

(greet "John")
(greet "John" "Doe")
]

@def+int[
(define greet
  (lambda (given [surname (if (equal? given "John")
                              "Doe"
                              "Smith")])
    (string-append "Hello, " given " " surname)))

(greet "John")
(greet "Adam")
]

@; @section[#:tag "lambda-keywords"]{Declaring Keyword Arguments}

@section[#:tag "lambda-keywords"]{声明关键字参数}

@; A @racket[lambda] form can declare an argument to be passed by
@; keyword, instead of position. Keyword arguments can be mixed with
@; by-position arguments, and default-value expressions can be supplied
@; for either kind of argument:

@; @guideother{@secref["keyword-args"] introduces function
@; calls with keywords.}

@racket[lambda] 形式中可声明按关键字而非位置传入的参数。
关键字参数可与位置固定的参数混合使用，默认值表达式则均支持二者：

@guideother{@secref["keyword-args"] 中介绍了带关键字的函数调用。}

@specform/subs[
(lambda gen-formals
  body ...+)
([gen-formals (arg ...)
              rest-id
              (arg ...+ . rest-id)]
 [arg arg-id
      [arg-id default-expr]
      (code:line arg-keyword arg-id)
      (code:line arg-keyword [arg-id default-expr])])
]{}

@; An argument specified as @racket[(code:line _arg-keyword _arg-id)] is
@; supplied by an application using the same @racket[_arg-keyword].  The
@; position of the keyword--identifier pair in the argument list does not
@; matter for matching with arguments in an application, because it will
@; be matched to an argument value by keyword instead of by position.

用 @racket[(code:line _arg-keyword _arg-id)] 指定的参数也被使用同样
@racket[_arg-keyword] 的应用所支持。在参数列表中，
成对的关键字-标识符的位置对于应用中参数的匹配来说无关紧要，
因为它会按照关键字而非位置与参数值像匹配。

@def+int[
(define greet
  (lambda (given #:last surname)
    (string-append "Hello, " given " " surname)))

(greet "John" #:last "Smith")
(greet #:last "Doe" "John")
]

@; An @racket[(code:line _arg-keyword [_arg-id _default-expr])] argument
@; specifies a keyword-based argument with a default value.

@racket[(code:line _arg-keyword [_arg-id _default-expr])]
参数会根据默认值指定基于关键字的参数。

@defexamples[
#:eval greet-eval
(define greet
  (lambda (#:hi [hi "Hello"] given #:last [surname "Smith"])
    (string-append hi ", " given " " surname)))

(greet "John")
(greet "Karl" #:last "Marx")
(greet "John" #:hi "Howdy")
(greet "Karl" #:last "Marx" #:hi "Guten Tag")
]

@; The @racket[lambda] form does not directly support the creation
@; of a function that accepts ``rest'' keywords. To construct a
@; function that accepts all keyword arguments, use
@; @racket[make-keyword-procedure]. The function supplied to
@; @racket[make-keyword-procedure] receives keyword arguments
@; through parallel lists in the first two (by-position) arguments,
@; and then all by-position arguments from an application as the
@; remaining by-position arguments.

@; @guideother{@secref["apply"] introduces @racket[keyword-apply].}

@racket[lambda] 形式并不直接支持创建接受“剩余”关键字的函数。
要构造接受所有关键字参数的函数，请使用 @racket[make-keyword-procedure]。提供给
@racket[make-keyword-procedure]
的函数通过前两个平行的位置固定参数列表接收关键字参数，
之后该应用中所有位置固定的参数都会作为剩余的位置固定的参数。

@guideother{@secref["apply"] 介绍了 @racket[keyword-apply]。}

@defexamples[
#:eval greet-eval
(define (trace-wrap f)
  (make-keyword-procedure
   (lambda (kws kw-args . rest)
     (printf "Called with ~s ~s ~s\n" kws kw-args rest)
     (keyword-apply f kws kw-args rest))))
((trace-wrap greet) "John" #:hi "Howdy")
]

@; @refdetails["lambda"]{function expressions}

@refdetails["lambda"]{函数表达式}

@;------------------------------------------------------------------------
@; @section[#:tag "case-lambda"]{Arity-Sensitive Functions: @racket[case-lambda]}

@section[#:tag "case-lambda"]{参数量敏感的函数：@racket[case-lambda]}

@; The @racket[case-lambda] form creates a function that can have
@; completely different behaviors depending on the number of arguments
@; that are supplied. A case-lambda expression has the form

@racket[case-lambda] 形式可创建根据支持的参数量的不同，拥有完全不同行为的函数。
@racket[case-lambda] 表达式的形式为

@specform/subs[
(case-lambda
  [formals body ...+]
  ...)
([formals (arg-id ...)
          rest-id
          (arg-id ...+ . rest-id)])
]

@; where each @racket[[_formals _body ...+]] is analogous to @racket[(lambda
@; _formals _body ...+)]. Applying a function produced by
@; @racket[case-lambda] is like applying a @racket[lambda] for the first
@; case that matches the number of given arguments.

其中每个 @racket[[_formals _body ...+]] 都类似于 @racket[(lambda
_formals _body ...+)]。应用由 @racket[case-lambda]
产生的函数类似于将 @racket[lambda] 应用到与给定参数量相匹配的第一个分支。

@defexamples[
(define greet
  (case-lambda
    [(name) (string-append "Hello, " name)]
    [(given surname) (string-append "Hello, " given " " surname)]))

(greet "John")
(greet "John" "Smith")
(greet)
]

@; A @racket[case-lambda] function cannot directly support optional or
@; keyword arguments.

@racket[case-lambda] 函数无法直接支持可选参数或关键字参数。

@; ----------------------------------------------------------------------

@close-eval[greet-eval]
