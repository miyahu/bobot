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

    index_my_map_array=(${!my_map_array[@]})

    for (( i=$3 ; i<=$4 ; i++ )) ; do
        sleep 0.1
	    #echo ${index_my_map_array[$i]}
	    my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${index_my_map_array[$i]} |& awk '/Location/ {print$2}'| tr -d '\r')
        #echo $($my_result | tr -d '\r')
        if [[ $my_result  !=  ${my_map_array[$my_source]} ]] ; then
            #echo "line number ${i} - NOK - $my_resul"
            echo "line number ${i} - NOK - ${my_result} and ${my_map_array[$my_source]} expected"
        else
            echo  "line ${i}: ok"
        fi
    done
    ;;
    random)

    declare -a my_random_array 

    for i in {0..199} ; do
        my_random_array+="$i"
        index_my_map_array=(${!my_map_array[@]})
    done
    
esac    
    

