#!/bin/sh


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

#Menu Display & Select

Menu()
{
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
	bye) ExitFunc;;
	*) echo -e "${MAGENTA}Invalid Selection${RESET}"
	sleep 1
	Menu;;
esac
}

ExitFunc()
{
while true; do
    echo "Do you really want to exit? (Y/n)"
    read choice
    case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
        y|yes) 
            echo "GoodBye"
	    exit ;;
        n|no) 
            echo "Continuing"
            break ;;
        *) 
            echo "Invalid choice. Please enter Y or n." ;;
    esac
done
}
#####################
### RUNNING CODE ####
#####################

#Store username in global var
echo "Please Enter Username"
read Uname

#runs within a clean subshell
(
	while true;do
		Menu
	done
)
