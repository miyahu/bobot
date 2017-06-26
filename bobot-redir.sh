
server_target=


while read line ; do
    	declare -A my_map_array
         my_map_array["my_source"]=$(echo "$line" | awk '{print$1}') 
	# echo ${my_map_array[my_source]}
        # my_map_array["my_target"]=$(echo $line | awk '{print$2}')
	#my_result=$(curl -m 3 -v -A Bobot-le-bot -k -s https://"${my_map_array[my_source]}" |& grep -E '^<\s(Location)' | awk '{print$3}')
	curl -m 3 -v -A Bobot-le-bot -k -s https://${server_target}$(echo "$line" | awk '{print$1}') |& grep -E '^<\s(Location)' | awk '{print$3}'



	#my_result=$(curl -m 3 -v -A Bobot-le-bot -k -s https://"${my_map_array[my_source]}" |& grep -E '^<\s(Location)')
	
	#echo "resultat  ${my_result}"
done < $1
