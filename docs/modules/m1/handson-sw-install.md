# Setting up Development Environment

The next sections and lectures guide you through installing and learning to use the core development tools that will be used throughout the course.  Each of these tools can be installed on Linux, Windows, or Mac operating systems.  Most of the videos and examples will be using unix command line, but the options and commands should for the most part be the same on each operations system.

## Environment Variables

Understanding the concept of environment variables is essential for CLI Tools, DevOps pipelines, and processes.  You will see them used throughout the various tool configurations in this course.  If you are you not familiar with the usage of environment variables you can review the following resources:

- <a href="https://en.wikipedia.org/wiki/Environment_variable">Wikipedia </a>
- <a href="https://www.youtube.com/watch?v=ADh_OFBfdEE">Good video</a> for unix and windows.

## Java Installation and Verification

The version of Java used through the course is Java JDK 11.  The Java JDK 11 can be downloaded from <a href="https://www.oracle.com/java/technologies/downloads/#java11" target="_blank">Oracle</a>

To check your java version type the following command:

    java -version

The output looks something line this:

    java version "11.0.8" 2020-07-14 LTS
    Java(TM) SE Runtime Environment 18.9 (build 11.0.8+10-LTS)
    Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.8+10-LTS, mixed mode)


If you are using multiple versions of Java you can  create a shell alias (linux/max) or doskey (<a href="https://stackoverflow.com/questions/47469310/switch-jdk-version-in-windows-10-cmd" target="_blank">Windows</a> to quickly switch between java versions.  The key environment variable for Java is "JAVA_HOME".

You are also welcome to use other Java implementations such as OpenJDK. 


## Git Version Control

Source code version control is foundational to managing change to a software code base.  It provides the ability to maintain a history of all changes, control introduction of changes to a stable code base, and provide the ability to work independently through branches among other essential capabilities.

Git

### Git Installation

Check to see if you have Git installed with the following command:

    git --version

The output looks something line this:

    git version 2.23.0

or for windows:

    git version 2.36.0.windows.1

## Maven Build Automation

The Apache Java Maven tool (https://maven.apache.org/) to provide build automation for our Java source code.  Maven provides the ability to compile, test, scan, and package our applications using a configuration file called a project object model (POM).

### Maven Installation

Maven can be downloaded from the <a href="https://maven.apache.org/download.cgi" target="_blank">project website</a>.  Maven is a Java based tool and can be uncompressed in a directory.

<a href="https://maven.apache.org/install.html" target="_blank">Installation steps</a>. Once downloaded your path variable needs to be updated to include the "bin" directory under the root maven directory.

Once completed you can run the following command to check the installation and setup:

    mvn -version

The output looks something line this:

    Apache Maven 3.6.0 (97c98ec64a1fdfee7767ce5ffb20918da4f719f3; 2018-10-24T14:41:47-04:00)
    Maven home: /usr/local/Cellar/maven/3.6.0/libexec
    Java version: 14.0.2, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk-14.0.2.jdk/Contents/Home
    Default locale: en_US, platform encoding: UTF-8
    OS name: "mac os x", version: "10.16", arch: "x86_64", family: "mac"




