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
Base=$(basename $2)
FP=$(readlink -f $2)
#Checks if file exists and prompts removal.
while [ -f $1$Base ]; do
 echo "${yf}The file already exists. Do you want to replace? Y/N${reset}"
 echo -n "$ "; read cinput
 shopt -s nocasematch
 if [[ $cinput == Y ]]; then
  cd $1
  git rm $Base
  git commit -m "Remove"
  echo "${yf}Successfully removed!${reset}"
  break
 elif [[ $cinput == N ]]; then
  exit 1
 else
  echo "${rf}Invalid input.${reset}"
 fi
done
if ! cp $FP $1; then
 exit
fi
if ! cd $1; then
 exit
fi
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
  echo "${rf}Invalid response.${reset}"
 fi
done
clear
git commit -m "Add"
echo ""
echo "${yf}Do you want to push? Y/N${reset}"
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
  echo "${rf}Invalid response.${reset}"
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
echo "${yf}Enter the number of remote Git profile or${reset} ${wf}0${reset}${yf} to create one.${reset}"
while true; do
 func
 echo -n "$ "; read rinput
 if [[ $rinput -eq 0 ]] && [[ $((rinput)) = $rinput ]]; then
  echo -n "${wf}The wanted remote name: ${reset}"; read rname
  echo ""
  echo -n "${wf}Link to Git repository: ${reset}"; read link
  git remote add $rname $link

  echo ""
  echo "${yf}Successfully added!${reset}"
 elif [[ $rinput -le $i-1 ]] && [[ $((rinput)) = $rinput ]] && [[ $rinput -gt -1 ]]; then
  break
 else
  echo ""
  echo "${rf}Enter a valid number.${reset}"
fi
done

clear
echo "${wf}You have choosen${reset} ${rf}${list[$rinput]}${reset}"

echo ""
echo "${yf}Available branches: ${reset}" git branch
echo "${wf}Write branch name: ${reset}"
echo -n "$ "; read branch
echo ""
git push "${list[$rinput]}" $branch
echo "${wf}Done!${reset}"
