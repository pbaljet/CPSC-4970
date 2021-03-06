# Development Environment

To complete the work in this course you will need a **development
environment** -- a collection of tools with which you build software.
Development environments range from the small and simple to the large and
complex, but at the core of each is the
[compiler](https://en.wikipedia.org/wiki/Compiler) and
[runtime system](https://en.wikipedia.org/wiki/Runtime_system) of the programming
language being used. At a minimum, a development environment must provide the
tools necessary for you to write a program as a
[text file](https://en.wikipedia.org/wiki/Text_file), translate the program into an
executable form, and then run/execute the program on a computer. For the
purposes of this course it will be important to choose a development that is a
["Goldilocks fit"](https://en.wikipedia.org/wiki/Goldilocks_principle) for you
-- not too little, not too much, but just right.

There is quite of bit of material here, so you can jump to a particular section through the following list.

- [Command Line Interface](#command-line-interface)
- [Java Development Kit](#java-development-kit-jdk)
- [Integrated Development Environment](#integrated-development-environment-ide)
    - [IntelliJ](#intellij)
    - [Eclipse](#eclipse)
    - [Visual Studio Code](#visual-studio-code)
- [Git](#Git Source Code Version Control)
- [Editor + Command Line](#editor--command-line)
    - [Text Editors](#text-editors)
    - [Command Line](#command-line)
    - [Compiler and Runtime Environment](#compiler-and-runtime-environment)
- [JUnit](#testing-framework---junit)


## Command Line Interface

Almost all examples and discussions in this book assume you are familiar with a Unix-like system with a command-line interface. The examples should work under other environments, such as Mac OS X, but the reader can expect slight variations on specific operations systems.

## Java Development Kit (JDK)

The Java Development Kit
([JDK](https://en.wikipedia.org/wiki/Java_Development_Kit)) is a computing
platform for developing and deploying software written in
[Java](https://en.wikipedia.org/wiki/Java_(programming_language)). This course
will use the [Java SE
Platform](https://www.oracle.com/java/technologies/platform-glance.html),
which includes the language, compiler, debugger, runtime environment, and
extensive software libraries - everything you need to develop software in
Java, except for an editor to create source code text files.

To work on your own computer, you must download and install the Java SE JDK
from
[Oracle](https://www.oracle.com/technetwork/java/javase/overview/index.html)
or the [essentially identical](https://blogs.oracle.com/java-platform-group/oracle-jdk-releases-for-java-11-and-later)
open source [OpenJDK](https://openjdk.java.net/). JDK version 11 is required for this course. If you use a different JDK version it is recommended you create a script to change your PATH and JAVA_HOME environment variables to point to the appropriate versions.  

Here are direct links to the Java SE JDK 11 downloads from both Oracle and OpenJDK.

- [Java 11 SDK](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)
- [OpenJDK 11](https://jdk.java.net/java-se-ri/11) (Windows/Linux)

## Integrated Development Environment (IDE)

An integrated development environment
([IDE](https://en.wikipedia.org/wiki/Integrated_development_environment)) is a
software application that provides access within a single interface to a
variety of tools such as an editor, compiler, debugger, runtime environment,
and so on.

While there are many IDEs available for Java, here are some that I can recommend.

### IntelliJ

[IntelliJ IDEA](https://www.jetbrains.com/idea/) ("IntelliJ") is a modern,
professional IDE and is the basis for Google's Android Studio. It is one of the "big
three" IDEs for Java along with Eclipse and NetBeans. As fitting a professional-grade
tool, IntelliJ is large, complex, and comes with a learning curve, but it is a
powerful tool.
The [Community Edition](https://www.jetbrains.org/pages/viewpage.action?pageId=983211)
of IntelliJ is freely available
from [https://www.jetbrains.com/idea/download](https://www.jetbrains.com/idea/download).

### Eclipse

[Eclipse](https://www.eclipse.org/) is a large, complex, professional IDE that
offers a lot of power and flexibility but, of course, comes with a steep learning
curve. Eclipse is freely available
from [https://www.eclipse.org/downloads/](https://www.eclipse.org/downloads/).


### Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com/) is an open-source source
code editor from Microsoft that has become one of the most popular IDEs in
recent years. VS Code is highly capable and full-featured while retaining a
small, easily-used feel. A jGRASP plugin for VS Code is planned for development,
so all the benefits of jGRASP's object viewers should be available within VS
Code soon.

## Git Source Code Version Control

This course uses [Git](https://git-scm.com/) extensively to manage source and interact with the cloud based DevOps platform [Gitlab](https://www.gitlb.com). Git has become an extremely popular tool for modern, distributed software development teams. The module 1 of this course will cover the basic of how to use Git.  Make sure you have the latest Git version 2 install on your workstation:

- [Mac](https://git-scm.com/download/mac) - Git comes installed with Xcode or can be installed through homebrew or macports
- [Linux Install](https://git-scm.com/download/linux)
- [Windows Install](https://git-scm.com/download/win)

Most IDEs and Git tools provide a user interface to interact with a Git local and remote repository.  New users should start with the Git command line Interface (CLI). This helps reinforce the core git commands and concepts.  

## Editor + Command Line

While IDEs can provide convenience and power, there are reasons that you might
want to use a small set of separate tools rather than an integrated
environment.

- Using an IDE can obscure what lower-level tools are being used when a program
  is compiled, executed, tested, and debugged.
- Using an IDE can confuse the separation between a program, the IDE, the
  language, and the different tools being used.
- Being able to work at the command line with fundamental programming tools is
  important.

The minimum tools necessary to work in this mode are an editor, a Java
compiler, a Java runtime environment, and a terminal/shell/command-line
window.

### Text Editors

A good text editor can be used for far more than programming, and this is
another advantage of going this route. Once you get comfortable with a
powerful text editor, you'll want to use it for most everything.

#### Sublime and Atom

Sublime Text and Atom are modern, powerful text editors that are very similar
in functionality but dramatically different in implementation.

[Sublime](https://www.sublimetext.com/) is implemented in C++ and Python and
offers significant speed even under heavy workloads. Sublime is a
closed-source project developed by a small private company (Sublime HQ) in
Australia. A limited version of Sublime is available for free, but the full
version - with all the nice features you really want - must be purchased.

[Atom](https://atom.io/) is implemented using web technologies  (Chromium,
JavaScript, CoffeeScript, etc.) and sacrifices speed for extreme customization
capabilities ("hackable" is the term used by its developers). Atom is an
open-source project developed by GitHub and maintained by a large developer
base. Atom is completely free.

Both Sublime and Atom are supported by extensive package managers that allow
features to be added and removed. Certain collections of features can offer a
level of tool integration that can feel like a simple IDE.

#### Emacs and vi

Emacs and vi are the old guard of text editors, each with its own legion of
devoted followers who keep the [editor
war](https://en.wikipedia.org/wiki/Editor_war) coals smoldering to this day.
This is Marvel-D.C., Hamilton-Burr, Coke-Pepsi.  This is Auburn-Alabama,
Michigan-Ohio State, Army-Navy. If vi had oak trees, Emacs would have poisoned
them. Think I'm kidding or exaggerating?  [I'm
not.](https://www.emacswiki.org/emacs/ChurchOfEmacs)

Hyperbole and drama aside, both [Emacs](https://www.gnu.org/software/emacs/) and
vi (now [Vim](https://www.vim.org/)) are extremely powerful, extremely stable,
and simply excellent text editors. Anyone who considers themselves a programmer
or who wants to be one should give both a try, and be able to at least write a
[Hello World](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program) in
one of them.


### Command Line

The [command line](https://en.wikipedia.org/wiki/Command-line_interface) is a
text-based interface to your computer's operating system. Terms such as *command
prompt*,
*[terminal](https://askubuntu.com/questions/506510/what-is-the-difference-between-terminal-console-shell-and-command-line/506628#506628)*,
*[shell](https://en.wikipedia.org/wiki/Shell_%28computing%29#Text_.28CLI.29_shells)*,
*shell prompt*, and others are often used interchangeably, but for our purposes
I'll just use **command line**.

Both [macOS](https://www.apple.com/macos/) and
[Linux](https://www.linuxfoundation.org/projects/linux/)
distributions provide a command line interface through built-in terminal applications:
[macOS Terminal](https://support.apple.com/guide/terminal/welcome/mac),
[Ubuntu terminal](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview).
Terminal applications can be added to
Microsoft [Windows](https://www.microsoft.com/en-us/windows),
including the
[Ubuntu terminal](https://ubuntu.com/tutorials/tutorial-ubuntu-on-windows#1-overview)
for Windows 10
through [Ubuntu on Windows](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?activetab=pivot:overviewtab).

Here are few good resources for learning to work with the command line.

- [https://programminghistorian.org/en/lessons/intro-to-bash](https://programminghistorian.org/en/lessons/intro-to-bash)
- [https://ubuntu.com/tutorials/command-line-for-beginners#1-overview](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview)
- [Command Cheat Sheet](https://i.redd.it/55848efsjsg21.jpg)

### Compiler and Runtime Environment

The JDK includes commands to invoke the Java compiler and the Java runtime
environment (JRE) from the command line. The compiler can be invoked with the
`javac` command and the JRE can be invoked with the `java` command.

Once the JDK is installed, you can compile and run the Java source code file
`WarEagle.java:

  

`From the command line as follows. (The `$` character represents
the command-line prompt.)

```bash
$ javac WarEagle.java
$ java WarEagle
```

## Testing Framework - JUnit

[JUnit](https://en.wikipedia.org/wiki/JUnit) is a framework for [unit
testing](https://en.wikipedia.org/wiki/Unit_testing) software written in Java.
Writing good test cases is an important skill to develop.

You can learn more about JUnit and install version 4.12 from [this
link](https://junit.org/junit4/).

