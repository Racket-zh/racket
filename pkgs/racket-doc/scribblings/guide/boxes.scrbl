#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "boxes"]{Boxes}

@title[#:tag "boxes"]{盒子}

@; A @deftech{box} is like a single-element vector. It can print as a
@; quoted @litchar{#&} followed by the printed form of the boxed value.
@; A @litchar{#&} form can also be used as an expression, but since the
@; resulting box is constant, it has practically no use.

@deftech{盒子}类似于单元素的向量。它的打印形式为 @racket[quote] 引述的
@litchar{#&} 后跟盒中值的打印形式。@litchar{#&} 形式也可用作表达式，
但由于产生的盒子为常量，因此它在实践中没什么用。

@; So what are boxes good for, anyway?

@examples[
(define b (box "apple"))
b
(unbox b)
(set-box! b '(banana boat))
b
]

@; @refdetails["boxes"]{boxes and box procedures}

@refdetails["boxes"]{盒子及其过程}
