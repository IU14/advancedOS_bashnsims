#!/bin/sh

#Admin script allows users to be created /  modified and saved to the database (UPP.db) 

#Fucntion to check if user alreay exists
checkUser()
{
	grep -q "^$1:" UPP.db
}

# Fucntion to add / modify users 
# Takes local variables and checks they exits in the db - if not allows creation of the user, if they do allows modification of the user

setUser() {
    local user password pin

    # User
    echo "Enter a Username to check:"
    read user 

    #checks if user exits, if they do gives option to modify user(delete, reset password.)
    # If user does not exist, asks to craate a user and then goes on to create user setting a password and pin
    if checkUser "$user"; then
        echo "User already exists, would you like to modify? (Y or any key to exit)"
        read choice
        case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in   
            y|yes)
                # Code to modify user
                echo "What would you like to do? Delete the user[D] or reset password[R]"
		read choice2
		case "$(echo "$choice2" | tr '[:upper:]' '[:lower:]')" in   
			d) 
				# code to delete user
				echo "User deletion not yet implemented"
				;;
			r) 
				#code to reset password
				echo "Password Reset not yet implemented"
				;;
			*)
				# to implement invalid choice, asking question again
				echo "invalid choice please select again"
				;;
		esac
			
                ;;
            *)
                echo "Exiting"
                return 1
                ;;
        esac
    else
        echo "User does not exist, would you like to create new user? (Y or any key to exit)"
        read choice
        case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
            y|yes)
                # Code to create a password, accounts for case insensitivity and checks for a letter. 
                while true; do
                    echo "Create Password (password must contain one letter & at least one number):"
                    read -s password
		    passwordLower=$(echo "$password" | tr '[:upper:]' '[:lower:]')
                    if [[ "$passwordLower" =~ [a-z] && "$passwordLower" =~ [0-9] ]]; then
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
                        echo "Password must contain at least one uppercase letter, one lowercase letter, and one number."
                    fi
                done
                
                # code to create a 4 number pin. 
                while true; do
                    echo "Create PIN (PIN must be 4 numbers):"
                    read -s pin
                    if [[ "$pin" =~ ^[0-9]{4}$ ]]; then
                        echo "Re-enter PIN:"
                        read -s checkPin
                        if [ "$checkPin" = "$pin" ]; then
                            echo "PIN accepted."
                            break
                        else
                            echo "PINs do not match."
                        fi
                    else
                        echo "PIN must be 4 numbers."
                    fi
                done
                
                # Once password & pin are succesfully created, user is to the database upon creation
                echo "$user:$password:$pin" >> UPP.db
                echo "User Created"
                return 0
                ;;
            *)
                echo "Exiting"
                return 1
                ;;
        esac
    fi
}

#delete user using PIN
deleteUser()
{
	echo "Function not yet implemented"
	exit
}

#reset password using PIN
resetPassword()
{
	echo "Function not yet implemented"
	exit
}

# Start up Function
StartUp()
{
	clear
	echo "Welcome to the admin script, here you can Create or Modify a user."
	setUser
		
}

#Calls the start up function on running of script
StartUp
