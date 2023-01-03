# Succeeding in This Module 6

In this module, we will be using the Zed Attack Proxy (ZAP) to find and resolve vulnerabilities in a web application.  A firm understanding of the HTTP protocol is necessary to use the ZAP tool and configure HTTP requests and responses to mitigate vulnerabilities.  To demonstrate Secrets Management access to our database to login users requires a secret (username/password) and we will be moving this secret outside of our application respository and retrieving it in real time from AWS Secrets Management tool.  Our AuthProvider component has been updated and we will be using it as a dependency in our web application.  

# Module Objectives

- Review the case study of Stuxnet worm 
- Gain a basic understanding of the HTTP protocol
- Understand how the ZAP DAST tool can be used to detect web vulnerabilities
- Resolve vulnerabilities found by DAST scanning a web application
- Understanding what is a "Secret"
- Implementing integration to a secrets management tool 
- Deploy a web application with a login feature
- Integrate our AuthProvider as a dependency into our web application
