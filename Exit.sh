#!/bin/sh

#script to host the universal exit function

# variables 
Uname="$1"
loggedInTime="$2"


# exit function that checks user/admin wants to exit and then exits. 
# stores the logged off time and the duration of the session to the usage.db file 
ExitFunc()
{
while true; do
    echo "Do you really want to exit? (Y/n)"
    read choice
    case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
        y|yes) 
            echo "GoodBye $Uname."
	    echo " $Uname logged off at $(date "+%D %r")" >> Usage.db
	    loggedOffTime=$(date "+%s")
	    sessionDuration=$((loggedOffTime-loggedInTime))
	    if [ $Uname == "Admin" ]; then
		ExitBar
		exit 
	    else 
	    	echo "$Uname 's session ended after $((sessionDuration / 60)) minutes and $((sessionDuration % 60)) seconds." >> Usage.db
	    	ExitBar
	    fi
	    exit		
	    ;;
        n|no) 
            echo "Continuing"
            break ;;
        *) 
            echo "Invalid choice. Please enter Y or n." ;;
    esac
done
}

#code for the animated exit bar
ExitBar()
{
	iterations=20
   	echo -n "Exiting: ["
    
   	i=0
  	 while [ "$i" -lt "$iterations" ]; do
        	percentage=$(( (i * 100) / iterations ))
        	printf "#"
        	i=$((i + 1))
        	sleep 0.1  
    	done
    
    	echo "] 100%"
}

#################
#Running code ###
#################

ExitFunc