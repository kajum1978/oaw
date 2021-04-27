# oaw
### Installation:
Important: You need at least 3 CPUs

1- Download repository and extract to a directory. You can use git clone.
* **sudo apt-get install git git-lfs**
* **git clone https://github.com/kajum1978/oaw.git**

2- At directory execute one:
* **sudo ./install.sh (es|en)**

3- Ask the questions for the install.sh script. If a step fail you can relaunch it (script answer you if you want to resume), or:
* **sudo ./install.sh (es|en) resume [step failed]**
    
    Note: you can execute one step individually with:
* **sudo ./install (es|en) execute (step do you want)** 
            
4- Optional: After install, you should configure project properties files. They are in /usr/local/share/oaw/customMaven.

    Note: At Directory /usr/local/share/oaw/oaw there are the source files used for compile the project.

5- Execute one:
  * **sudo ./build_oaw.sh es**
    
6- Start oaw execute:
  * **sudo ./start_oaw.sh**
    
7- Go to web browser to http://localhost:8080/oaw
