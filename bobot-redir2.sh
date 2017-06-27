#!/bin/bash -

# s'/b/v/ache4' must be used

#server_target= export server_target=..

declare -A my_map_array

while read line ; do 
    my_source=$(echo "$line" | awk '{print$1}')
    my_map_array[$my_source]=$(echo $line | awk '{print$2}')
done < $2

case $1 in
    all)
    for my_source in ${!my_map_array[@]} ; do
        sleep 0.1
        echo testing $server_target$my_source
	    my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${my_source} |& awk '/Location/ {print$2}')
        echo resul $my_result
        echo cible ${my_map_array[$my_source]}

        if [[ $my_result =~  ${my_map_array[$my_source]} ]] ; then
            echo -n ""
        else
            echo "nok: $my_result for ${my_map_array[$my_source]} expected"

        fi
    done
    ;;
    partial)

    echo starting at line $3 for ending at $4
    # testing seq

    index_my_array=(${!my_map_array[@]})

    for (( i=$3 ; i<=$4 ; i++ )) ; do
        sleep 0.1
	    #echo ${index_my_array[$i]}
	    my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${index_my_array[$i]} |& awk '/Location/ {print$2}')
        #echo resul $my_result
        if [[ $my_result  !=  ${my_map_array[$my_source]} ]] ; then
            echo "line number ${i} - NOK - $my_result for ${my_map_array[$my_source]} expected"A
        else
            echo  "line ${i}: ok"
        fi
    done
    ;;
esac    
    

