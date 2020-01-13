#!/bin/bash

#Enter script name
if [ ! $1 ]; then
 echo "Please enter text"
 exit 1
elif [ -e $1 ]; then
 echo "Script already exists"
 exit 1
fi
dir=~/Desktop
filename=$dir/$1


echo "Write in your script to be saved, type !exit when done."
while : ; do
 echo -n "$ "; read input
 if [ "$input" == "!exit" ]; then
  $clear
  echo "Script has been successfully saved to" $filename"!"
  break

 else
 echo $input >> $filename
 fi
done
echo "Setting up permissions for the script.."

echo "Enter (1) for User permission OR (2) for Global permission"
select yn in "User" "Global" "Cancel"; do
 case $yn in 
  User ) chmod u+x $filename; echo "User set successfully!"; break;
  Global ) chmod +x $filename; echo "Global set successfully!"; break;
  Cancel ) exit;;
 esac
done
