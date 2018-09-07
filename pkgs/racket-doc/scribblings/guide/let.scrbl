#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "let"]{Local Binding}

@title[#:tag "let"]{局部绑定}

@; Although internal @racket[define]s can be used for local binding,
@; Racket provides three forms that give the programmer more
@; control over bindings: @racket[let], @racket[let*], and
@; @racket[letrec].

尽管 @racket[define] 内部定义可用于局部绑定，然而 Racket 还提供了三种形式，
赋予了程序员比绑定更多的控制能力：@racket[let]、@racket[let*] 和 @racket[letrec]。

@;------------------------------------------------------------------------
@; @section{Parallel Binding: @racket[let]}

@section{平行绑定：@racket[let]}

@refalso["let"]{@racket[let]}

@; A @racket[let] form binds a set of identifiers, each to the result of
@; some expression, for use in the @racket[let] body:

@racket[let] 形式将多个标识符绑定到一些表达式的结果上以便在 @racket[let]
的主体中使用：

@specform[(let ([id expr] ...) body ...+)]{}

@; The @racket[_id]s are bound ``in parallel.'' That is, no @racket[_id]
@; is bound in the right-hand side @racket[_expr] for any @racket[_id],
@; but all are available in the @racket[_body]. The @racket[_id]s must be
@; different from each other.

@racket[_id] 是“平行绑定”的，即没有任何 @racket[_id] 会作为右边的 @racket[_expr]
被绑定到某个 @racket[_id] 上。不过所有的 @racket[_id] 在 @racket[_body] 中均可用。
@racket[_id] 之间必须互不相同。

@examples[
(let ([me "Bob"])
  me)
(let ([me "Bob"]
      [myself "Robert"]
      [I "Bobby"])
  (list me myself I))
(let ([me "Bob"]
      [me "Robert"])
  me)
]

@; The fact that an @racket[_id]'s @racket[_expr] does not see its own
@; binding is often useful for wrappers that must refer back to the old
@; value:
@;
@; @interaction[
@; (let ([+ (lambda (x y)
@;            (if (string? x)
@;                (string-append x y)
@;                (+ x y)))]) (code:comment @#,t{use original @racket[+]})
@;   (list (+ 1 2)
@;         (+ "see" "saw")))
@; ]

@racket[_id] 的 @racket[_expr] 无法看到其自己的绑定这一事实，
通常对于必须引用旧有值的包裹体来说很有用：

@interaction[
(let ([+ (lambda (x y)
           (if (string? x)
               (string-append x y)
               (+ x y)))]) (code:comment @#,t{使用原始的 @racket[+]})
  (list (+ 1 2)
        (+ "see" "saw")))
]

@; Occasionally, the parallel nature of @racket[let] bindings is
@; convenient for swapping or rearranging a set of bindings:

有时，@racket[let] 绑定的平行性质对于交换或重排一些绑定来说也很方便：

@interaction[
(let ([me "Tarzan"]
      [you "Jane"])
  (let ([me you]
        [you me])
    (list me you)))
]

@; The characterization of @racket[let] bindings as ``parallel'' is not
@; meant to imply concurrent evaluation. The @racket[_expr]s are
@; evaluated in order, even though the bindings are delayed until all
@; @racket[_expr]s are evaluated.

@racket[let] 绑定的“平行性”并不意味着它隐含了并发求值。@racket[_expr]
会按照顺序求值，即便绑定过程会推迟到所有 @racket[_expr] 求值完毕。

@;------------------------------------------------------------------------
@; @section{Sequential Binding: @racket[let*]}

@section{顺序绑定：@racket[let*]}

@refalso["let"]{@racket[let*]}

@; The syntax of @racket[let*] is the same as @racket[let]:

@racket[let*] 的语法与 @racket[let] 相同：

@specform[(let* ([id expr] ...) body ...+)]{}

@; The difference is that each @racket[_id] is available for use in later
@; @racket[_expr]s, as well as in the @racket[_body]. Furthermore, the
@; @racket[_id]s need not be distinct, and the most recent binding is the
@; visible one.

不同之处在于每个 @racket[_id] 都可以在后续的 @racket[_expr] 中使用，@racket[_body]
亦同。此外，@racket[_id] 可以相同，其中最近的绑定是可见的。

@examples[
(let* ([x (list "Burroughs")]
       [y (cons "Rice" x)]
       [z (cons "Edgar" y)])
  (list x y z))
(let* ([name (list "Burroughs")]
       [name (cons "Rice" name)]
       [name (cons "Edgar" name)])
  name)
]

@; In other words, a @racket[let*] form is equivalent to nested
@; @racket[let] forms, each with a single binding:

换句话说，@racket[let*] 形式等价于嵌套的 @racket[let] 形式，每层都只有一个绑定：

@interaction[
(let ([name (list "Burroughs")])
  (let ([name (cons "Rice" name)])
    (let ([name (cons "Edgar" name)])
      name)))
]

@;------------------------------------------------------------------------
@; @section{Recursive Binding: @racket[letrec]}

@section{递归绑定：@racket[letrec]}

@refalso["let"]{@racket[letrec]}

@; The syntax of @racket[letrec] is also the same as @racket[let]:

@racket[letrec] 的语法也与 @racket[let] 相同：

@specform[(letrec ([id expr] ...) body ...+)]{}

@; While @racket[let] makes its bindings available only in the
@; @racket[_body]s, and @racket[let*] makes its bindings available to any
@; later binding @racket[_expr], @racket[letrec] makes its bindings
@; available to all other @racket[_expr]s---even earlier ones. In other
@; words, @racket[letrec] bindings are recursive.

@racket[let] 的绑定只在 @racket[_body] 中可用，@racket[let*]
的绑定可在任何之后的 @racket[_expr] 绑定中可用，而 @racket[letrec]
的绑定对于所有其它 @racket[_expr] 来说均可用，即便前面的也是。换句话说，
@racket[letrec] 绑定是递归的。

@; The @racket[_expr]s in a @racket[letrec] form are most often
@; @racket[lambda] forms for recursive and mutually recursive functions:

@racket[letrec] 形式中的 @racket[_expr] 最常用 @racket[lambda]
形式来表示递归或互递归函数。

@interaction[
(letrec ([swing
          (lambda (t)
            (if (eq? (car t) 'tarzan)
                (cons 'vine
                      (cons 'tarzan (cddr t)))
                (cons (car t)
                      (swing (cdr t)))))])
  (swing '(vine tarzan vine vine)))
]

@interaction[
(letrec ([tarzan-near-top-of-tree?
          (lambda (name path depth)
            (or (equal? name "tarzan")
                (and (directory-exists? path)
                     (tarzan-in-directory? path depth))))]
         [tarzan-in-directory?
          (lambda (dir depth)
            (cond
              [(zero? depth) #f]
              [else
               (ormap
                (λ (elem)
                  (tarzan-near-top-of-tree? (path-element->string elem)
                                            (build-path dir elem)
                                            (- depth 1)))
                (directory-list dir))]))])
  (tarzan-near-top-of-tree? "tmp"
                            (find-system-path 'temp-dir)
                            4))
]

@; While the @racket[_expr]s of a @racket[letrec] form are typically
@; @racket[lambda] expressions, they can be any expression. The
@; expressions are evaluated in order, and after each value is obtained,
@; it is immediately associated with its corresponding @racket[_id]. If
@; an @racket[_id] is referenced before its value is ready, an
@; error is raised, just as for internal definitions.

尽管 @racket[letrec] 中的 @racket[_expr] 通常为 @racket[lambda] 表达式，
然而它们实际上可以是任何表达式。表达式按顺序求值，在得到所有的值后，
它们会立即被关联到与其对应的 @racket[_id]。若某个 @racket[_id]
在其值就绪前被引用，那么就会触发一个错误，就像内部定义中的那样。

@interaction[
(letrec ([quicksand quicksand])
  quicksand)
]

@; ----------------------------------------
@include-section["named-let.scrbl"]

@; ----------------------------------------
@; @section{Multiple Values: @racket[let-values], @racket[let*-values], @racket[letrec-values]}

@section{多值绑定：@racket[let-values]、@racket[let*-values] 与 @racket[letrec-values]}

@; @refalso["let"]{multiple-value binding forms}

@refalso["let"]{多值绑定形式}

@; In the same way that @racket[define-values] binds multiple
@; results in a definition (see @secref["multiple-values"]),
@; @racket[let-values], @racket[let*-values], and
@; @racket[letrec-values] bind multiple results locally.

和 @racket[define-values] 在定义中绑定多个结果（见 @secref["multiple-values"]）
一样，@racket[let-values]、@racket[let*-values] 和 @racket[letrec-values]
也按照同样的方式局部地绑定多个结果。

@specform[(let-values ([(id ...) expr] ...)
            body ...+)]
@specform[(let*-values ([(id ...) expr] ...)
            body ...+)]
@specform[(letrec-values ([(id ...) expr] ...)
            body ...+)]

@; Each @racket[_expr] must produce as many values as corresponding
@; @racket[_id]s. The binding rules are the same for the forms
@; without @racketkeywordfont{-values} forms: the @racket[_id]s of
@; @racket[let-values] are bound only in the @racket[_body]s, the
@; @racket[_id]s of @racket[let*-values]s are bound in
@; @racket[_expr]s of later clauses, and the @racket[_id]s of
@; @racket[letrec-value]s are bound for all @racket[_expr]s.

每个 @racket[_expr] 产生的值的数量都必须与 @racket[_id] 相对应。
这些形式的绑定规则与不带 @racketkeywordfont{-values} 的形式相同：
@racket[let-values] 的 @racket[_id] 只在 @racket[_body] 中绑定，
@racket[let*-values] 的 @racket[_id] 可在后面从句的 @racket[_expr]
中绑定，而 @racket[letrec-value] 的 @racket[_id] 可在所有的 @racket[_expr]
中绑定。

@examples[
(let-values ([(q r) (quotient/remainder 14 3)])
  (list q r))
]
