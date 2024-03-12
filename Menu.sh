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
YELLOW='\033[0;33m'
RESET='\033[0m'

#clearing screen
clear

#setting to full screen
printf '\033[8;999;999t'

#login function
Login()
{	
	#takes input and checks user exists, if so checks password is correct & logs in 
	if grep -q "^$Uname:" UPP.db; then
		echo "Please enter password."
		read password
		storedPassword=$(grep "^$Uname:" UPP.db | cut -d: -f2)
			if [ "$password" = "$storedPassword" ]; then
					echo "Welcome $Uname"
					# adds a time stamp of when user logged in. 
					echo "$Uname logged in on $(date "+%D %r")" >> Usage.db
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
	echo -e "${YELLOW}3 for Reset your password${RESET}"
	echo -e "${RED}BYE for Exit${RESET}"
	echo -e "Please Enter Selection:"
	read Sel
	MenuSel "$Sel"
}


#Menu case 
#When a selection is made a log is entered into the Usage.db file
MenuSel()
{

case $(echo "$1" | tr '[:upper:]' '[:lower:]') in
	1) echo "$Uname ran the FIFO simulator at $(date "+%D %r")" >> Usage.db
		sh FIFO.sh;;
        2) echo "$Uname ran the LIFO simulator at $(date "+%D %r")" >> Usage.db
		sh LIFO.sh;;
	3) echo "$Uname reset their password at $(date "+%D %r")" >> Usage.db
		sh resetP.sh "$Uname";;
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

