#!/bin/bash -

server_target=www.ameli.fr

tac_tac=$1

mapfile my_array < $1

IFS="\n" 
for line in ${my_array[@]} ; do
    	declare -A my_map_array
         my_map_array["my_source"]=$(echo "$line" | awk '{print$1}') 
	 #echo ${my_map_array[my_source]} "tyagada"
	 #echo $line ${my_map_array[my_source]}
         my_map_array["my_target"]=$(echo $line | awk '{print$2}')
	#curl -m 3 -I -A Bobot-le-bot -s "http://$server_target${my_map_array[my_source]}" |&  awk '/Location/ {print}'
	my_result=$(curl -m 3 -I -A Bobot-le-bot -k -s http://${server_target}/${my_map_array[my_source]} |& awk '/Location/ {print}')



	#my_result=$(curl -m 3 -v -A Bobot-le-bot -k -s https://"${my_map_array[my_source]}" |& grep -E '^<\s(Location)')
	
	echo "resultat  ${my_result}"
done 
