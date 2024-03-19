# advancedOS_bashnsims
Final year -  assignment 1 for Advanced Operating Systems. Bash scripting. 

## TASK
_______

Create a menu system which is for a simple queue simulator.

User information must be stored in a 'database' type file. 

Admin must be able to delete/update users once a correct PIN is given. Although changing a password can be done by admin and users. 

Once everything is validated it must be pished to the 'database file'. <i> UPP.db </i>

The system must keep a record of all user activity which is to be stored in <i> Usage.db</i>. 
An additional admin script file is also needed such that admin can get useful information on a per user / per sim bases. 
They must get details of: total time spent, most poopular sim (per user), most pop sim overall and a ranking list of users who has used the system the most. 

When a user logs in the system checks to see if the 'simdata_<username>.joib file exists [this file keeps data of the simulated data per user?] Then prompts the user if they would like to use pre-define sim data or enter a new set.

## HOW TO LAUNCH

_____

If entering the system as a user, run the command sh Menu.sh from the command line. 
If entering the system as an administretor run the command sh Admin.sh from the command line. 

