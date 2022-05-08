# Importance of Cyber Security

The following video lectures provide a broad overview of the importance of security in software development as part of an organizations comprehensive security program. Also covered are a number of industry standards that will be referenced throughout the course as we examine how security practices can be used to prevent, detect, and remediate different types of security threats.

> [*Video: Cyber Security Overview*](https://auburn.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b5a2da35-7d70-4dd1-8dbf-acbc0052c762)


---

# Cyber Security in Software Development Lifecycle

This set of lecture videos introduces **correctness** as a goal for our solutions
and **testing** as a method of approaching it. Correctness verification is one of
the most important activities that occur in a software development project, and
the testing skills introduced in this set of videos are vital to becoming a
software developer.


> [*Video: Cyber Security Overview*](https://auburn.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b5a2da35-7d70-4dd1-8dbf-acbc0052c762)


# Cyber Security Standards

A common language and framework to communicate security related information is important to ensure rapid understanding and comprehensive coverage.  This lecture video describes the NIST standards and the National Vulnerability Database.

> [*Video: Cyber Security Overview*](https://auburn.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b5a2da35-7d70-4dd1-8dbf-acbc0052c762)


# Course Project Overview

A common language and framework to communicate security related information is important to ensure rapid understanding and comprehensive coverage.  This lecture video describes the NIST standards and the National Vulnerability Database.

> [*Video: Cyber Security Overview*](https://auburn.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b5a2da35-7d70-4dd1-8dbf-acbc0052c762)

# Setting up Development Environment

The next sections and lectures guide you through installing and learning to use the core development tools that will be used throughout the course.  Each of these tools can be installed on Linux, Windows, or Mac operating systems.  Most of the videos and examples will be using unix command line, but the options and commands should for the most part be the same on each operations system.

## Java Installation and Verification

The version of Java used through the course is Java JDK 11.  The Java JDK 11 can be downloaded from <a href="https://www.oracle.com/java/technologies/downloads/#java11" target="_blank">Oracle</a>

To check your java version type the following command:

    java -version

The output looks something line this:

    java version "11.0.8" 2020-07-14 LTS
    Java(TM) SE Runtime Environment 18.9 (build 11.0.8+10-LTS)
    Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.8+10-LTS, mixed mode)


If you are using multiple versions of Java you can  create a shell alias (linux/max) or doskey (<a href="https://stackoverflow.com/questions/47469310/switch-jdk-version-in-windows-10-cmd" target="_blank">Windows</a> to quickly switch between java versions.  The key environment variable for Java are the "JAVA_HOME" and "JAVA_"


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

### Using Git

> [*Video: Welcome Message*](https://auburn.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=67e96d16-5cc1-4d59-bf17-ae8a000a224d)

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





