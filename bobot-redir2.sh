#!/bin/bash -

# s'/b/v/ache4' inside must be used

#server_target= export server_target=..

declare -A my_map_array

while read line ; do 
    my_source=$(echo "$line" | awk '{print$1}')
    my_map_array[$my_source]=$(echo $line | awk '{print$2}')
done < $1

echo ${!my_map_array[@]}

for my_source in ${!my_map_array[@]} ; do
	my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${my_source} |& awk '/Location/ {print$2}')
    echo resul $my_result
    echo cible ${my_map_array[$my_source]}

    if [[ $my_result =~  ${my_map_array[$my_source]} ]] ; then
        echo ok
    else
        echo nok
    fi

done

#for (( i=0 ; i<${#my_map_array[@]} ; i++ )) ; do
#    echo ${my_map_array[$i]}
#done
