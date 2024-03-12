#!/bin/sh

#function to show loading bar 

LoadingBar()
{
	iterations=20
	echo -n "Loading: ["
    
	i=0
 	while [ "$i" -lt "$iterations" ]; do
		percentage=$(( (i * 100) / iterations ))
		printf "#"
        	i=$((i + 1))
        	sleep 0.1  
    done
    
    echo "] 100%"
}



#defining colours for the menu using asni codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

#clearing screen
clear

#setting to full screen
printf '\033[8;999;999t'

#login function
Login()
{	
	#takes input and checks user exists
	if grep -q "^$Uname:" UPP.db; then
		echo "Please enter password."
		read password
		storedPassword=$(grep "^$Uname:" UPP.db | cut -d: -f2)
			if [ "$password" = "$storedPassword" ]; then
					echo "Welcome $Uname"
					Menu
				else
					echo "Invalid password." >&2
				fi
	else
		echo "Invalid username"
		exit
	fi
	
}


#Menu Display & Select

Menu()
{
	LoadingBar
	echo -e "Make your selection or type bye to exit:" 
	echo -e "${BLUE}1 for FIFO${RESET}"
	echo -e "${GREEN}2 for LIFO${RESET}"
	echo -e "${RED}BYE for Exit${RESET}"
	echo -e "Please Enter Selection:"
	read Sel
	MenuSel "$Sel"
}


#Menu case
MenuSel()
{

case $(echo "$1" | tr '[:upper:]' '[:lower:]') in
	1) sh FIFO.sh;;
        2) sh LIFO.sh;;
	bye) sh Exit.sh ExitFunc;;
	*) echo -e "${MAGENTA}Invalid Selection${RESET}"
	sleep 1
	Menu;;
esac
}

#####################
### RUNNING CODE ####
#####################

#Store username in global var
echo "Please Enter Username"
read Uname

Login


