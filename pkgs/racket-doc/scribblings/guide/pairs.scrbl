#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "pairs"]{Pairs and Lists}

@title[#:tag "pairs"]{序对与列表}

@; A @deftech{pair} joins two arbitrary values. The @racket[cons]
@; procedure constructs pairs, and the @racket[car] and @racket[cdr]
@; procedures extract the first and second elements of the pair,
@; respectively. The @racket[pair?] predicate recognizes pairs.

@deftech{序对}将两个任意值联结到一起。过程 @racket[cons] 用于构造序对，
过程 @racket[car] 和 @racket[cdr] 分别用于提取序对中的第一个和第二个元素。
谓语 @racket[pair?] 用于识别序对。

@; Some pairs print by wrapping parentheses around the printed forms of
@; the two pair elements, putting a @litchar{'} at the beginning and a
@; @litchar{.} between the elements.

一些序对的打印形式即为：元素本身的打印形式用括号括住，前面有个 @litchar{'}，
元素之间有个 @litchar{.}。

@examples[
(cons 1 2)
(cons (cons 1 2) 3)
(car (cons 1 2))
(cdr (cons 1 2))
(pair? (cons 1 2))
]

@; A @deftech{list} is a combination of pairs that creates a linked
@; list. More precisely, a list is either the empty list @racket[null],
@; or it is a pair whose first element is a list element and whose second
@; element is a list. The @racket[list?] predicate recognizes lists. The
@; @racket[null?]  predicate recognizes the empty list.

@deftech{列表}是将序对组合在一起的链表。确切来说，列表要么是空表 @racket[null]，
要么就是第一个元素为列表元素，第二元素为列表的序对。谓语 @racket[list?]
用于识别列表。谓语 @racket[null?] 用于识别空表。

@; A list normally prints as a @litchar{'} followed by a pair of parentheses
@; wrapped around the list elements.

列表通常打印为 @litchar{'} 后跟用一对括号括住的列表元素。

@examples[
null
(cons 0 (cons 1 (cons 2 null)))
(list? null)
(list? (cons 1 (cons 2 null)))
(list? (cons 1 2))
]

@; A list or pair prints using @racketresult[list] or @racketresult[cons]
@; when one of its elements cannot be written as a @racket[quote]d
@; value. For example, a value constructed with @racket[srcloc] cannot be
@; written using @racket[quote], and it prints using @racketresult[srcloc]:

当列表或序对中存在无法写成 @racket[quote] 引述形式的元素时，其打印结果就会使用
@racketresult[list] 或 @racketresult[cons]。例如，用 @racket[srcloc] 构造的值无法写成
@racket[quote] 引述的形式，因此它会使用 @racketresult[srcloc] 来打印：

@interaction[
(srcloc "file.rkt" 1 0 1 (+ 4 4))
(list 'here (srcloc "file.rkt" 1 0 1 8) 'there)
(cons 1 (srcloc "file.rkt" 1 0 1 8))
(cons 1 (cons 2 (srcloc "file.rkt" 1 0 1 8)))
]

@; @margin-note{See also @racket[list*].}

@margin-note{另见 @racket[list*]。}

@; As shown in the last example, @racketresult[list*] is used to
@; abbreviate a series of @racketresult[cons]es that cannot be
@; abbreviated using @racketresult[list].

如最后一例所示，无法用 @racketresult[list] 缩写的一系列 @racketresult[cons]
会用 @racketresult[list*] 来缩写：

@; The @racket[write] and @racket[display] functions print a pair or list
@; without a leading @litchar{'}, @racketresult[cons],
@; @racketresult[list], or @racketresult[list*]. There is no difference
@; between @racket[write] and @racket[display] for a pair or list, except
@; as they apply to elements of the list:

函数 @racket[write] 和 @racket[display] 会将序对或列表打印为不带前导
@litchar{'}、@racketresult[cons]、@racketresult[list] 或 @racketresult[list*]
的形式。对于序对或列表来说，@racket[write] 和 @racket[display]
除了是否会应用于列表中的元素外并无任何区别：

@examples[
(write (cons 1 2))
(display (cons 1 2))
(write null)
(display null)
(write (list 1 2 "3"))
(display (list 1 2 "3"))
]

@; Among the most important predefined procedures on lists are those that
@; iterate through the list's elements:

列表上的最重要的预定义过程都会对列表中的元素进行迭代：

@interaction[
(map (lambda (i) (/ 1 i))
     '(1 2 3))
(andmap (lambda (i) (i . < . 3))
       '(1 2 3))
(ormap (lambda (i) (i . < . 3))
       '(1 2 3))
(filter (lambda (i) (i . < . 3))
        '(1 2 3))
(foldl (lambda (v i) (+ v i))
       10
       '(1 2 3))
(for-each (lambda (i) (display i))
          '(1 2 3))
(member "Keys"
        '("Florida" "Keys" "U.S.A."))
(assoc 'where
       '((when "3:30") (where "Florida") (who "Mickey")))
]

@; @refdetails["pairs"]{pairs and lists}

@refdetails["pairs"]{序对与列表}

@; Pairs are immutable (contrary to Lisp tradition), and @racket[pair?]
@; and @racket[list?] recognize immutable pairs and lists, only. The
@; @racket[mcons] procedure creates a @deftech{mutable pair}, which works
@; with @racket[set-mcar!] and @racket[set-mcdr!], as well as
@; @racket[mcar] and @racket[mcdr]. A mutable pair prints using
@; @racketresult[mcons], while @racket[write] and @racket[display] print
@; mutable pairs with @litchar["{"] and @litchar["}"]:

与传统的 Lisp 不同，Racket 中的序对是不可变的，@racket[pair?] 和 @racket[list?]
也只会识别不可变的序对和列表。过程 @racket[mcons] 用于创建 @deftech{可变序对}，
它可与 @racket[set-mcar!] 和 @racket[set-mcdr!]，以及 @racket[mcar] 和 @racket[mcdr]
协同工作。可变序对使用 @racketresult[mcons] 打印，而 @racket[write] 和 @racket[display]
会将可变序对打印为带有 @litchar["{"] 和 @litchar["}"] 的形式：

@examples[
(define p (mcons 1 2))
p
(pair? p)
(mpair? p)
(set-mcar! p 0)
p
(write p)
]

@; @refdetails["mpairs"]{mutable pairs}

@refdetails["mpairs"]{可变序对}
