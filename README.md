<h1 align="center">Harnessing AI: Next Level Strategies for Advanced Security</h1>
<h5 align="center">@s-samadi</h3>
<h5 align="center">@abhi-dutta</h3>

<p align="center">
  <a href="#introduction">Introduction</a> •
  <a href="#prerequisites">Prerequisites</a> •
  <a href="#mona-gallery">Mona Gallery</a> •  
  <a href="#learning-objectives">Learning Objectives</a> •
  <a href="#learning-resources">Learning Resources</a>
</p>



### Introduction

This repository contains the source code for the `Mona Gallery` vulnerable web application. The exercises for this workshop can be found in the `exercises.md` file. 

### Prerequisites

Please make sure that you have all the prerequisites in place before we start of the wokshop

1) Create a codespace from the repository
    <details>
    <summary> Demo </summary>
       
      ![create-codespace](https://github.com/octodemo/universe-wip/assets/68650974/6dde8598-0cd3-4b62-ae60-c609ea4e27c7)
    
     </details>
   

2) Verify that the GitHub Copilot, GitHub Copilot Chat, and GitHub Copilot Lab plugins are pre-installed in your codespace. These installations should occur automatically when you start the codespace.
3) Configure the plugin to grant you access to GitHub copilot through the [githubuniverseworkshops](https://github.com/githubuniverseworkshops) Org that you have been granted access to
4) Confirm that Advanced Security and all its features have been enabled on your repository

### Mona Gallery

The Mona Gallery is a delibrately vulnerable web application consisting of several prevalent vulnerability types, such as SQL injection, XSS, and deserialization, among others. The application's codebase is diverse, utilizing multiple technologies, including Go, Python, Javascript, and Java. A architecture diagram can be found below.  We will use this application's codebase for this workshop.


![mona-gallery](https://github.com/octodemo/universe-wip/assets/68650974/cb0bbf88-6d68-49e8-9129-fa3e487b2be9)

#### Architecture Diagram 

The application's frontend is built with Vue.js 3 and Bootstrap 5, while authorization is managed through the Zitadel OIDC service implemented in Go. Middleware functions are handled in Python. The API is developed in Go, and Blob storage is implemented with MinIO, written in Java. Furthermore, the API layer is also implemented in Go, and the database relies on SQL Lite. Each of these services is encapsulated in its respective Docker container, resulting in a total of five images. To run the application, you can utilize Docker Compose.  


![image](https://github.com/octodemo/universe-wip/assets/79184790/34600cdc-5dde-4dc4-9a68-8e31709c1ec0)

### Learning Objectives

  - Hands on exercise demonstrating our new feature to generate regexes using AI
  - Use AI to find generic secrets 
  - Practical lab demonstrating the new autofix feature for Javascript CodeQL alerts on the pull request
  - How to use GitHub Copilot to learn about CodeQL 
  - Use GitHub Copilot to learn about application security

### Learning Resources

  - [GitHub Advanced Security Learning Path - Microsoft Learn](https://learn.microsoft.com/en-us/collections/rqymc6yw8q5rey)
  - [Docs - GitHub Advanced Security](https://docs.github.com/en/enterprise-cloud@latest/get-started/learning-about-github/about-github-advanced-security)
  - [GitHub Copilot Learning Path - Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/introduction-to-github-copilot/)
  - [Docs - GitHub Copilot](https://docs.github.com/en/copilot)
