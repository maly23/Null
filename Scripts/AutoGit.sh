#!/bin/bash

#Auto Git push & commit script written in bash.

#Usage: ./AutoGit "Git path" "File/folder to commit path"

wf=$(tput setaf 7)
rf=$(tput setaf 1)
yf=$(tput setaf 3)
reset=$(tput sgr0)
Path=$1
File=$2
if [[ ! $1 ]] || [[ ! $2 ]]; then
  echo "${wf}Usage: ./AutoGit \"Git path\" \"File/folder to commit or push path\"${reset}"
  exit 1
fi

if ! cp $2 $1; then
 exit 1
fi

if ! cd $1; then
 exit 1
fi
Base=$(basename $2)
#Checks if file exists and prompts removal.
check="ls ${1} | grep ${Base}"
while $check; do
 echo "${yf}The file already exists. Do you want to replace? Y/N${reset}"
 echo -n "$ "; read cinput
 shopt -s nocasematch
 if [[ $cinput == Y ]]; then
  git rm $Base
  git commit -m "commit"
  echo "${yf}Successfully removed!${reset}"
  break
 elif [[ $cinput == N ]]; then
  exit 1
 else
  echo "${rf}Invalid input.${reset}"
 fi
done
git add $Base
echo ""
echo "Do you want to commit? Y/N"
fcommit () {
echo -n "$ "; read commit
}
while true; do
 fcommit
 shopt -s nocasematch
 if [[ $commit == Y ]]; then
  break
 elif [[ $commit == N ]]; then
  exit 1
 else
  echo "Invalid response."
 fi
done
clear
git commit -m "commit"
echo ""
echo "Do you want to push? Y/N"
fpush () {
echo -n "$ "; read push
}
while true; do
 fpush
#makes input case insensitive
 shopt -s nocasematch
 if [[ $push == Y ]]; then
  break
 elif [[ $push == N ]]; then
  exit
 else
  echo "Invalid response."
 fi
done
clear
#Git Remotes call func.
func () {
 remotes=$(git remote show)
 i=1
 for j in $remotes; do
 echo "$i ) $j"
 list[i]=$j
 i=$((i+1))
 done
}

clear
echo "Enter the number of remote Git profile or 0 to create one"
while true; do
 func
 echo -n "$ "; read rinput
 if [[ $rinput -eq 0 ]] && [[ $((rinput)) = $rinput ]]; then
  echo -n "The wanted remote name: "; read rname
  echo ""
  echo -n "Link to Git repository: "; read link
  git remote add $rname $link

  echo ""
  echo "Successfully added!"
 elif [[ $rinput -le $i-1 ]] && [[ $((rinput)) = $rinput ]] && [[ $rinput -gt -1 ]]; then
  break
 else
  echo ""
  echo "Enter a valid number."
fi
done

clear
echo "You have choosen ${list[$rinput]}"

echo ""
echo "Branch name: "
echo -n "$ "; read branch
echo ""
git push "${list[$rinput]}" $branch
clear
echo "Successfully pushed to ${list[$rinput]} $branch"
