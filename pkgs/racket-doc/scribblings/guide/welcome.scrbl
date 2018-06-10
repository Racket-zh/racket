#lang scribble/doc
@(require scribble/manual scribble/eval scribble/bnf "guide-utils.rkt"
          (only-in scribble/core link-element)
          (for-label racket/enter))

@(define piece-eval (make-base-eval))

@; @title[#:tag "intro"]{Welcome to Racket}

@title[#:tag "intro"]{欢迎来到 Racket}

@; Depending on how you look at it, @bold{Racket} is

根据视角的不同，@bold{Racket} 可以是：

@itemize[

@; @item{a @defterm{programming language}---a dialect of Lisp and a
@;       descendant of Scheme;
@;
@;       @margin-note{See @secref["dialects"] for more information on
@;       other dialects of Lisp and how they relate to Racket.}}
@;
@; @item{a @defterm{family} of programming languages---variants of
@;       Racket, and more; or}
@;
@; @item{a set of @defterm{tools}---for using a family of programming languages.}

 @item{一种@defterm{编程语言}---一种 Lisp 的方言和 Scheme 的后裔；

       @margin-note{更多关于 Lisp 方言以及它们与 Racket 之间关系的信息，
       见@secref["dialects"]。}}

 @item{一个编程语言@defterm{家族}---包括 Racket 的多种变体，还有更多；}

 @item{一组@defterm{工具}---用于该编程语言家族。}
]

@; Where there is no room for confusion, we use simply @defterm{Racket}.

在没有歧义时，我们就简单地使用 @defterm{Racket}。

@; Racket's main tools are

Racket 的主要工具包括：

@itemize[

@; @tool[@exec{racket}]{the core compiler, interpreter, and run-time system;}
@;
@; @tool["DrRacket"]{the programming environment; and}
@;
@; @tool[@exec{raco}]{a command-line tool for executing @bold{Ra}cket
@; @bold{co}mmands that install packages, build libraries, and more.}

 @tool[@exec{racket}]{核心编译器、解释器和运行时系统；}

 @tool["DrRacket"]{编程语言环境；}

 @tool[@exec{raco}]{用于执行 Racket 命令（@bold{Ra}cket @bold{co}mmands）
 的命令行工具，包括安装包，构建库等等。}

]

@; Most likely, you'll want to explore the Racket language using
@; DrRacket, especially at the beginning. If you prefer, you can also
@; work with the command-line @exec{racket} interpreter and your favorite
@; text editor; see also @secref["other-editors"]. The rest of this guide
@; presents the language mostly independent of your choice of editor.

通常，你可以用 DrRacket 来探索 Racket 语言，特别是在开始阶段。
根据自己偏好，你也可以按照自己的偏好使用命令行 @exec{racket}
解释器和你喜欢的文本编辑器，详情请参阅@secref["other-editors"]。
本文档中其余介绍语言的部分大都与你选择的编辑器无关。

@; If you're using DrRacket, you'll need to choose the proper language,
@; because DrRacket accommodates many different variants of Racket, as
@; well as other languages. Assuming that you've never used DrRacket
@; before, start it up, type the line

如果你使用 DrRacket，就需要选择适当的语言，因为 DrRacket 支持多种
Racket 变体和其它语言。如果你从未使用过 DrRacket，请启动它，并在
DrRacket 上方的文本区内输入

@racketmod[racket]

@; in DrRacket's top text area, and then click the @onscreen{Run} button
@; that's above the text area. DrRacket then understands that you mean to
@; work in the normal variant of Racket (as opposed to the smaller
@; @racketmodname[racket/base] or many other possibilities).

之后点击文本区上方的@onscreen{运行}按钮，这样 DrRacket 就明白你要使用
Racket 的正常变体了（这里的“正常”是相对于更小的 @racketmodname[racket/base]
或其它可用的变体而言的）。

@; @margin-note{@secref["more-hash-lang"] describes some of the other
@;              possibilities.}

@margin-note{@secref["more-hash-lang"]一节中描述了其它可用的变体。}

@; If you've used DrRacket before with something other than a program
@; that starts @hash-lang[], DrRacket will remember the last language
@; that you used, instead of inferring the language from the @hash-lang[]
@; line. In that case, use the @menuitem["Language" "Choose Language..."]
@; menu item.  In the dialog that appears, select the first item, which
@; tells DrRacket to use the language that is declared in a source
@; program via @hash-lang[]. Put the @hash-lang[] line above in the top
@; text area, still.

如果你曾经在 DrRacket 中编写过不以 @hash-lang[] 开头的程序，那么 DrRacket
会记住你上一次使用的语言，而非根据 @hash-lang[] 来推断。此时，请点击
@menuitem["语言" "选择语言..."]

@; ----------------------------------------------------------------------
@; @section{Interacting with Racket}

@section{与 Racket 进行交互}

@; DrRacket's bottom text area and the @exec{racket} command-line program
@; (when started with no options) both act as a kind of calculator. You
@; type a Racket expression, hit the Return key, and the answer is
@; printed. In the terminology of Racket, this kind of calculator is
@; called a @idefterm{read-eval-print loop} or @deftech{REPL}.

DrRacket 下方的文本区和 @exec{racket} 命令行程序（在无选项启动时）
都可以视作一种计算器。你只需输入 Racket 表达式，敲下回车键，答案就打印出来了。
按照 Racket 的术语，这种计算器叫做@idefterm{读取-求值-打印 循环
（read-eval-print loop）}，简称 @deftech{REPL}。

@; A number by itself is an expression, and the answer is just the
@; number:

数字本身就是就是表达式，其答案就是该数字。

@interaction[5]

@; A string is also an expression that evaluates to itself. A string is
@; written with double quotes at the start and end of the string:

字符串也是求值为其自身的表达式。字符串写在两个双引号之间：

@interaction["Hello, world!"]

@; Racket uses parentheses to wrap larger expressions---almost any kind
@; of expression, other than simple constants. For example, a function
@; call is written: open parenthesis, function name, argument
@; expression, and closing parenthesis. The following expression calls
@; the built-in function @racket[substring] with the arguments
@; @racket["the boy out of the country"], @racket[4], and @racket[7]:

Racket 使用圆括号来括住较大的表达式---即除常量之外的几乎任何表达式。
例如，一个函数调用写作：开括号，函数名，参数表达式和比括号。
以下表达式以参数 @racket["the boy out of the country"]、@racket[4] 和
@racket[7] 调用了内建函数 @racket[substring]：

@interaction[(substring "the boy out of the country" 4 7)]

@; ----------------------------------------------------------------------
@; @section{Definitions and Interactions}

@section{定义与交互}

@; You can define your own functions that work like @racket[substring] by
@; using the @racket[define] form, like this:

你可以通过 @racket[define] 形式来定义自己的函数，让它像 @racket[substring]
那样工作：

@def+int[
#:eval piece-eval
(define (extract str)
  (substring str 4 7))
(extract "the boy out of the country")
(extract "the country out of the boy")
]

@; Although you can evaluate the @racket[define] form in the @tech{REPL},
@; definitions are normally a part of a program that you want to keep and
@; use later. So, in DrRacket, you'd normally put the definition in the
@; top text area---called the @deftech{definitions area}---along with the
@; @hash-lang[] prefix:

尽管你可以在 @tech{REPL} 中对 @racket[define] 形式进行求值，
然而定义通常是程序的一部分，你可能想要保留它以备后用。因此在 DrRacket
中，通常你应将定义连同 @hash-lang[] 前缀一起放在上方的文本区，
即@deftech{定义区}内：

@racketmod[
racket
code:blank
(define (extract str)
  (substring str 4 7))
]

@; If calling @racket[(extract "the boy")] is part of the main action of
@; your program, that would go in the @tech{definitions area}, too. But
@; if it was just an example expression that you were using to explore
@; @racket[extract], then you'd more likely leave the @tech{definitions
@; area} as above, click @onscreen{Run}, and then evaluate
@; @racket[(extract "the boy")] in the @tech{REPL}.

如果调用 @racket[(extract "the boy")]  是你的程序主要活动的一部分，
那么它也应当放在@tech{定义区}内。但如果它只是你用来测试 @racket[extract]
的示例表达式，那么你可能更愿意将@tech{定义区}保持为如上状态，点击@onscreen{运行}，
然后在 @tech{REPL} 中对 @racket[(extract "the boy")] 求值。

@; When using command-line @exec{racket} instead of DrRacket, you'd save
@; the above text in a file using your favorite editor. If you save it as
@; @filepath{extract.rkt}, then after starting @exec{racket} in the same
@; directory, you'd evaluate the following sequence:

在使用命令行 @exec{racket} 而非 DrRacket 时，你应当用编辑器将以上文本保存在文件中。
如果你将它保存为 @filepath{extract.rkt}，那么在同一目录下执行 @exec{racket}
之后，就会对以下序列求值：

@; @margin-note{If you use @racketmodname[xrepl], you can use
@;   @(link-element "plainlink" (litchar ",enter extract.rkt") `(xrepl "enter")).}

@margin-note{如果你使用 @racketmodname[xrepl]，那么可以用
  @(link-element "plainlink" (litchar ",enter extract.rkt") `(xrepl "enter")).}

@interaction[
#:eval piece-eval
(eval:alts (enter! "extract.rkt") (void))
(extract "the gal out of the city")
]

@; The @racket[enter!] form both loads the code and switches the
@; evaluation context to the inside of the module, just like DrRacket's
@; @onscreen{Run} button.

@racket[enter!] 形式会加载该代码并将求值上下文切换到该模块中，就像
DrRacket 的@onscreen{运行}按钮那样。

@; ----------------------------------------------------------------------
@; @section{Creating Executables}

@section{创建可执行文件}

@; If your file (or @tech{definitions area} in DrRacket) contains

如果你的文件（或 DrRacket 的 @tech{定义区}）中包含

@racketmod[
racket

(define (extract str)
  (substring str 4 7))

(extract "the cat out of the bag")
]

then it is a complete program that prints ``cat'' when run. You can
run the program within DrRacket or using @racket[enter!] in
@exec{racket}, but if the program is saved in @nonterm{src-filename},
you can also run it from a command line with

那么它就是个在运行时会打印“cat”的完整程序。你可以使用 DrRacket 或在
@exec{racket} 中使用 @exec{racket} 来运行该程序。但如果该程序保存在
@nonterm{src-filename} 中，你也可以在命令行中运行它：

@commandline{racket @nonterm{src-filename}}

@; To package the program as an executable, you have a few options:

你有几种可选的方式将程序打包成可执行文，：

@itemize[

@;  @item{In DrRacket, you can select the @menuitem["Racket" "Create
@;        Executable..."] menu item.}
@;
@;  @item{From a command-line prompt, run @exec{raco exe
@;        @nonterm{src-filename}}, where @nonterm{src-filename} contains
@;        the program. See @secref[#:doc '(lib
@;        "scribblings/raco/raco.scrbl") "exe"] for more information.}
@;
@;  @item{With Unix or Mac OS, you can turn the program file into an
@;        executable script by inserting the line
@;
@;        @margin-note{See @secref["scripts"] for more information on
@;                     script files.}
@;
@;         @verbatim[#:indent 2]{#! /usr/bin/env racket}
@;
@;        at the very beginning of the file. Also, change the file
@;        permissions to executable using @exec{chmod +x
@;        @nonterm{filename}} on the command line.
@;
@;        The script works as long as @exec{racket} is in the user's
@;        executable search path.  Alternately, use a full path to
@;        @exec{racket} after @tt{#!}  (with a space between @tt{#!}
@;        and the path), in which case the user's executable search path
@;        does not matter.}

 @item{在 DrRacket 中，你可以选择 @menuitem["Racket" "创建可执行程序..."]
       菜单项。}

 @item{在命令行中，请执行 @exec{raco exe @nonterm{src-filename}}，其中
       @nonterm{src-filename} 包含该程序。更多信息见 @secref[#:doc '(lib
       "scribblings/raco/raco.scrbl") "exe"]。}

 @item{对于 Unix 或 Mac OS，你可以在该文件的最开始处插入

       @margin-note{更多关于脚本文件的信息见 @secref["scripts"]。}

        @verbatim[#:indent 2]{#! /usr/bin/env racket}

       来将其转换为可执行脚本。此外，你还需要在命令行中用 @exec{chmod +x
       @nonterm{filename}} 为其赋予可执行权限。

       只要 @exec{racket} 在用户的可执行文件搜索路径（即 @tech{PATH}
       环境变量）中，该脚本就能工作。如果在 @tt{#!} 之后使用
       @exec{racket} 的完整路径（@tt{#!} 和路径之间留有一空格），
       那么用户的可执行文件搜索路径就无关紧要了。}
]

@; ----------------------------------------------------------------------
@; @section[#:tag "use-module"]{A Note to Readers with Lisp/Scheme Experience}

@section[#:tag "use-module"]{Lisp/Scheme 经验者注意}

@; If you already know something about Scheme or Lisp, you might be
@; tempted to put just

如果你对 Scheme 或 Lisp 有所了解，那么你可能会试图将

@racketblock[
(define (extract str)
  (substring str 4 7))
]

@; into @filepath{extract.rktl} and run @exec{racket} with

放在 @filepath{extract.rktl} 中并以如下方式运行 @exec{racket}

@interaction[
#:eval piece-eval
(eval:alts (load "extract.rktl") (void))
(extract "the dog out")
]

@; That will work, because @exec{racket} is willing to imitate a
@; traditional Lisp environment, but we strongly recommend against using
@; @racket[load] or writing programs outside of a module.

这样确实可以工作，因为 @exec{racket} 会模拟出传统的 Lisp 环境。
不过我们强烈建议你不要在模块之外使用 @racket[load] 或编写程序。

@; Writing definitions outside of a module leads to bad error messages,
@; bad performance, and awkward scripting to combine and run
@; programs. The problems are not specific to @exec{racket}; they're
@; fundamental limitations of the traditional top-level environment,
@; which Scheme and Lisp implementations have historically fought with ad
@; hoc command-line flags, compiler directives, and build tools. The
@; module system is designed to avoid these problems, so start with
@; @hash-lang[], and you'll be happier with Racket in the long run.

在模块外编写程序会结合糟糕的错误消息、低劣性能和笨拙的脚本来运行程序。
这些问题并非针对于 @exec{racket}，它们是传统上层环境的根本限制，
历史上 Scheme 和 Lisp 的实现与造成这些限制的特设（ad-hoc）命令行参数、
编译器指令和构建工具作过斗争。模块系统的设计就是用来避免这些问题的，
因此从长远来看，以 @hash-lang[] 开始会让 Racket 的使用体验更加愉快。

@; ----------------------------------------------------------------------

@close-eval[piece-eval]
