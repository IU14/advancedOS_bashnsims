#!/bin/sh

# Function to show a progress bar

ProgressBar()
{
	iterations=20
	echo -n "Progress: ["
    
	i=0
 	while [ "$i" -lt "$iterations" ]; do
		percentage=$(( (i * 100) / iterations ))
		printf "#"
        	i=$((i + 1))
        	sleep 0.1  
    done
    
    echo "] 100%"
}


#functions for the LIFO simulator, adding an item (push), and removing an item (pop) and to also clear the stack afterwards 

Push()
{
	echo "Pushing $1 onto the stack"
	echo "$1" >> stack.txt
	sleep 1
}

Pop()
{
	if [ -s stack.txt ]; then
		lines=$(wc -l < stack.txt)
        	if [ "$lines" -gt 1 ]; then
			head -n $((lines -1)) stack.txt > tempstack.txt
			lastLine=$(tail -n 1 stack.txt)
			mv tempstack.txt stack.txt
			echo "Popping $lastLine from the stack."
			sleep 1
			
		else
			lastLine=$(cat stack.txt)
			> stack.txt
			echo "Popping $lastLine from the stack."
			
		fi
	else
		echo "Nothing in stack"
	fi
	
}

clearStack()
{
	> stack.txt
}

# function to take the data from the simdata file and then runs it through the Push Function
readData()
{
    dataFile="simdata_$Uname.job"
    if [ -f "$dataFile" ]; then
        echo "Reading Simulation Data from file."
        while IFS= read -r byte; do
            Push "$byte"
        done < "$dataFile"
    else
        echo "No sim data"
    fi
}

###############
#Running code #
###############


#clearing screen
clear

Uname="$1"

echo "Welcome to the LIFO Simulator"

ProgressBar

#Simulation - pushing & popping elements from the stack
# Last Pop sould print that the is nothing in the stack

readData

echo "Popping items from the stack:"
Pop
Pop
Pop
Pop
Pop
Pop
Pop
Pop
Pop
Pop

return 0

exit
