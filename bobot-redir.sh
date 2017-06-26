#!/bin/bash -

server_target=www.ameli.fr

tac_tac=$1

mapfile -t my_array < $1

for line in ${my_array[@]} ; do
    	declare -A my_map_array
         my_map_array["my_source"]=$(echo "$line" | awk '{print$1}') 
	 #echo ${my_map_array[my_source]}
        # my_map_array["my_target"]=$(echo $line | awk '{print$2}')
	curl -m 3 -I -A Bobot-le-bot -k -s "https://$server_target${my_map_array[my_source]}" |&  awk '/Location/ {print}'
	#curl -m 3 -I -A Bobot-le-bot -k -s https://${server_target}$(echo "$line" | awk '{print$1}') |& grep -E '^Location' | awk '{print"New location: "$2}'



	#my_result=$(curl -m 3 -v -A Bobot-le-bot -k -s https://"${my_map_array[my_source]}" |& grep -E '^<\s(Location)')
	
	#echo "resultat  ${my_result[*]}"
done 
