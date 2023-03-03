
# Final Projects

## Overview

The purpose of the project is to apply the knowledge learned in the class to real-world problems. Projects will help students gain working experience in data visualization, data processing, data exploration, and development of a web app, here we use R and RShiny to approach such goals. 

## Directory Tree
```R
IE6600-final-project
|   README.md # you may have your project introduction here
|   project_guideline.pdf
|
+---shinyApp
|   |   global.R # global settings
|   |   server.R # server
|   |   ui.R # ui
|   |   
|   \---www
|       +---figures # put your figures here if necessary
|       \---functions # put your created functions 
\---slides # you may store your presentation materials here
```

## Getting Started

>If you are new to git and github, please watch the video tutorial below first: [Git and GitHub for Beginners Tutorial](https://www.youtube.com/watch?v=tRZGeaHPoaw) by Kevin Stratvert

> git cheatsheet: https://education.github.com/git-cheat-sheet-education.pdf \
> git overview book: https://git-scm.com/book/en/v2

1. Install [git](https://www.git-scm.com/)

2. Clone this repository to your local directory:

    `git clone https://github.com/zhenyuanlu/IE6600-final-project.git`

3. Go over the project instructions in the pdf:

    <a href="https://zhenyuanlu.com/courses/projects/final_project_guideline.pdf" target="_blank">RShiny Project Instruction</a>

4. You can start to develop the web app in the shinyApp folder now.



## Submit Your Work on Github
Upon the completion of the RShiny app development, each team member should upload the team project folder to their individual github repo.

Do not include the dataset, just put the dataset link in the README.md. 

## Deploy Your Work on shinyapps.io

1. Register an account at 
   
   https://www.shinyapps.io/
2. Install [rsconnect](https://github.com/rstudio/rsconnect) in RStudio

    `install.packages('rsconnect')`

3. Go to your shinyapps.io dashboard and click on your username on the right top corner. 
4. Then you will see a dropdown menu with three tabs, `profile`, `tokens`, and `logout`. Click on `tokens`, and you will see the token page. 
5. `show` your token details, then `show` the secrect code (you may see a code chunk as below). Copy this rsconnect code to your Rstudio commend window. 
    ```
    rsconnect::setAccountInfo(name='<username>',
			  token='<token>',
			  secret='<secretCode>')
    ```
6. Deploy your local RShiny App
   
    `rsconnect::deployApp('yourAppDirectory')`

One teammember makes one deployment on the behalf of the whole team.

## Post Your Work Intro on Course Platform
Finally, follow the project instruction and post a note with the all your members' github links, shinyapps.io demo page, and brief intro on the course platform. 

One teammember makes one submission on the behalf of the whole team.

