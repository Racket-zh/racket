#lang scribble/manual
@(require "private/local-redirect.rkt")

@;{
 This document causes the redirection table to be built,
 in addition to acting as a target to trigger a search-based
 redirection.
}

@; @title{Redirections}

@title{重定向}

@; This page is intended to redirect to the result of a search
@; request. Since you're reading this, it seems that the redirection
@; did not work.

此页面用于重定向搜索请求的结果。既然你读到了这段文字，说明重定向没起作用。

@(make-local-redirect #f)
