#!/bin/sh

#Admin script allows users to be created /  modified and saved to the database (UPP.db) 


#Function to check if user alreay exists 
checkUser()
{
	grep -q "^$1:" UPP.db
}
#Function to check user length
userLength()
{	
	if [ ${#1} -eq 5 ]; then
		return 0
	else
		return 1
	fi
}

# Function to add / modify users 
# Takes local variables and checks they exits in the db - if not allows creation of the user, if they do allows modification of the user

setUser() {
    local user password pin

    # Creates the User variable from input
    echo "Enter a Username to check:"
    read user 

	# checks username is 5 characters long
	if userLength "$user"; then
		continue								
	else
		#starts the program again
		StartUp2
	fi

	while true; do
    #checks if user exits, if they do gives option to modify user(delete, reset password.)
    # If user does not exist, asks to create a user and then goes on to create user setting a password and pin
    if checkUser "$user"; then
        echo "User already exists, would you like to modify? (Y or bye to exit)"
        read choice
        case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in   
            y|yes)
                # Code to modify user
                echo "What would you like to do? Delete the user[D] or reset password[R]"
		read choice2
		case "$(echo "$choice2" | tr '[:upper:]' '[:lower:]')" in   
			d) 
				# code to delete user
				deleteUser
				;;
			r) 
				#code to reset password
				resetPassword
				;;
			bye)	
				# code that calls the bye(exit) function
				echo "Exiting..."
				sh Menu.sh ExitFunc
				;;
			*)
				# to implement invalid choice, asking question again
				echo "invalid choice please select again" >&2
				;;
		esac
			
                ;;
	    bye)
		echo Exiting...
		sh Menu.sh ExitFunc
		;;

            *)
                echo "invalid choice" >&2
                ;;
        esac
    else
        echo "User does not exist, would you like to create new user? (Y or any key to exit)"
        read choice
        case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
            y|yes)
		# Code to create a password, accounts for case insensitivity and checks for a letter. 
	         while true; do
        	            echo "Create Password (password must contain at least one letter & one number, and be 5 five characters in length):"
                	    read -s password
		    		passwordLower=$(echo "$password" | tr '[:upper:]' '[:lower:]')
                    		if [[ "$passwordLower" =~ ^[a-zA-Z0-9]{5}$ ]]; then
                        		echo "Re-enter Password:"
                        		read -s checkPassword
					checkPasswordLower=$(echo "$checkPassword" | tr '[:upper:]' '[:lower:]')
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
		
		# code to create a 3 number pin. 
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
                
                # Once password & pin are succesfully created, user is to the database upon creation
                echo "$user:$password:$pin" >> UPP.db
                echo "User Created"
                exit
                ;;

	    bye) 
		echo Exiting...
		sh Menu.sh ExitFunc
		;;
		
            *)
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

#reset password using PIN
resetPassword()
{
    #sets the chosen user to a variable (-f1 is the position of the username in the db)
    userCheck=$(grep -n "^$user:" UPP.db)
    if [ -z "$userCheck" ]; then
        echo "User not found in the database."
        return 1
    fi
    
    # Retrieves the PIN from the user (-f3 is the position of the pin in the db)
    storedPin=$(grep "^$user:" UPP.db | cut -d: -f3)

    echo "Please enter user's PIN to Reset Password:"
    read -s pin

    # Compares the entered PIN with the stored PIN, then if exists asks to re-enter, then allows the password to be reset
    if [ "$pin" = "$storedPin" ]; then
	echo "Re-enter PIN:"
              read -s checkPin
		if [ "$checkPin" = "$pin" ]; then
        		echo "Enter new password (password must contain one letter & at least one number):"
			read -s newPassword
			newPasswordLower=$(echo "$newPassword" | tr '[:upper:]' '[:lower:]')
				if [[ "$newPasswordLower" =~ [a-z] && "$newPasswordLower" =~ [0-9] ]]; then
					#updates the password field
					username=$(echo "$userCheck" | cut -d: -f2)
					updatedUser="$username:$newPassword:$pin"
					temp=$(mktemp)
                			grep -v "^$user:" UPP.db > "$temp"
               				echo "$updatedUser" >> "$temp"
               				mv "$temp" UPP.db					
					echo "Password updated"
        		else
				echo "Invalid password, password not updated"
			fi
		 else 
		 	echo "Invalid pin, password not updated."
		fi
    	else
        echo "Invalid PIN."
    fi
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
