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

# Functions for the FIFO simulator: Pushing an item onto the stack, popping an item from the stack, and clearing the stack.

Push()
{
	echo "Pushing $1 onto the stack."
	echo $1 >> stack.txt
	sleep 1
}

Pop()
{
	if [ -s stack.txt ]; then
		lines=$(wc -l < stack.txt)
		if [ "$lines" -gt 0 ]; then
			firstLine=$(head -n 1 stack.txt)
			tail -n +2 stack.txt > tmp_stack.txt && mv tmp_stack.txt stack.txt
			echo "Popping $firstLine from the stack."
		else
			echo "Nothing in stack"
		fi
	else
		echo "Nothing in stack"
	fi
	sleep 1
}

clearStack()
{
	> stack.txt
}

# Clearing the screen
clear

Uname="$1"

echo "Welcome to the FIFO Simulator"

ProgressBar

# Simulation - pushing & popping elements from the stack
# Last Pop should print that there is nothing in the stack

Push "First item"
Push "Second item"
Push "Third item"
Push "Final Item"

echo "Popping items from the stack:"
Pop
Pop
Pop
Pop
Pop

return 0

exit
