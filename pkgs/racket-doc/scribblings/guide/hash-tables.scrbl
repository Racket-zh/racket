#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "hash-tables"]{Hash Tables}

@title[#:tag "hash-tables"]{散列表}

@; A @deftech{hash table} implements a mapping from keys to values, where
@; both keys and values can be arbitrary Racket values, and access and
@; update to the table are normally constant-time operations. Keys are
@; compared using @racket[equal?], @racket[eqv?], or @racket[eq?], depending on whether
@; the hash table is created with @racket[make-hash],
@; @racket[make-hasheqv], or @racket[make-hasheq].

@deftech{散列表}实现了键值映射，其中键和值都可以是任意 Racket 值，
访问和更新该表的操作通常是常量时间的。根据散列表以 @racket[make-hash]、
@racket[make-hasheqv] 还是 @racket[make-hasheq] 来创建，其键分别用
@racket[equal?]、@racket[eqv?] 或 @racket[eq?] 来比较。

@examples[
(define ht (make-hash))
(hash-set! ht "apple" '(red round))
(hash-set! ht "banana" '(yellow long))
(hash-ref ht "apple")
(hash-ref ht "coconut")
(hash-ref ht "coconut" "not there")
]

@; The @racket[hash], @racket[hasheqv], and @racket[hasheq] functions
@; create immutable hash tables from an initial set of keys and values,
@; in which each value is provided as an argument after its key. Immutable
@; hash tables can be extended with @racket[hash-set], which produces a
@; new immutable hash table in constant time.

函数 @racket[hash]、@racket[hasheqv] 和 @racket[hasheq]
均会根据初始的键值集合来创建不可变的散列表。其中每个值都作为其键之后的参数提供。
不可变的散列表可通过 @racket[hash-set] 来扩展，
它会以常量时间产生一个新的不可变散列表。

@examples[
(define ht (hash "apple" 'red "banana" 'yellow))
(hash-ref ht "apple")
(define ht2 (hash-set ht "coconut" 'brown))
(hash-ref ht "coconut")
(hash-ref ht2 "coconut")
]

@; A literal immutable hash table can be written as an expression by using
@; @litchar{#hash} (for an @racket[equal?]-based table),
@; @litchar{#hasheqv} (for an @racket[eqv?]-based table), or
@; @litchar{#hasheq} (for an @racket[eq?]-based table). A parenthesized
@; sequence must immediately follow @litchar{#hash}, @litchar{#hasheq},
@; or @litchar{#hasheqv}, where each element is a dotted
@; key--value pair. The @litchar{#hash}, etc. forms implicitly
@; @racket[quote] their key and value sub-forms.

不可变散列表的字面量可使用 @litchar{#hash}（对应基于 @racket[equal?] 的表）、
@litchar{#hasheqv}（对应基于 @racket[eqv?] 的表）或 @litchar{#hasheq}（对应基于
@racket[eq?] 的表）写成表达式的形式。括号括住的序列必须紧跟 @litchar{#hash}、
@litchar{#hasheq} 或 @litchar{#hasheqv} 其中每个元素都是以点号分隔的键-值对。
@litchar{#hash} 等形式隐式地用 @racket[quote] 引述了其键值的子形式。

@examples[
(define ht #hash(("apple" . red)
                 ("banana" . yellow)))
(hash-ref ht "apple")
]

@; @refdetails/gory["parse-hashtable"]{the syntax of hash table literals}

@refdetails/gory["parse-hashtable"]{散列表字面语法}

@; Both mutable and immutable hash tables print like immutable hash
@; tables, using a quoted @litchar{#hash}, @litchar{#hasheqv}, or
@; @litchar{#hasheq} form if all keys and values can be expressed with
@; @racket[quote] or using @racketresult[hash], @racketresult[hasheq], or
@; @racketresult[hasheqv] otherwise:

可变和不可变散列表的打印结果都与不可变散列表相同。如果所有的键和值均可使用
@racket[quote] 来表达，那么就使用引述的 @litchar{#hash}、@litchar{#hasheqv} 或
@litchar{#hasheq} 形式，否则使用 @racketresult[hash]、@racketresult[hasheq]
或 @racketresult[hasheqv] 来表示：

@examples[
#hash(("apple" . red)
      ("banana" . yellow))
(hash 1 (srcloc "file.rkt" 1 0 1 (+ 4 4)))
]

@; A mutable hash table can optionally retain its keys
@; @defterm{weakly}, so each mapping is retained only so long as the key
@; is retained elsewhere.

可变散列表能够可选地将其键保留为@defterm{弱引用}的，这样只要键在其它地方被保留，
该映射就会被保留。

@examples[
(define ht (make-weak-hasheq))
(hash-set! ht (gensym) "can you see me?")
(collect-garbage)
(eval:alts (hash-count ht) 0)
]

@; Beware that even a weak hash table retains its values strongly, as
@; long as the corresponding key is accessible. This creates a catch-22
@; dependency when a value refers back to its key, so that the mapping is
@; retained permanently. To break the cycle, map the key to an @defterm{ephemeron}
@; that pairs the value with its key (in addition to the implicit pairing
@; of the hash table).

请注意，在弱引用散列表中，只要值对应的键可访问，那么该值也是强引用的。
当值又引用回其键时，会创建一个 catch-22 依赖，这样该映射就会永久保留。
要打破这种循环，需将键映射到一个 @defterm{ephemeron}（短命对象）来将值与其键配对
（散列表中二者的隐式配对除外）。

@; @refdetails/gory["ephemerons"]{using ephemerons}

@refdetails/gory["ephemerons"]{使用 ephemeron}

@examples[
(define ht (make-weak-hasheq))
(let ([g (gensym)])
  (hash-set! ht g (list g)))
(collect-garbage)
(eval:alts (hash-count ht) 1)
]

@interaction[
(define ht (make-weak-hasheq))
(let ([g (gensym)])
  (hash-set! ht g (make-ephemeron g (list g))))
(collect-garbage)
(eval:alts (hash-count ht) 0)
]

@refdetails["hashtables"]{hash tables and hash-table procedures}

@refdetails["hashtables"]{散列表及其过程}
