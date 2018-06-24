#lang scribble/doc
@(require scribble/manual
          scribble/core
          scribble/html-properties
          "private/utils.rkt"
          "private/manuals.rkt")

@main-page['start #t #:show-root-info? #t]

@(define path-info-style (style "RootPathInfo" (list (attributes '((id . "rootPathInfo"))))))
@(define go-style (style "RootPathAction" (list (attributes '((onclick . "return GoToRootPath();"))))))
@(define disable-style (style "RootPathAction" (list (attributes '((onclick . "return DisableRootPath();"))))))

@;   @margin-note{
@;     @not-on-the-web{This is an installation-specific listing.}
@;     Running @exec{raco docs}
@;     (or @exec{Racket Documentation} on Windows or Mac OS)
@;     may open a different page with local and user-specific
@;     documentation, including documentation for installed packages.
@;     @elem[#:style path-info-style]{Searching or following a
@;      ``top'' link will go to a different starting point that
@;      includes user-specific information.
@;      @hyperlink["#"]{@elem[#:style go-style]{[Go to user-specific start]}}
@;      @hyperlink["#"]{@elem[#:style disable-style]{[Forget user-specific start]}}}}

  @margin-note{
    @not-on-the-web{此列表视安装而不同。}
    运行 @exec{raco docs}（或在 Windows 和 Mac OS上 运行 @exec{Racket Documentation}）
    可能会打开不同的页面，其中包含本地和用户特定的文档，包括已安装包的文档。
    @elem[#:style path-info-style]{搜索或访问“顶级”链接会跳转到不同的起点，
     其中会包含了用户特定的信息。
     @hyperlink["#"]{@elem[#:style go-style]{[跳转到用户特定的文档起始页面]}}
     @hyperlink["#"]{@elem[#:style disable-style]{[跳转到无用户特定文档的起始页面]}}}}

@(make-start-page #f)

