#lang scribble/doc
@(require scribble/manual scribble/eval scribble/bnf racket/list
          "guide-utils.rkt"
          (for-label racket/list))

@(define step @elem{=})

@(define list-eval (make-base-eval))
@(interaction-eval #:eval list-eval (require racket/list))

@; @title{Lists, Iteration, and Recursion}

@title{列表，迭代与递归}

@; Racket is a dialect of the language Lisp, whose name originally stood
@; for ``LISt Processor.'' The built-in list datatype remains a prominent
@; feature of the language.

Racket 是 Lisp 语言的一种方言，Lisp 得名于“LISt Processor（列表处理器）”。
内建的列表数据类型即保留了该语言的显著特征。

@; The @racket[list] function takes any number of values and returns
@; a list containing the values:

@racket[list] 函数接受任意数量的值并返回一个包含这些值的列表：

@interaction[(list "red" "green" "blue")
             (list 1 2 3 4 5)]

@; @margin-note{A list usually prints with @litchar{'}, but the printed
@;              form of a list depends on its content. See
@;              @secref["pairs"] for more information.}

@margin-note{列表通常以 @litchar{'} 打印，不过其打印的形式取决于其内容。
             更多信息见 @secref["pairs"]。}

As you can see, a list result prints in the @tech{REPL} as a quote
@litchar{'} and then a pair of parentheses wrapped around the printed
form of the list elements. There's an opportunity for confusion here,
because parentheses are used for both expressions, such as
@racket[(list "red" "green" "blue")], and printed results, such as
@racketresult['("red" "green" "blue")]. In addition to the quote,
parentheses for results are printed in blue in the documentation and
in DrRacket, whereas parentheses for expressions are brown.

如你所见，@tech{REPL} 中列表的打印结果为一个单引号 @litchar{'}
后跟一对括号括住的列表，列表中的元素则为对应的打印形式。
这里有一点容易混淆的地方：括号被同时用于表达式（如
@racket[(list "red" "green" "blue")]）和打印结果（如
@racketresult['("red" "green" "blue")]）。
不过在文档和 DrRacket 中，带单引号和括号的打印结果会以蓝色显示，
而表达式中的括号则为棕色。

@; Many predefined functions operate on lists. Here are a few examples:

@; @interaction[
@; (code:line (length (list "hop" "skip" "jump"))        (code:comment @#,t{count the elements}))
@; (code:line (list-ref (list "hop" "skip" "jump") 0)    (code:comment @#,t{extract by position}))
@; (list-ref (list "hop" "skip" "jump") 1)
@; (code:line (append (list "hop" "skip") (list "jump")) (code:comment @#,t{combine lists}))
@; (code:line (reverse (list "hop" "skip" "jump"))       (code:comment @#,t{reverse order}))
@; (code:line (member "fall" (list "hop" "skip" "jump")) (code:comment @#,t{check for an element}))
@; ]

Racket 中预定义了很多用于操作列表的函数。下面是一些实例：

@interaction[
(code:line (length (list "hop" "skip" "jump"))        (code:comment @#,t{元素计数}))
(code:line (list-ref (list "hop" "skip" "jump") 0)    (code:comment @#,t{按位置提取元素}))
(list-ref (list "hop" "skip" "jump") 1)
(code:line (append (list "hop" "skip") (list "jump")) (code:comment @#,t{连接列表}))
(code:line (reverse (list "hop" "skip" "jump"))       (code:comment @#,t{反转顺序}))
(code:line (member "fall" (list "hop" "skip" "jump")) (code:comment @#,t{查找成员}))
]

@;------------------------------------------------------------------------
@; @section{Predefined List Loops}

@section{预定义的列表循环}

@; In addition to simple operations like @racket[append], Racket includes
@; functions that iterate over the elements of a list. These iteration
@; functions play a role similar to @racket[for] in Java, Racket, and other
@; languages. The body of a Racket iteration is packaged into a function
@; to be applied to each element, so the @racket[lambda] form becomes
@; particularly handy in combination with iteration functions.

除了像 @racket[append] 这样的简单操作外，Racket 中还包含一些用于迭代列表元素的函数。
迭代函数所扮演的角色类似于 Java、Racket 和其它语言中的 @racket[for] 语句。
由于 Racket 迭代的主体被封装成了应用到每个元素的函数，因此 @racket[lambda]
形式与迭代函数的组合会特别方便。

@; Different list-iteration functions combine iteration results in
@; different ways. The @racket[map] function uses the per-element
@; results to create a new list:

不同的列表迭代函数会以不同的方式组合迭代结果。@racket[map]
函数会使用所有元素的结果创建一个新的列表：

@interaction[
(map sqrt (list 1 4 9 16))
(map (lambda (i)
       (string-append i "!"))
     (list "peanuts" "popcorn" "crackerjack"))
]

@; The @racket[andmap] and @racket[ormap] functions combine the results
@; by @racket[and]ing or @racket[or]ing:

@racket[andmap] 和 @racket[ormap] 函数会通过连续应用 @racket[and] 或
@racket[or] 组合出结果：

@interaction[
(andmap string? (list "a" "b" "c"))
(andmap string? (list "a" "b" 6))
(ormap number? (list "a" "b" 6))
]

@; The @racket[map], @racket[andmap], and @racket[ormap]
@; functions can all handle multiple lists, instead of just a single
@; list. The lists must all have the same length, and the given function
@; must accept one argument for each list:

@racket[map]、@racket[andmap] 和 @racket[ormap] 函数不仅能处理单个列表，
还可以处理多个列表。这些列表的长度必须相同，且给定的函数必须对每个列表接受一个元素：

@interaction[
(map (lambda (s n) (substring s 0 n))
     (list "peanuts" "popcorn" "crackerjack")
     (list 6 3 7))
]

@; The @racket[filter] function keeps elements for which the body result
@; is true, and discards elements for which it is @racket[#f]:

@racket[filter] 函数会保留主体中结果为真的元素，并丢弃主体中结果为 @racket[#f] 的元素：

@interaction[
(filter string? (list "a" "b" 6))
(filter positive? (list 1 -2 6 7 0))
]

@; The @racket[foldl] function generalizes some iteration functions. It
@; uses the per-element function to both process an element and combine
@; it with the ``current'' value, so the per-element function takes an
@; extra first argument. Also, a starting ``current'' value must be
@; provided before the lists:

@racket[foldl] 函数推广了某些迭代函数。它使用一个应用于每个元素
@racket[elem] 的函数来处理元素，并将其结果与“当前值” @racket[v]
相结合，因此应用于每个元素的函数需要一个额外的第一项参数。
此外，初始的“当前值”必须在列表之前提供：

@bold{译注}：@racket[foldl] 的参数分为三部分：第一部分为一个函数 @litchar[proc]，
其参数个数等于要迭代的列表个数加一；第二部分为环境中初始的“当前值” @litchar[init]；
第三部分是一个或多个等长的列表 @litchar[lst ...+]。在本例中，匿名函数的第一个参数
@racket[elem] 会在每次迭代时绑定到列表中的每个元素，而最后一个参数 @racket[v]
则总是会绑定到“当前值”；待第一次迭代结束后，匿名函数的返回值则作为下一次迭代的当前函数，以此类推。
将“当前值”绑定到匿名函数中最后一个参数的做法叫做递延式（Continuation-Passing Style，
旧译为“延续传递风格”）。

@interaction[
(foldl (lambda (elem v)
         (+ v (* elem elem)))
       0
       '(1 2 3))
]

@; Despite its generality, @racket[foldl] is not as popular as the other
@; functions. One reason is that @racket[map], @racket[ormap],
@; @racket[andmap], and @racket[filter] cover the most common kinds of
@; list loops.

尽管 @racket[foldl] 很通用，但它并没有其它函数那么常用。一个原因是
@racket[map]、@racket[ormap]、@racket[andmap] 和 @racket[filter]
已经覆盖了最常见的几种列表循环。

@; Racket provides a general @defterm{list comprehension} form
@; @racket[for/list], which builds a list by iterating through
@; @defterm{sequences}. List comprehensions and related iteration forms
@; are described in @secref["for"].

Racket 提供了一种通用的@defterm{列表推导}形式 @racket[for/list]，
它会通过对@defterm{序列}进行迭代来构建出一个列表。列表推导以及相关的迭代形式见
 @secref["for"]。

@;------------------------------------------------------------------------
@; @section{List Iteration from Scratch}

@section{从零开始构造列表迭代}

@; Although @racket[map] and other iteration functions are predefined, they
@; are not primitive in any interesting sense. You can write equivalent
@; iterations using a handful of list primitives.

尽管 @racket[map] 与其它迭代函数是预定义的，然而它们却并不是原语（Primitive）
因而也没什么趣味。你可以只用很少几个列表的原语就能写出等价的迭代。

@; Since a Racket list is a linked list, the two core operations on a
@; non-empty list are

由于 Racket 的列表是一个链表，而非空列表的两个核心操作为：

@itemize[

@;  @item{@racket[first]: get the first thing in the list; and}

@;  @item{@racket[rest]: get the rest of the list.}

 @item{@racket[first]：获取列表中的第一项}

 @item{@racket[rest]：获取列表中的剩余部分}

]

@examples[
#:eval list-eval
(first (list 1 2 3))
(rest (list 1 2 3))
]

@; To create a new node for a linked list---that is, to add to the front
@; of the list---use the @racket[cons] function, which is short for
@; ``construct.'' To get an empty list to start with, use the
@; @racket[empty] constant:

要为链表创建一个新的节点---即，将节点添加到列表之前---可使用 @racket[cons]
函数，它是“Construct（构造）”的缩写。要从一个空列表开始，请使用 @racket[empty] 常量：

@interaction[
#:eval list-eval
empty
(cons "head" empty)
(cons "dead" (cons "head" empty))
]

@; To process a list, you need to be able to distinguish empty lists from
@; non-empty lists, because @racket[first] and @racket[rest] work only on
@; non-empty lists. The @racket[empty?] function detects empty lists,
@; and @racket[cons?] detects non-empty lists:

要处理一个列表，你需要能够区分空列表和非空列表，因为 @racket[first] 和 @racket[rest]
只能作用于非空列表。@racket[empty?] 函数能够检测非空列表：

@interaction[
#:eval list-eval
(empty? empty)
(empty? (cons "head" empty))
(cons? empty)
(cons? (cons "head" empty))
]

@; With these pieces, you can write your own versions of the
@; @racket[length] function, @racket[map] function, and more.

通过这些代码片段，你可以写出自己的 @racket[length] 和 @racket[map] 等函数。

@defexamples[
#:eval list-eval
(define (my-length lst)
  (cond
   [(empty? lst) 0]
   [else (+ 1 (my-length (rest lst)))]))
(my-length empty)
(my-length (list "a" "b" "c"))
]
@def+int[
#:eval list-eval
(define (my-map f lst)
  (cond
   [(empty? lst) empty]
   [else (cons (f (first lst))
               (my-map f (rest lst)))]))
(my-map string-upcase (list "ready" "set" "go"))
]

@; If the derivation of the above definitions is mysterious to you,
@; consider reading @|HtDP|. If you are merely suspicious of the use
@; of recursive calls instead of a looping construct, then read on.

如果以上派生定义对你而言有些难以理解，可以阅读 @|HtDP|《程序设计方法》。
如果你只是对用递归调用而非循环构造感到疑惑的话，请继续往后阅读。

@;------------------------------------------------------------------------
@; @section[#:tag "tail-recursion"]{Tail Recursion}

@section[#:tag "tail-recursion"]{尾递归}

@; Both the @racket[my-length] and @racket[my-map] functions run in
@; @math{O(n)} space for a list of length @math{n}. This is easy to see by
@; imagining how @racket[(my-length (list "a" "b" "c"))] must evaluate:

对于长度为 @math{n} 的列表来说，函数 @racket[my-length] 和 @racket[my-map]
均会在 @math{O(n)} 的空间中运行。我们只需通过想象就能明白
@racket[(my-length (list "a" "b" "c"))] 的求值方式：

@racketblock[
#||# (my-length (list "a" "b" "c"))
#,step (+ 1 (my-length (list "b" "c")))
#,step (+ 1 (+ 1 (my-length (list "c"))))
#,step (+ 1 (+ 1 (+ 1 (my-length (list)))))
#,step (+ 1 (+ 1 (+ 1 0)))
#,step (+ 1 (+ 1 1))
#,step (+ 1 2)
#,step 3
]

@; For a list with @math{n} elements, evaluation will stack up @math{n}
@; @racket[(+ 1 ...)] additions, and then finally add them up when the
@; list is exhausted.

对于包含 @math{n} 个元素的列表来说，求值会在栈中堆叠 @math{n} 次加法，
直到列表被用尽后才把它们加起来。

@; You can avoid piling up additions by adding along the way. To
@; accumulate a length this way, we need a function that takes both a
@; list and the length of the list seen so far; the code below uses a
@; local function @racket[iter] that accumulates the length in an
@; argument @racket[len]:

你可以通过一路求和来避免加法的堆积。为了按这种方式来累积长度，
我们需要一个函数来接受一个列表和目前已知的长度。以下代码中使用了局部函数
@racket[iter] 在其参数 @racket[len] 中累积长度：

@racketblock[
(define (my-length lst)
  (code:comment @#,t{local function @racket[iter]:})
  (define (iter lst len)
    (cond
     [(empty? lst) len]
     [else (iter (rest lst) (+ len 1))]))
  (code:comment @#,t{body of @racket[my-length] calls @racket[iter]:})
  (iter lst 0))
]

@; Now evaluation looks like this:

现在的求值过程如下：

@racketblock[
#||# (my-length (list "a" "b" "c"))
#,step (iter (list "a" "b" "c") 0)
#,step (iter (list "b" "c") 1)
#,step (iter (list "c") 2)
#,step (iter (list) 3)
3
]

@; The revised @racket[my-length] runs in constant space, just as the
@; evaluation steps above suggest. That is, when the result of a
@; function call, like @racket[(iter (list "b" "c") 1)], is exactly the
@; result of some other function call, like @racket[(iter (list "c")
@; 2)], then the first one doesn't have to wait around for the second
@; one, because that takes up space for no good reason.

修订后的 @racket[my-length] 会在常量空间内运行，正如上面求值步骤所示。
也就是说，如果一个函数调用的结果（@racket[(iter (list "b" "c") 1)]）
刚好为另一个函数调用的结果（@racket[(iter (list "c") 2)]），
那么第一个函数无需等待第二个函数返回，不然会浪费空间。

@; This evaluation behavior is sometimes called @idefterm{tail-call
@; optimization}, but it's not merely an ``optimization'' in Racket; it's
@; a guarantee about the way the code will run. More precisely, an
@; expression in @deftech{tail position} with respect to another
@; expression does not take extra computation space over the other
@; expression.

这种求值行为有时被称作@idefterm{尾递归优化}。不过它在 Racket
中不仅是一种“优化”，还是一种对代码运行方式的保证。更确切地说，
@deftech{尾部}的表达式相对于下一次迭代的尾部表达式来说，
并不会占用额外的计算空间。

@; In the case of @racket[my-map], @math{O(n)} space complexity is
@; reasonable, since it has to generate a result of size
@; @math{O(n)}. Nevertheless, you can reduce the constant factor by
@; accumulating the result list. The only catch is that the accumulated
@; list will be backwards, so you'll have to reverse it at the very end:

@; @margin-note{Attempting to reduce a constant factor like this is
@; usually not worthwhile, as discussed below.}

在 @racket[my-map] 的例子中，@math{O(n)} 的空间复杂度是合理的，
因为它必须生成一个大小为 @math{O(n)} 的结果。不过，
你可以通过累积结果列表来消除常量因子。唯一的问题是累积的列表是反向的，
因此你最后还要将它再反转过来：

@margin-note{如下面所述，试图像这样减少常量因子通常并不值得。}

@racketblock[
(define (my-map f lst)
  (define (iter lst backward-result)
    (cond
     [(empty? lst) (reverse backward-result)]
     [else (iter (rest lst)
                 (cons (f (first lst))
                       backward-result))]))
  (iter lst empty))
]

@; It turns out that if you write

事实证明，如果将它这样写：

@racketblock[
(define (my-map f lst)
  (for/list ([i lst])
    (f i)))
]

那么该函数中的 @racket[for/list] 形式展开后的代码，本质上和局部定义并使用
@racket[iter] 是一样的，区别只是语法上更加方便而已。

@;------------------------------------------------------------------------
@; @section{Recursion versus Iteration}

@section{递归与迭代}

@; The @racket[my-length] and @racket[my-map] examples demonstrate that
@; iteration is just a special case of recursion. In many languages, it's
@; important to try to fit as many computations as possible into
@; iteration form. Otherwise, performance will be bad, and moderately
@; large inputs can lead to stack overflow.  Similarly, in Racket, it is
@; sometimes important to make sure that tail recursion is used to avoid
@; @math{O(n)} space consumption when the computation is easily performed
@; in constant space.

示例 @racket[my-length] 和 @racket[my-map] 表明迭代只是递归的一种特例。
在很多语言中，将计算尽可能写成迭代的形式是十分重要的，否则性能就会变差，
即便不太大的输入也会导致栈溢出。在 Racket 中，当计算易于在常量空间内执行时，
使用尾递归来避免 @math{O(n)} 的空间消耗有时也是十分重要的。

@; At the same time, recursion does not lead to particularly bad
@; performance in Racket, and there is no such thing as stack overflow;
@; you can run out of memory if a computation involves too much context,
@; but exhausting memory typically requires orders of magnitude deeper
@; recursion than would trigger a stack overflow in other
@; languages. These considerations, combined with the fact that
@; tail-recursive programs automatically run the same as a loop, lead
@; Racket programmers to embrace recursive forms rather than avoid them.

与此同时，在 Racket 中递归并不会导致特别差的性能，并且也没有栈溢出这类的事情。
如果计算涉及了太多上下文，那么可能会耗尽内存。不过比起其它会触发栈溢出的语言来，
Racket 通常需要高几个数量级的深度递归才能耗尽内存。由于尾递归程序的运行与循环如出一辙，
再综合以上因素考虑，通常 Racket 程序员会接受递归而非避免它们。

@; Suppose, for example, that you want to remove consecutive duplicates
@; from a list. While such a function can be written as a loop that
@; remembers the previous element for each iteration, a Racket programmer
@; would more likely just write the following:

例如，假设你想从一个列表中移除连续的重复项。虽然此函数可以写成循环的形式，
即在每次迭代时记录上一个元素，不过 Racket 程序员会更倾向于写成如下形式：

@def+int[
#:eval list-eval
(define (remove-dups l)
  (cond
   [(empty? l) empty]
   [(empty? (rest l)) l]
   [else
    (let ([i (first l)])
      (if (equal? i (first (rest l)))
          (remove-dups (rest l))
          (cons i (remove-dups (rest l)))))]))
(remove-dups (list "a" "b" "b" "b" "c" "c"))
]

@; In general, this function consumes @math{O(n)} space for an input
@; list of length @math{n}, but that's fine, since it produces an
@; @math{O(n)} result. If the input list happens to be mostly consecutive
@; duplicates, then the resulting list can be much smaller than
@; @math{O(n)}---and @racket[remove-dups] will also use much less than
@; @math{O(n)} space! The reason is that when the function discards
@; duplicates, it returns the result of a @racket[remove-dups] call
@; directly, so the tail-call ``optimization'' kicks in:

通常，此函数会为长度为 @math{n} 的输入消耗 @math{O(n)} 的空间，
不过这没什么问题，因为它会产生一个 @math{O(n)} 的结果。
如果输入的列表中大部分元素都是重复的，那么其结果列表会比 @math{O(n)}
更小，自然 @racket[remove-dups] 占用的空间也会更少。原因是当函数丢弃重复项时，
它会直接返回调用 @racket[remove-dups] 的结果，因此也就产生了尾调用“优化”的效果：

@racketblock[
#||# (remove-dups (list "a" "b" "b" "b" "b" "b"))
#,step (cons "a" (remove-dups (list "b" "b" "b" "b" "b")))
#,step (cons "a" (remove-dups (list "b" "b" "b" "b")))
#,step (cons "a" (remove-dups (list "b" "b" "b")))
#,step (cons "a" (remove-dups (list "b" "b")))
#,step (cons "a" (remove-dups (list "b")))
#,step (cons "a" (list "b"))
#,step (list "a" "b")
]

@; ----------------------------------------------------------------------

@close-eval[list-eval]
