#!/bin/sh

#seperate script for the reset password function as both admins and users need to be able to access it

Uname="$1"

#reset password using PIN
resetPassword()
{
    #sets the chosen user to a variable (-f1 is the position of the username in the db)
    userCheck=$(grep -n "^$Uname:" UPP.db)
    if [ -z "$userCheck" ]; then
        echo "User not found in the database."
        return 1
    fi
    
    # Retrieves the PIN from the user (-f3 is the position of the pin in the db)
    storedPin=$(grep "^$Uname:" UPP.db | cut -d: -f3)

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
                			grep -v "^$Uname:" UPP.db > "$temp"
               				echo "$updatedUser" >> "$temp"
               				mv "$temp" UPP.db					
					echo "Password updated"
					exit
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

resetPassword
