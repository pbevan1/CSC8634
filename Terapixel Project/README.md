# CSC8634 Performance evaluation of Terapixel rendering in Cloud (Super)Computing

## Instructions rtelating to file location and running of code

Please open `Terapixel Project\config\global.dcf` and ensure all libraries listed are installed on your machine.

Please set `\Terapixel Project` as working directory and run the following commands:
`library(ProjectTemplate)`
`load.project()`
ProjectTemplate will need to be installed using install.packages('ProjectTemplate') if it is not currently installed.

Data munging will be automatic upon loading the project, and is saved at `Terapixel Project\munge\01-A.R`.

Report and structured abstract saved in `Terapixel Project\reports` as pdf files as well as rmd files.

Code for saved png images used in report is saved in `Terapixel Project\src\eda.R`

The shiny dashboard can be located at `Terapixel Project\app.R`. Run all code in file to launch app. The dashboard is best viewed in full screen to ensure the plots are sized correctly.
