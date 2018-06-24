#lang scribble/doc
@(require scribble/base
          scribble/core
          scribble/html-properties
          "private/utils.rkt"
          "private/make-search.rkt"
          "config.rkt")

@main-page['search #t]

@; @para[#:style (style #f (list (attributes (list (cons 'class "plt_global_only")))))]{You are searching all available Racket packages, including those that you may not have installed locally. Therefore, you may need to install a package to use the results shown below. @hyperlink["http://docs.racket-lang.org/pkg/getting-started.html"]{Getting Started with Packages} guides you through this process. If you want to re-run your search with local results only, press F1 in DrRacket or run @tt{raco docs} on the command line.}

@para[#:style (style #f (list (attributes (list (cons 'class "plt_global_only")))))]{你正在搜索所有可用的 Racket 包，其中包括尚未安装到本地的包。因此，你可能需要根据以下搜索结果安装对应的包。@hyperlink["http://docs.racket-lang.org/pkg/getting-started.html"]{包管理新手入门}会指引你走完整个流程。如果你想要重新搜索本地的结果，请在 DrRacket 中按 F1 键或在命令行中运行 @tt{raco docs}。}

@; @para[#:style (style #f (list (attributes (list (cons 'class "plt_local_only")))))]{You are searching only your locally installed Racket packages. More results may be available by using the @hyperlink["http://docs.racket-lang.org/search/"]{global search} that inspects all available packages. @elem[#:style (style #f (list (attributes (list (cons 'id "redo_search_global")))))]{You may wish to repeat your search globally.}}

@para[#:style (style #f (list (attributes (list (cons 'class "plt_local_only")))))]{你正在搜索本地安装的 Racket 包。更多结果可通过@hyperlink["http://docs.racket-lang.org/search/"]{全局搜索}获取，其中会列出所有可用的包。@elem[#:style (style #f (list (attributes (list (cons 'id "redo_search_global")))))]{你可能想要使用全局搜索再试一次。}}

@make-search[#f]

