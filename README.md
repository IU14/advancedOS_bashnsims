# advancedOS_bashnsims
Final year -  assignment 1 for Advanced Operating Systems. Bash scripting. 

## TASK
_______

Create a menu system which is for a simple queue simulator.
The menu has 2 options, that allows choice between FIFO and LIFO sim along with an exit command. 

The menu systems must be a bash script which launches another seperate script for the respective option. Once the sim has finished, must return to the menu. 
The bye command prompt to exit must be usuable at any time and have a confirmation (Y/N) from user input. 

This system will operate seperately from the host (OS) with a username / password system with verfication prior to the menu loading. therefore an admin script must be create that has the ability to create usernames, passwords and a PIN. 
This information must be stored in a 'database' type file. 
Admin must also be able to delete/update users once a correct PIN is given. 
Changing a password can be done by admin and users. 

Once everything is validated it must be pished to the 'database file'. <i> UPP.db </i>

The system must keep a record of all user activity. Specifically when they logged into the system. How long they used the system for and which sims were used. All this is to be stored in <i> Usage.db</i>. 
An additional admin script file is also needed such that admin can get useful information on a per user / per sim bases. 
They must get details of: total time spent, most poopular sim (per user), most pop sim overall and a ranking list of users who has used the system the most. 

When a user logs in the system checks to see if the 'simdata_<username>.joib file exists [this file keeps data of the simulated data per user?] Then prompts the user if they would like to use pre-define sim data or enter a new set. once decied the configs are to be overwritten & passed onto the selected scripts. 

## Checklist
_____

The checklist provides info from the markscheme as to specifics are expected.:
- [ ] Display Menu using entire screen
- [ ] Select correctly & launch on a clean screen
- [ ] Launch separate menu (place holder) files
- [ ] Ability to exit at any prompt via the “Bye” command (case insensitive)
- [ ] Prompt users if they really want to exit via a Y/n option (case insensitive) & repeat question until a valid choice is made
- [ ] After completion of a selected simulator user returns back to menu
- [ ] Suitable comments in code (comments must not exceed code)
- [ ] Usage of colour in the menu system
- [ ] Validate user correctly on entry (login correctly)
- [ ] Validate user password on entry (login correctly)
- [ ] Usage of appropriate functions (implemented)
- [ ] Correct usage of Global/Local variables
- [ ] Simple animation/ loading bar when menu start/exits & selection of simulater 
- [ ] Create separate admin script to add/ modify users to a database file
- [ ] Usernames and passwords are case insensitive & validated 
- [ ] On user creation request password/pin twice & check if both entries are the same
- [ ] Ability to delete user given correct PIN
- [ ] Ability to reset user password given correct PIN
- [ ] PIN validation on creation
- [ ] Accurate log recorded for user usage
- [ ] Complete implementation of admin script for usage analysis as outlined
- [ ] Correct implementation of sim data configuration & usage
- [ ] Correct implementation of LIFO & FIFO scripts
- [ ] Correct and complete implementation (as outlined above)
- [ ] 800 words write up

## Requirements, banned code & Tips 
_____

- Cannot use awk, sed or built in menu generatora
- Must use grep and cutting
- Must work on Tiny Core virtual machine - therefore basic code must be used, unable to install packages in TC.
- There are no arrays in TC - convert into an arguement using loops.
- No c like iteration i.e i=0; i <5, i++
- Head, tail, sort, cat, echo, tr, >>, > , /dev/null, exit & status are expected
- Look into select by primary field with the sort arguement.
- Use of WinSCP encouraged. 
