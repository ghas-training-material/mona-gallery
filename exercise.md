# Universe 2023 - Workshop Exercises

Welcome to the workshop **Harnessing AI: Next Level Strategies for Advanced Security**!
Below you will find the exercises to complete as a part of this workshop. There will be a set amount of time to complete each one.
We will provide a walkthrough of the solution after each exercise.
If you get stuck there are hints along the way. Additionaly you can access GIF-based solutions for each exercise.


## Lab 1 - Secret Scanning AI 

If you are interested in participating in the **limited public beta** for secret scanning please join the [waitlist](https://github.com/features/preview/security) and the GitHub staff will be in touch. You can find the terms and conditions [here](https://docs.github.com/en/site-policy/github-terms/github-terms-for-additional-products-and-features).

### Exercise 1 - AI-generated custom patterns - 5 mins

This Universe, we are excited to be launching the **AI-generated custom patterns** feature as a limited public beta.
In this exercise, we will generate a custom pattern using this new feature. 
<details>
<summary>Prerequiste - secret scanning must be enabled for this exercise. This feature should already be enabled by default for this repository. If not, please follow the instructions here to enable secret scanning. </summary>

1. Navigate to the `Settings` tab of the repository, click on the `Code security and analysis` section, and click `Enable` under secret scanning.

    ![secret-scanning-enablement](https://github.com/octodemo/universe-wip/assets/68650974/fd1e12ad-5f36-4a77-a3a5-6e97db61c6ad)

</details>

**Scenario**

You are a part of the security team, and it has been brought to your attention that the MinIO password `mona_value_abc124` for the object store has been leaked in the code!
You want to write a custom pattern to detect this.

1. Navigate to `Settings` tab of the repository, click on `Code security and analysis` section, and under `Custom Patterns` click on `New pattern`
2. In the top right hand corner, click on `Generate with AI`
     <details>
    <summary> Solution </summary>
       
    ![secret-scanning-custom-ai-setting](https://github.com/octodemo/universe-wip/assets/68650974/ae7156c6-268e-4b56-8cb5-ad30c5fd1a2f)
    
     </details>

3. Fill in the options `I want a regular expression that` and `Examples of what I am looking for`

    <details>
      <summary> Hint </summary>
      You want to find a string that starts with `mona_value_`
    </details>
    
    <details>
      <summary> Solution </summary>
      
      ![secret-scanning-mona-value](https://github.com/octodemo/universe-wip/assets/68650974/052be656-400a-4f25-a0be-9d9f90602f93)
   
    </details>
    
4. Assume that we know that the custom secret pattern always ends with an alphanumeric character of length 6. Can you make the regex pattern more precise? For the most accurate results, it is imperative when dealing with AI that we provide as much detail as possible with as much context as possible.

    <details>
      <summary> Hint </summary>
      Provide the AI with more details about the pattern. Consider factors such as length. What about character composition? Is it entirely numerical? 
    </details>

    <details>
      <summary> Solution </summary>
      
      ![mona-value-6](https://github.com/octodemo/universe-wip/assets/68650974/e7eca0d5-98fb-4425-9da8-e1ae8a282df1)

    </details>

### Exercise 2 - generic secret detection using AI - 5 mins

At Universe 2023 we will also be shipping the **generic secret detection using AI** feature as a limited public beta. Enabling this feature will use an AI model to detect additional secrets beyond the secrets detected with regular expression. 

1. Enable this feature by navigating to the `Settings` tab of the repository, click on the `Code security and analysis` section, and tick the checkbox `Use AI detection to find additional secrets` under secret scanning.

   <details>
      <summary> Solution </summary>
    
   ![generic-ai-secret](https://github.com/octodemo/universe-wip/assets/68650974/0519aa0d-75a8-45e3-9fc5-f8d34ffd9bb2)

    </details>

2. Add Bob's credentials to the end of the `password.txt` file located at the root of the repository.
   
    ```txt
    username=bob@localhost
    password=verysecure1234
    ```

   <details>
      <summary> Solution </summary>
    
    ![exercise-1-lab2-add-password](https://github.com/githubuniverseworkshops/mona-gallery-s-samadi-demo/assets/68650974/db6949bc-9608-41a1-8547-5f496c8763ef)


    </details>

3. To view detected alerts, navigate to the `Security` tab, under `Secret Scanning`, click the `Other` option

   <details>
      <summary> Solution </summary>
    
      ![exercise-1-lab2-view](https://github.com/githubuniverseworkshops/mona-gallery-s-samadi-demo/assets/68650974/5eb458df-ab9d-4e00-95ed-d5381760a5fa)


    </details>

## Lab 2 - Code Scanning AI


**Scenario**

You have just joined a new team as a developer. To familiarize yourself with the codebase, you've been tasked with remediating some code scanning vulnerabilities in the repository.

You will be remediating an existing SQL Injection vulnerability in `main.go` on **line 309**.
There are two tasks to remediate this vulnerability:
1. sanitize input in the javascript (Exercise 1)
2. fix the SQL prepare statement in the go code (Exercise 2 and Exercise 3)

### Exercise 1 - AI generated autofix on javascript pull requests - 10 mins

This Universe we will be launching the **code scanning autofix** feature as a limited public beta. This feature uses AI to generate fixes on pull requests that contain JavaScript CodeQL alerts.  We will see this feature in action in this exercise. If you are interested in participating in this limited public beta, please reach out to your Account Manager if you are an existing customer. Otherwise, reach out to the GitHub Sales Team for assistance. You can find the terms and conditions [here](https://docs.github.com/en/site-policy/github-terms/github-terms-for-additional-products-and-features).

Input sanitization is a fundamental security practice to prevent SQL injection attacks. Let's add a sanitize method in the javascript to help in mitigating against injection attack vectors.

You can solve this exercise using either the codespaces or the UI. Codespaces is preferable as this is what a developer would use under normal circumstances. However, if codespaces is not loading for you please use the UI. 


1. Create a branch called `sql-injection-fix` and push it to the remote repo.

    <details>
      <summary> Hint </summary>
      Run the command:
        
      ```
        $ git checkout -b sql-injection-fix
        $ git push -u origin sql-injection-fix
      ```
     </details>

    <details>
      <summary> Solution </summary>  
        
      ![create-branch](https://github.com/octodemo/universe-wip/assets/68650974/4a162cb4-62d7-4ce6-9114-c5efefe60b2d)
  
    </details>
     

2. Add the following sanitization function on **line 233** of `frontend/components/Gallery.vue`

    ```js
    function sanitizeInput(input) {
        if (input == null) {
            return "";
        }
        //escape all occurances of apostrophe
        input = input.replace("'", "''");
    
        return input;
    }
    ```

3. Call the sanization function from the Update function by placing the following call on **line 347** of `/frontend/components/Gallery.vue`

    ```js
        artItem.description = sanitizeInput(artItem.description)
        artItem.title = sanitizeInput(artItem.title)
    ```

4. Commit and push the code

<details>
   <summary> Solution for steps 2-4 </summary>  
    
   ![sanitization](https://github.com/octodemo/universe-wip/assets/68650974/a85a6690-607d-467e-b6bf-3566ad73d5b9)
   
</details>

5. Raise a pull request to the `main` branch. Wait for the scans to complete and you should see a CodeQL javascript alert in your pull request. Oh no! There is a vulnerability in our vulnerability! Lucky we have autofix.

**Autofix feature**

The autofix feature suggests fixes for CodeQL alerts raised as a part of the pull request. At the moment, it only supports JavaScript. Our sanitize function only replaced the first occurance of the string. Autofix has suggested a fix to replace the string with a regular expression and uses the g flag to ensure all occurrences are replaced. You should be able to see an autofix suggestion as a part of the pull request.

![autofix](https://github.com/octodemo/universe-wip/assets/68650974/5a8e2c68-fc68-47b1-ae6d-c0814444530c)


### Exercise 2 - learning with Copilot - 5 mins

1. Navigate to `Copilot Chat` icon in your Visual Studio Code IDE (Codespace)
2. Open the `main.go` file under `gallery` folder. Navigate to **line 309** which represents an injection vulnerability and ask GitHub Copilot Chat to explain the vulnerability
     <details>
    <summary> Solution </summary>
       
    ![learn-app-sec](https://github.com/octodemo/universe-wip/assets/79184790/e50d3566-5829-41eb-8782-f226bbfed061)

     </details>


### Exercise 3 - remediating vulnerabilities with Copilot - 10 mins

Our sanitization function is limited to the user interface (UI). If we expose the Update method through an API or another medium, we remain susceptible to vulnerabilities. Let's use Copilot to remediate the vulnerability. 

1. In Codespaces, use the Sarif Viewer to navigate to the SQL Injection vulnerability located in `gallery/main.go` on **line 309**. Note if the Sarif Viewer is not loading the correct SARIF you can use the one provided in the `universe-utils/go.sarif`
   
2. Hover over the alert and select `Fix using Copilot`
3. Copilot will propose a fix. Review proposed fix and click `Accept`
4. Commit, push the fix, and merge in the PR to resolve the alert

<details>
   <summary> Solution </summary>  

![copilot-fix](https://github.com/octodemo/universe-wip/assets/68650974/8d8e7e54-ba87-444a-92fb-17f22f7a730a)

</details>

### Bonus XSS Exercise: Prompting Copilot Chat to learn about custom CodeQL query - 5 mins

**Prompt Engineering** involves formulating a prompt to optimize the model's ability to generate the most valuable prediction for the user.

A prompt commonly involves at least one of the following elements:

- Instruction - You can use natural language to provide instructions.  However,  Github Copilot Chat also offers pre-configured slash command choices as default templates to help steer the Language Model (LLM) more effectively toward your intended goal.
- Context - GitHub Copilot Chat lives in the context of an IDE such as Visual Studio Code (VS Code). This involves having relevant files open in each tab and highlighting the code snippet your interested in
- Examples - Provide examples of the desired output. We saw an example of this when generating regexes for secret scanning. Prompting falls into two broad categories:
    - Zero shot prompting: this is when no examples are provided to the model. 
    - Few-shot prompting: this is when examples are provided to the model , it serves as conditioning for subsequent examples where we would like the model to generate a response.
- Output - Specify the desired output format. Some examples within Copilot instruction include:
    - `/explain` - will output text file
    - `Generate Docs` - will create comments in the code
    - `/fix` - will output code

**Scenario**

There is a custom codeql query written specifically for finding vue related xss vulnerabilities specific to this codebase. This query can be found in the `queries` folder. Use **Copilot Chat** to better understand this query.


Initially, we want to see what happens when we don’t provide any context to Copilot Chat.
1. Close all tabs and open Copilot chat
2. Type in the following into the chat `/explain vue-xss.ql`

Was this the output you expected? A key factor contributing to occasional inaccuracies in LLM outputs is the absence of context. These models heavily depend on the information provided in the context. When the context is ambiguous or lacks detail, the model might infer assumptions that result in inaccurate responses.

<details>
   <summary> Solution </summary>  
    
![copilot-ex-1](https://github.com/githubuniverseworkshops/GHAS-AI-Template/assets/68650974/e3bc3e65-e71e-4e92-aefe-6dd6e0a760b4)

</details>

Now let's add in some context. Recall that the context for GitHub Copilot is the IDE. 

3. Open the `vue-xss.ql` query in a tab and run the prompt from the previous exercise:
    `/explain vue-xss.ql`

Was the output different? 

<details>
   <summary> Solution </summary>  

 ![copilot-ex-2](https://github.com/githubuniverseworkshops/GHAS-AI-Template/assets/68650974/92a79ff0-7a7e-493c-bd17-d5137d0b7c46)
   
</details>


The more specific and concise you can be about your problem statement the more accurate the results that will be generated.  For example, let’s say that we want to understand the 2 predicates and their regexes between **line 42 and line 46**. 

4. Try highlighting between these lines and ask copilot for an explanation.

<details>
   <summary> Solution </summary>  
    
 ![copilot-ex-3](https://github.com/githubuniverseworkshops/GHAS-AI-Template/assets/68650974/e50d2e11-f274-442a-91bf-15b9e75919e8)

</details>

Let's say you wanted to comment the CodeQL query so that it is easier to understand for new joiners of the repository. 

5. Highlight the predicate `resolveRefForArraySourceValue` from **line 60 to line 100** and use the option `Generate Docs`

<details>
   <summary> Solution </summary>  
    
![copilot-ex-4](https://github.com/githubuniverseworkshops/GHAS-AI-Template/assets/68650974/03850e4c-fc37-4209-98d4-9ad58dc103b9)

   
</details>


## Lab 3 - Threat Modelling with GitHub Copilot  

### Exercise 1 - threat modelling with GitHub Copilot - 5 mins

**Scenario**

Threat modelling is often a manual and specialised task conducted by security teams. We can automate some of this process using Copilot.  

In this **demo** we will be using the GitHub Copilot Chat feature from a security practitioner's perspective. We'll observe how leveraging an AI-assisted tool can begin to gain additional context regarding the application's threat boundaries.

1. Let's Ask GitHub Copilot Chat to explain to us the DB interactions in the `gallery` module of the mona gallery application
    <details>
    <summary> Solution </summary>
       
   ![threat-modelling-1](https://github.com/octodemo/universe-wip/assets/79184790/104c8234-4eb0-40d2-8ce4-949ac8cc6571)
    </details>

    
2. In the `storage` module lets ask GitHub Copilot Chat to explain to us the threat landscape of the `BlobController.java` code
    <details>
    <summary> Solution </summary>
        
   ![threat-model-2](https://github.com/octodemo/universe-wip/assets/79184790/ce465948-c039-482f-bba4-1890230d48ce)

    </details>
