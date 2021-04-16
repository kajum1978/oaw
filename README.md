# oaw
### Installation:

1- Download repository and extract to a directory. You can use git clone.

2- In the directory execute one:
* sudo ./install.sh es    #for Spanish language
* sudo ./install.sh en    #for English language

3- Ask the questions for the install.sh script. If a step fail, you can relaunch with:
    * sudo ./install.sh es resume (step failed)     example: sudo ./install.sh es resume 6
        or
    * sudo ./install.sh en resume (step failed)     example: sudo ./install.sh en resume 6
    
    Note: you can execute one step individually with:
        sudo ./install es execute (step do you want) example: sudo ./install.sh es execute 8
            or
        sudo ./install en execute (step do you want) example: sudo ./install.sh es execute 8

4- Optional: After install, you should configure project properties files. They are in /usr/local/share/oaw/customMaven
   In the Directory /usr/local/share/oaw/oaw there are the source files used for compile the proyect.

5- Execute one:
  * sudo build_oaw.sh es   #for Spanish language
  * sudo build_oaw.sh en   #for English language
    
6- Start oaw execute:
  * sudo start_oaw.sh
    
7- Go to web browser to http://localhost:8080/oaw
