#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@(define param-eval (make-base-eval))

@; @title[#:tag "parameterize"]{Dynamic Binding: @racket[parameterize]}

@title[#:tag "parameterize"]{动态绑定：@racket[parameterize]}

@refalso["parameters"]{@racket[parameterize]}

@; The @racket[parameterize] form associates a new value with a
@; @deftech{parameter} during the evaluation of @racket[_body]
@; expressions:

@racket[parameterize] 形式会在 @racket[_body] 表达式求值时将一个新值与一个
@deftech{参量}相关联：

@specform[(parameterize ([parameter-expr value-expr] ...)
            body ...+)]

@; @margin-note{The term ``parameter'' is sometimes used to refer to the
@;              arguments of a function, but ``parameter'' in Racket
@;              has the more specific meaning described here.}

@margin-note{术语“参量（Parameter）”有时也用来指代函数的参数，不过这里描述的 Racket
中的“参量”拥有更加特定的意思。}

@; For example, the @racket[error-print-width] parameter controls how
@; many characters of a value are printed in an error message:

例如 @racket[error-print-width] 参量用于控制错误信息中打印的字符个数：

@interaction[
(parameterize ([error-print-width 5])
  (car (expt 10 1024)))
(parameterize ([error-print-width 10])
  (car (expt 10 1024)))
]

@; More generally, parameters implement a kind of dynamic binding. The
@; @racket[make-parameter] function takes any value and returns a new
@; parameter that is initialized to the given value. Applying the
@; parameter as a function returns its current value:

更一般地说，参量实现了一种动态绑定。@racket[make-parameter] 函数接受任何值并返回
一个新的以给定值初始化的参量。将参量作为函数来应用会返回其当前值：

@interaction[
#:eval param-eval
(define location (make-parameter "here"))
(location)
]

@; In a @racket[parameterize] form, each @racket[_parameter-expr] must
@; produce a parameter. During the evaluation of the @racket[body]s, each
@; specified parameter is given the result of the corresponding
@; @racket[_value-expr]. When control leaves the @racket[parameterize]
@; form---either through a normal return, an exception, or some other
@; escape---the parameter reverts to its earlier value:

在 @racket[parameterize] 形式中，每个 @racket[_parameter-expr] 必须产生一个参量。
在 @racket[body] 的求值过程中，每一个具体的参量都会被给定其对应
@racket[_value-expr] 的结果。当控制流离开 @racket[parameterize] 形式---通过正常的返回、异常，或其它方式退出时---参量会恢复期之前的值：

@interaction[
#:eval param-eval
(parameterize ([location "there"])
  (location))
(location)
(parameterize ([location "in a house"])
  (list (location)
        (parameterize ([location "with a mouse"])
          (location))
        (location)))
(parameterize ([location "in a box"])
  (car (location)))
(location)
]

@; The @racket[parameterize] form is not a binding form like
@; @racket[let]; each use of @racket[location] above refers directly to
@; the original definition. A @racket[parameterize] form adjusts the
@; value of a parameter during the whole time that the
@; @racket[parameterize] body is evaluated, even for uses of the
@; parameter that are textually outside of the @racket[parameterize]
@; body:

@racket[parameterize] 形式并不是像 @racket[let] 那样的绑定形式。前面每次使用
@racket[location] 都直接引用了其原始定义。@racket[parameterize] 形式会在整个
@racket[parameterize] 主体的求值过程中调整参量的值，即便对文本上在
@racket[parameterize] 之外的参量也是如此：

@interaction[
#:eval param-eval
(define (would-you-could-you?)
  (and (not (equal? (location) "here"))
       (not (equal? (location) "there"))))

(would-you-could-you?)
(parameterize ([location "on a bus"])
  (would-you-could-you?))
]

@; If a use of a parameter is textually inside the body of a
@; @racket[parameterize] but not evaluated before the
@; @racket[parameterize] form produces a value, then the use does not see
@; the value installed by the @racket[parameterize] form:

如果一个参量从文本上看在 @racket[parameterize] 的主体中使用，但并未在
@racket[parameterize] 形式产生一个值之前求值，那么该次使用并不会观测到
@racket[parameterize] 为它设置的值：

@interaction[
#:eval param-eval
(let ([get (parameterize ([location "with a fox"])
             (lambda () (location)))])
  (get))
]

@; The current binding of a parameter can be adjusted imperatively by
@; calling the parameter as a function with a value. If a
@; @racket[parameterize] has adjusted the value of the parameter, then
@; directly applying the parameter procedure affects only the value
@; associated with the active @racket[parameterize]:

参量的当前绑定可通过将该参量作为函数调用并传入一个值来命令式地调整。若一个
@racket[parameterize] 已经调整了参量的值，那么直接应用该参量过程只会影响与活动的
@racket[parameterize] 相关联的值。

@interaction[
#:eval param-eval
(define (try-again! where)
  (location where))

(location)
(parameterize ([location "on a train"])
  (list (location)
        (begin (try-again! "in a boat")
               (location))))
(location)
]

@; Using @racket[parameterize] is generally preferable to updating a
@; parameter value imperatively---for much the same reasons that binding
@; a fresh variable with @racket[let] is preferable to using
@; @racket[set!]  (see @secref["set!"]).

通常使用 @racket[parameterize] 是命令式地更新参量值的更好的方式。
而要更新用 @racket[let] 绑定的全新的变量则更适合使用
@racket[set!]（见 @secref["set!"]）。

@; It may seem that variables and @racket[set!] can solve many of the
@; same problems that parameters solve. For example, @racket[lokation]
@; could be defined as a string, and @racket[set!] could be used
@; to adjust its value:

很多参量可以解决的问题，用变量和 @racket[set!] 似乎同样可以解决。例如
@racket[lokation] 可以定义为字符串，而 @racket[set!] 可用于调整其值：

@interaction[
#:eval param-eval
(define lokation "here")

(define (would-ya-could-ya?)
  (and (not (equal? lokation "here"))
       (not (equal? lokation "there"))))

(set! lokation "on a bus")
(would-ya-could-ya?)
]

@; Parameters, however, offer several crucial advantages over
@; @racket[set!]:

然而，参量提供了比几点 @racket[set!] 更重要的优势：

@itemlist[

@;  @item{The @racket[parameterize] form helps automatically reset the
@;        value of a parameter when control escapes due to an exception.
@;        Adding exception handlers and other forms to rewind a
@;        @racket[set!] is relatively tedious.}

 @item{@racket[parameterize] 形式能够在控制流因异常而退出时帮助自动重置参量的值。
       添加异常处理和其它形式来撤销 @racket[set!] 的作为相对更加繁琐些。}

@;  @item{Parameters work nicely with tail calls (see
@;        @secref["tail-recursion"]). The last @racket[_body] in a
@;        @racket[parameterize] form is in @tech{tail position} with
@;        respect to the @racket[parameterize] form.}

 @item{参量可以和尾调用很好地配合（见 @secref["tail-recursion"]）。
       @racket[parameterize] 形式中的最后一个 @racket[_body]
       即在其对应 @racket[parameterize] 形式的@tech{尾部}。}

@;  @item{Parameters work properly with threads (see
@;        @refsecref["threads"]). The @racket[parameterize] form adjusts
@;        the value of a parameter only for evaluation in the current
@;        thread, which avoids race conditions with other threads.}

 @item{参量也可以和线程协同工作（见 @refsecref["threads"]）。
       @racket[parameterize] 形式只会为当前线程中的求值调整参量的值，
       这样可以避免和其它线程的竞争条件。}

]

@; ----------------------------------------

@close-eval[param-eval]
