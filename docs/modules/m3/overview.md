# Security in Source Code Management Part 2

This module introduces the first part of security testing automation.  Source code scanning has advanced significantly in recent years and has become a required part of any automated build process.  Most of the known vulnerabilities that exist in a code base are discoverable by scanning tools.  However, there can be a number of [false positives](https://en.wikipedia.org/wiki/False_positives_and_false_negatives) because these tools can not tell the higher level architecture, context or execution environment of the software.  A common term used to describe these tools is **S**tatic **A**pplication **S**ecurity **T**esting or **SAST**.  A popular SAST tools is [SonarQube](https://www.sonarqube.org/) for both quality and security scanning.  This tool will be incorporated into our build pipeline to discover security issues and help manage the resolution process.


> [*Video: Introduction to Module 3*](https://auburn.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=e7f9f15e-5c49-4464-bb5c-aeac00f28cd8)

