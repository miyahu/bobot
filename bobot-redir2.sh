#!/bin/bash -

# s'/b/v/ache4' must be used

#server_target= export server_target=..

my_pipe_path="/tmp/jaimelespipes"

if [[ ! -p $my_pipe_path ]]; then
    if ! mkfifo $my_pipe_path ; then
        echo "Unable to create $my_pipe_path"
        exit 3
    fi  
fi

declare -A my_map_array
declare -a my_index_map_array


case $1 in
    all)
    
    while read line ; do 
        my_source=$(echo "$line" | awk '{print$1}')
        my_map_array[$my_source]=$(echo $line | awk '{print$2}')
        my_index_map_array+=("$my_source")
    done < $2

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

    sed -n "$3,$4"p $2 > $my_pipe_path &

    while read line ; do 
        my_source=$(echo "$line" | awk '{print$1}')
        my_map_array[$my_source]=$(echo $line | awk '{print$2}')
        my_index_map_array+=("$my_source")
    done < $my_pipe_path

    echo starting at line $3 for ending at $4
    # testing seq

    lnb=$3
    #echo "ra ${!my_index_map_array[@]}"
    for i in ${!my_index_map_array[@]} ; do
             (( lnb++ )) 
            echo "lnb: $lnb"
            sleep 0.1
	        #my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${my_index_map_array[$i]} |& awk '/Location/ {print$2}'| tr -d '\r')
	        my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${my_index_map_array[$i]} |& awk '/Location/ {print$2}'| tr -d '\r')
            echo "index: $i"
            echo "source: ${my_index_map_array[$i]}"
            echo "result: $my_result"
            #if [[ $my_result  !=  ${my_map_array[${my_index_map_array[$i]}]} ]] ; then
            if [[ $my_result  !=  ${my_map_array[$i]} ]] ; then
                echo "line number $lnb - NOK - obtain ${my_result} for ${my_map_array[$my_source]} expected"
            else
                echo  "line $lnb: ok"
            fi
        done
    ;;
    random)

    declare -a my_random_array 

    for i in {0..199} ; do
        my_random_array+="$RANDOM "
    done

    for i in ${my_random_array[@]} ; do
        sleep 0.1
        echo "number is $i"
	    my_result=$(curl -m 3 -I -A Bobot-le-bot -s http://${server_target}${my_index_map_array[$i]} |& awk '/Location/ {print$2}'| tr -d '\r')
        #echo $my_result
        if [[ $my_result  !=  ${my_map_array[${my_index_map_array[$i]}]} ]] ; then
            echo "line number ${i} - NOK - obtain ${my_result} for ${my_map_array[$my_source]} expected"
        else
            echo  "line ${i}: ok"
        fi
    done
    
esac    
    

