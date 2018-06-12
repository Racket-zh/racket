#lang scribble/doc
@(require scribble/manual)

@; @title{Getting Started}

@title{新手入门}

@; To get started with Racket,
@; @link["http://racket-lang.org/download/"]{download it} from the web page and
@; install it. If you are a beginner or would like to use a graphical environment
@; to run programs, run the @exec{DrRacket} executable. Otherwise, the @exec{racket}
@; executable will run a command-line Read-Eval-Print-Loop
@; (@tech[#:doc '(lib "scribblings/guide/guide.scrbl")]{REPL}).

要开始使用 Racket，请先@link["http://racket-lang.org/download/"]{下载}并安装它。
如果你是新手，或者想要使用图形环境来运行程序，请运行 @exec{DrRacket} 可执行程序。
此外，@exec{racket} 可执行程序会在命令行中运行 读取-求值-打印-循环
（Read-Eval-Print-Loop，即 @tech[#:doc '(lib "scribblings/guide/guide.scrbl")]{REPL}）。

@; On Windows, you can start DrRacket from the @onscreen{Racket} entry in the
@; Start menu. In Windows Vista or newer, you can just type @exec{DrRacket}.  You can
@; also run it from its folder, which you can find in @onscreen{Program Files} →
@; @onscreen{Racket} → @onscreen{DrRacket}.

在 Windows 系统上，你可以从开始菜单的 @onscreen{Racket} 目录中启动 DrRacket。
在 Windows Vista 或更新的版本中，你只需在开始菜单中输入 @exec{DrRacket} 即可。
你也可以从 Racket 的安装目录中执行它，通常位于 @onscreen{Program Files} →
@onscreen{Racket} → @onscreen{DrRacket}。

@; On Mac OS, double click on the @onscreen{DrRacket} icon. It is probably in a
@; @onscreen{Racket} folder that you dragged into your
@; @onscreen{Applications} folder. If you want to use command-line tools, instead,
@; Racket executables are in the @filepath{bin} directory of the @onscreen{Racket}
@; folder (and if you want to set your @envvar{PATH} environment variable, you'll
@; need to do that manually).

在 Mac OS 系统上，请双击 @onscreen{DrRacket} 图标，它应当位于 @onscreen{Racket}
文件夹内，你可能将该文件夹拖到了@onscreen{应用程序}文件夹中。如果你想要使用命令行工具，
那么可以在 @onscreen{Racket} 文件夹的 @filepath{bin} 目录中找到它们（如果你想要将它们添加到
@envvar{PATH} 环境变量中，需要自己手动设置）。

@; On Unix (including Linux), the @exec{drracket} executable can be run directly from the
@; command-line if it is in your path, which is probably the case if you chose a
@; Unix-style distribution when installing. Otherwise, navigate to the directory
@; where the Racket distribution is installed, and the @exec{drracket} executable will be
@; in the @filepath{bin} subdirectory.

在 Unix（包括 Linux）系统上，如果你在安装时选择了 Unix 风格的 Racket
发行版，那么 @exec{drracket} 应该已经在你的 @envvar{PATH} 环境变量中了，
此时可直接在命令行中执行它。否则，请导航到 Racket 发行版的安装目录下，
你可以在 @filepath{bin} 子目录中找到 @exec{drracket}。

@; If you are new to programming or if you have the patience to work
@; through a textbook:

如果你是个编程新手，或者有耐心读课本的话，请阅读以下内容：

@itemize[

@;  @item{@italic{@link["http://htdp.org/"]{How to Design Programs}}
@;        is the best place to start. Whenever the book says ``Scheme,''
@;        you can read it as ``Racket.''}

 @item{@italic{@link["http://htdp.org/"]{How to Design Programs, Second Edition}}
       是面向初学者最好的课本。本书的中文第一版为
       @link["https://book.douban.com/subject/1140942/"]{《程序设计方法》}，
       第二版正在翻译。}

@;  @item{@other-manual['(lib "web-server/scribblings/tutorial/continue.scrbl")]
@;        introduces you to modules and building web applications.}

 @item{@other-manual['(lib "web-server/scribblings/tutorial/continue.scrbl")]
       介绍了模块以及如何构建 Web 应用。}

@;  @item{@other-manual['(lib "scribblings/guide/guide.scrbl")] describes
@;        the rest of the Racket language, which is much bigger than
@;        the learning-oriented languages of the textbook. Since you
@;        learned functional programming from the textbook, you'll be
@;        able to skim chapters 1 and 2 of the Guide.}

 @item{@other-manual['(lib "scribblings/guide/guide.scrbl")] 介绍了
       Racket 语言中剩余的部分，其内容比课本中面向学习者的语言要丰富得多。
       如果你已经从课本中学过了函数式编程，那么可以略读该指南的第一章和第二章。}

]


@; If you're already a programmer and you're in more of a hurry:

如果你是个程序员，并且已经饥渴难耐了，那么请参阅下列内容：

@itemize[

@;  @item{@other-manual['(lib "scribblings/quick/quick.scrbl")] gives you
@;        a taste of Racket.}

 @item{@other-manual['(lib "scribblings/quick/quick.scrbl")]
       带领你一起浅尝 Racket。}

@;  @item{@other-manual['(lib "scribblings/more/more.scrbl")] dives much
@;        deeper and much faster. If it's too much, just skip to the
@;        Guide.}

 @item{@other-manual['(lib "scribblings/more/more.scrbl")]
       探索得更深更快。如果嫌太多的话，可以跳到 Racket 指南。}

@;  @item{@other-manual['(lib "scribblings/guide/guide.scrbl")] starts
@;        with a tutorial on Racket basics, and then it describes the rest
@;        of the Racket language.}

 @item{@other-manual['(lib "scribblings/guide/guide.scrbl")]
       以 Racket 基础教程开始，之后的内容则了 Racket 语言中剩下的部分。}

]

@; Of course, you should feel free to mix and match the above two tracks,
@; since there is information in each that is not in the other.

当然，每条路上的风景各有不同。你可以随意参阅以上两条路线中列出的所有内容，
这样获取的信息会更加全面。
