#lang scribble/doc
@(require scribble/manual scribble/eval "guide-utils.rkt")

@; @title[#:tag "to-scheme" #:style 'toc]{Racket Essentials}

@title[#:tag "to-scheme" #:style 'toc]{Racket 精要}

@; This chapter provides a quick introduction to Racket as background for
@; the rest of the guide. Readers with some Racket experience can safely
@; skip to @secref["datatypes"].

本章作为其余章节的基础背景，简单介绍了 Racket 的主要特性。
有 Racket 经验的读者可直接跳到 @secref["datatypes"] 一章。

@local-table-of-contents[]

@include-section["simple-data.scrbl"]
@include-section["simple-syntax.scrbl"]
@include-section["lists.scrbl"]
@include-section["truth.scrbl"]
