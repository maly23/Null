#!/bin/bash

#Auto Git push & commit script written in bash.

#Usage: ./AutoGit "Git path" "File/folder to commit path"

Path=$1
File=$2
Base=$(basename $2)
if [[ ! $1 ]] || [[ ! $2 ]]; then
  echo "Usage: ./AutoGit \"Git path\" \"File/folder to commit or push path"
  exit 1
fi

if ! cp $2 $1; then
 exit 1
fi

if ! cd $1; then
 exit 1
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

