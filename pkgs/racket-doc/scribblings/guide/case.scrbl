#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt"
          (for-label racket/match))

@title[#:tag "case"]{简单分派：@racket[case]}

@; The @racket[case] form dispatches to a clause by matching the result
@; of an expression to the values for the clause:

@racket[case] 形式通过匹配一个表达式的结果和某个从句的值来分派到该从句：

@specform[(case expr
            [(datum ...+) body ...+]
            ...)]

@; Each @racket[_datum] will be compared to the result of @racket[_expr]
@; using @racket[equal?], and then the corresponding @racket[body]s are
@; evaluated. The @racket[case] form can dispatch to the correct clause
@; in @math{O(log N)} time for @math{N} @racket[datum]s.

每个 @racket[_datum] 都会使用 @racket[equal?] 与 @racket[_expr] 的结果相比较，
之后其对应的 @racket[body] 就会被求值。@racket[case] 形式可以在 @math{O(log N)}
的时间内从 @math{N} 个 @racket[datum] 中分派到正确的从句。

@; Multiple @racket[_datum]s can be supplied for each clause, and the
@; corresponding @racket[_body]s are evaluated if any of the
@; @racket[_datum]s match.

每个从句可支持多个 @racket[_datum]，其对应的 @racket[_body] 会在任何
@racket[_datum] 被匹配到时求值。

@examples[
(let ([v (random 6)])
  (printf "~a\n" v)
  (case v
    [(0) 'zero]
    [(1) 'one]
    [(2) 'two]
    [(3 4 5) 'many]))
]

@; The last clause of a @racket[case] form can use @racket[else], just
@; like @racket[cond]:

@racket[case] 形式的最后一个从句可使用 @racket[else]，与 @racket[cond] 类似：

@examples[
(case (random 6)
  [(0) 'zero]
  [(1) 'one]
  [(2) 'two]
  [else 'many])
]

@; For more general pattern matching (but without the dispatch-time
@; guarantee), use @racket[match], which is introduced in
@; @secref["match"].

对于更加通用的模式匹配（但没有分派时间的保证），请使用 @racket[match]
它在 @secref["match"] 中有所介绍。
