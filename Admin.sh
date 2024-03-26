#!/bin/sh

#Admin script allows users to be created /  modified and saved to the database (UPP.db) And shows selected user usage information. 

#Function to check if user already exists in the database file
checkUser()
{
	grep -q "^$1:" UPP.db
}

#Function to check username length (has to be 5 characters) 
userLength()
{	
	if [ ${#1} -eq 5 ]; then
		return 0
	else
		return 1
	fi
}

# Function to add / modify users 
# Takes local variables and checks they exits in the db - if not allows creation of the user, if they do allow modification of the user

setUser() {
    #VARIABLES	 
    local user password pin

    # Creates the User variable from input
    echo "Enter a Username to check:"
    read Uname 

	# checks username is 5 characters long
	if userLength "$Uname"; then
		continue								
	else
		#starts the program again
		StartUp2
	fi

	while true; do

    # checks if user exits, if they do gives option to modify user(delete, reset password.)
    # If user does not exist, asks to create a user and then goes on to create user setting a password and pin

    if checkUser "$Uname"; then
        echo "User already exists, would you like to modify[M] or check Simulation[S] data for user? (M/S or bye to exit)"
        read choice
        case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in   
            m)
                # using a case statment to select how to modify a user
                echo "What would you like to do? Delete the user[D] or reset password[R]"
		read choice2
		case "$(echo "$choice2" | tr '[:upper:]' '[:lower:]')" in   
			d) 
				# code to delete user
				deleteUser
				;;
			r) 
				#code to reset password
				sh resetP.sh "$Uname"
				;;
			bye)	
				# code that calls the bye(exit) function
				echo "Exiting..."
				sh Exit.sh ExitFunc
				;;
			*)
				# to implement invalid choice, asking question again
				echo "invalid choice please select again" >&2
				;;
		esac	
                ;;
	    s)
		#code to check sim data for the user
		echo Fetching user simulation statistics .. 
		fecthSimData
		;;
	    bye)
		echo Exiting...
		sh Exit.sh ExitFunc
		exit
		;;

            *)
                echo "invalid choice" >&2
                ;;
        esac
    else
	# if user does not exist gives choice to create user with that name 
        echo "User does not exist, would you like to create new user? (Y or bye to exit)"
        read choice
        case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
            y|yes)
		# Code to create a password, accounts for case insensitivity, checks there is a number and is only 5 characters long 
	         while true; do
        	            echo "Create Password (password must contain at least one letter & one number, and be 5 five characters in length):"
                	    read -s password
		    		passwordLower=$(echo "$password" | tr '[:upper:]' '[:lower:]')
                    		if [[ "$passwordLower" =~ ^[a-zA-Z0-9]{5}$ ]]; then
                        		echo "Re-enter Password:"
                        		read -s checkPassword
					checkPasswordLower=$(echo "$checkPassword" | tr '[:upper:]' '[:lower:]')
						# checks that both entered passwords match 
                        			if [ "$checkPasswordLower" = "$passwordLower" ]; then
                            				echo "Password accepted."
                            			break
                        		else
                            			echo "Passwords do not match." 
                        		fi
				
                    		else
                        		echo "Password must contain at least one uppercase letter, one lowercase letter, and one number." >&2
                    		fi
                	done
		
		# code to create a 3 number pin. Checks the pin is 3 numbers only, 
                while true; do
                    echo "Create PIN (PIN must be 3 numbers):"
                    read -s pin
                    if [[ "$pin" =~ ^[0-9]{3}$ ]]; then
                        echo "Re-enter PIN:"
                        read -s checkPin
                        if [ "$checkPin" = "$pin" ]; then
                            echo "PIN accepted."
                            break
                        else
                            echo "PINs do not match."
                        fi
                    else
                        echo "PIN must be 3 numbers." >&2 
                    fi
                done
                
                # Once password & pin are succesfully created, user is added to the database upon creation
                echo "$Uname:$password:$pin" >> UPP.db
                echo "User Created"
                exit
                ;;

	    bye) 
		# runs universal exit function, sets "admin" as username 
		echo Exiting...
		sh Exit.sh "Admin" 
		exit
		;;
		
            *)
		# reruns question if invalid option chosen
                echo "Invalid option" >&2
                return 1
                ;;
        esac
    fi
done
}

#delete user using PIN
deleteUser()
{
    #sets the  user details to a variable
    lineCheck=$(grep -n "^$user:" UPP.db | cut -d: -f1)
    
    # Retrieves the PIN from the variable (-f3 is the position of the pin in the document)
    storedPin=$(grep "^$user:" UPP.db | cut -d: -f3)

    echo "Please enter user's PIN to delete:"
    read -s pin

    # Compares the entered PIN with the stored PIN, if it matches asks to re enter pin, then deletes user if mathed. 
    if [ "$pin" = "$storedPin" ]; then
	echo "Re-enter PIN:"
              read -s checkPin
		if [ "$checkPin" = "$pin" ]; then
        		echo "PIN accepted. User deleted"
        		grep -v "^$user:" UPP.db > temp.db
       		 mv temp.db UPP.db
		 else 
		 	echo "invalid pin, user not deleted."
		fi
    	else
        echo "Invalid PIN."
    fi
    exit
}

#Function to get simulation data for the selected User 
fecthSimData()
{
	sleep 1

	#finds how many times they have logged in
	countLogIn=$(grep -oh "$Uname logged in" Usage.db | wc -l)
	echo $Uname has logged in $countLogIn times

	#finds how many times they ran each sim and sets to a variable, then compares. 
	countFIFO=$(grep -oh "$Uname ran the FIFO" Usage.db | wc -l)
	countLIFO=$(grep -oh "$Uname ran the LIFO" Usage.db | wc -l)
	echo "$Uname ran the FIFO sim $countFIFO time(s) and the LIFO sim $countLIFO time(s)"
	if [ $countFIFO -gt $countLIFO ]; then
		echo "the FIFO sim is $Uname's favourite";	
	elif [ 	$countLIFO -gt $countFIFO ]; then
		echo "the LIFO sim is $Uname's favourite";
	elif [ $countFIFO -ge 1 ] && [ $countLIFO -ge 1 ] && [ $countFIFO -eq $countLIFO ]; then
		echo "The simulations are equally favoured by $Uname";
	else
		echo "not enough user data";
	fi
	 
	# ideally, the program would now calculate the total time the user was in the system but a seemily unfixable syntax error in the function stopped it all running
	# moved to it's own shellscript so it can be seen for the assignment, but am aware it does not run. 
	# calcTotalSession
	#sh calcTotalSession.sh "$Uname"


	#Asks admin they want to now see universal data
	echo "Would you like to see all user data? Y or bye for exit"
	read choice
	case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
	    y)
		#code for universal data
		# finds how many times any sim was run by anyone & compares
		countAllFIFO=$(grep -oh "ran the FIFO" Usage.db | wc -l)
		countAllLIFO=$(grep -oh "ran the LIFO" Usage.db | wc -l)
		if [ $countAllFIFO -gt $countAllLIFO ]; then
			echo " Users have run the FIFO sim $countAllFIFO time(s) and the LIFO sim $countAllLIFO time(s) making FIFO sim the global favourite"

		else
			echo " Users have run the FIFO sim $countAllFIFO time(s) and the LIFO sim $countAllLIFO time(s) making LIFO sim the global favourite"
		fi
		;;

	    bye)
		# runs universal exit function 
		echo Exiting...
		sh Exit.sh "Admin" 
		exit
		;;
	    *)
		# reruns question if invalid option chosen
                echo "Invalid option" >&2
                return 1
                ;;

	esac

	#checks if admin would like to check another user or exit.
	echo "Would you like to like to check another user? Y or bye to exit."
	read choice2
	case "$(echo "$choice2" | tr '[:upper:]' '[:lower:]')" in
	     y) 
		StartUp
		;;
	    bye)
		# runs universal exit function 
		echo Exiting...
		sh Exit.sh "Admin" 
		exit
		;;
	    *)
		# reruns question if invalid option chosen
                echo "Invalid option" >&2
                return 1
                ;;

	esac
	    
	exit
}


# Start up Function
StartUp()
{
	clear
	echo "Welcome to the admin script, here you can Create or Modify a user."
	setUser
		
}

StartUp2()
{
	echo "Username is not the correct length, usernames must be 5 characters long."
	setUser
}


#####################
### RUNNING CODE ####
#####################

#Calls the start up function on running of script
StartUp

