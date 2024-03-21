#!/bin/sh

Uname=$1

#finds how long the user has used the system for
	#vars 
	usageFile="Usage.db"
	totalMins=0
	totalSecs=0

	# if the line has the username & session in it, extract the mins & secs and adds together
	#while IFS= read -r line; do
		#case $line in
			#*$Uname 's session*)
				#mins=$((echo "$line" | grep -o '[0-9]* minutes' | cut -d' ' -f1))
				#if [ -n "$mins" ]; then
					totalMins=$((totalMins + mins))
				#fi
				#secs=$((echo "$line" | grep -o '[0-9]* seconds' | cut -d' ' -f1))
				#if [ -n "$secs" ]; then
					totalSecs=$((totalSecs + secs))
				#fi
		#esac
	#done < "$usageFile"

	# code that adjusts total if more than 60 secs 
	#if [ "$totalSecs" -ge 60 ]; then
    		#extraMins=$((totalSecs / 60))
   		#totalMins=$((totalMins + extraMins))
    		#totalSecs=$((totalSecs % 60))
	#fi 

	echo "$Uname 's total session time is $totalMins minutes and $totalSecs seconds."