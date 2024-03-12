#!/bin/sh

#script to host the universal exit function

ExitFunc()
{
while true; do
    echo "Do you really want to exit? (Y/n)"
    read choice
    case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
        y|yes) 
            echo "GoodBye."
	    echo "$Uname logged off at $(date "+%D %r")" >> Usage.db
	    ExitBar
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


ExitFunc