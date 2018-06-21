#lang at-exp racket/base

(require scribble/manual
         scribble/struct
         scribble/decode
         scribble/eval
         "../icons.rkt")

(require (for-label racket/base))
(provide (for-label (all-from-out racket/base)))

(provide Quick Racket HtDP
         tool
         moreguide
         guideother
         refalso
         refdetails
         refdetails/gory
         refsecref
         ext-refsecref
         r5rs r6rs)

(define Quick
  (other-manual '(lib "scribblings/quick/quick.scrbl")))

(define HtDP
  (italic (link "http://www.htdp.org" "How to Design Programs")))

(define (tool name . desc)
  (apply item (bold name) "，" desc))

(define (moreguide tag . s)
  (apply margin-note
         (decode-content (append
                          (list
                           finger (secref tag) "一节（本手册后文）中"
                           "解释了有关 ")
                          s
                          (list " 的更多详情。")))))

(define (guideother . s)
  (apply margin-note
         (cons finger (decode-content s))))

(define (refdetails* tag what zh-postfix . s)
  (apply margin-note
         (decode-content (append (list magnify (ext-refsecref tag))
                                 (list what)
                                 s
                                 (list zh-postfix "。")))))

(define (refdetails tag . s)
  (apply refdetails* tag "提供了关于" "的更多信息" s))

(define (refalso tag . s)
  (apply refdetails* tag "也提供了" "的文档" s))

(define (refdetails/gory tag . s)
  (apply refdetails* tag "阐述了" "的要点" s))

(define (refsecref s)
  (secref #:doc '(lib "scribblings/reference/reference.scrbl") s))

(define (ext-refsecref s)
  (make-element #f (list Racket "的" (refsecref s) "一节中")))

(define Racket (other-manual '(lib "scribblings/reference/reference.scrbl")))

(define r6rs @elem{R@superscript{6}RS})
(define r5rs @elem{R@superscript{5}RS})

