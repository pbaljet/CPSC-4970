# Samy Worm XSS Vulnerability Case Study

Cross Site Scripting is one of old know vulnerabilities in web browsers.  The infamous javascript being entered into an input field:

>  javascript:alert()

XSS vulnerabilities have become less common due to enhanced browser security controls around executing javascript. This case study illustrates the general problem of web applications not sufficiently taking vulnerabilities into account when building customizable features.

> [*Video: Samy Worm Case Study*]()
> 
Deeper Explanation of XSS Vulnerability (if your interested)
> [*Computerphile Explanation of XSS*](https://youtu.be/L5l9lSnNMxg)

# OWASP & OWASP Top Ten
In this lecture we look at the Open Web Application Security Project Foundation's work in tracking vulnerabilities associate with the web.  Similar to the NIST/MITRE National Vulnerability Database, OWASP has a narrower Cyber Security focus on the web.  It as become the defacto standard used by tools and professionals to detect and prevent web related vulnerabilities

> [*Video: OWASP*]()


# Dynamic Application Security Testing (DAST)
Our next security testing is DAST testing.  DAST testing has become expected for any web application serving business or consumer customers.  No web application is considered secure without going through adequate DAST testing on a regular basis. It is important to understand DAST testing characteristics. 

> [*Video: DAST Security Testing*]()


# Spring Boot Web Application
What is the easiest way to create a Java Web Application.  The answer: Spring Boot.  Not only does Spring Boot make it fast to build a web application, it involves little configuration, and provides production grade modules.  Since this course is not focused on web application development we will be using Spring Boot along with Maven to build and deploy a web application for testing.

> [*Video: Web Application with Spring Boot*]()
 

# ZAP DAST Testing Tool
Gitlab uses ZAP for performing automated DAST scanning as part of a build pipeline and integrates it's reporting into Gitlab's security dashboard.  ZAP is the most popular free tool used by both developers and security professionals for both vulnerability and penetration testing.  This lecture cover the high level aspects of ZAP

> [*Video: ZAP DAST Tool*]()

For introduction videos for ZAP features see the following:

>[*Video: ZAP Usage*](https://www.zaproxy.org/zap-in-ten/) 
