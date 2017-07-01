#!/bin/bash -

# the bot for bobos..

# if dos caracteres in input file, use dos2unix for converting  

my_curl_opts="-v -A Bobot-le-bot -k -s -L"
my_main_loop_delay="0.05"
my_curl_timeo="-m 3"

my_standard_log="/tmp/$(basename ${0/.sh/})_output"
my_error_log="/tmp/$(basename ${0/.sh/})_error"

by_pass_varnish=1

if (( ${#@} < 1 )) ; then
    echo "You must specified first an valid target, secondly an input file"
    exit 3
else 
    #my_server_target=$1
    my_url_list_file="$1"
fi

for i in 200 300 400 500 my_catchall $(basename $my_error_log) ; do
    if [ -f $i ] ; then
        > /tmp/$i
    fi
done

echo "starting browse at $(date +%D-%T)" > $my_standard_log
echo "Parsing of $1" | tee -a $my_standard_log
export my_starting_time=$(date +%s)

while read line ; do
    declare -A my_curl_response
    my_curl=$(curl $my_curl_timeo $my_curl_opts  $line |& grep -E "^<\s(Age|HTTP|X-Varnish-Ip)" | awk '{print$3}' 2>> $my_error_log) 
    nb=0
    for i in $my_curl ; do
        nb=$(((nb+1)))
        if (($nb==1)) ; then
            my_curl_response["my_rc"]=$i
        elif (($nb==2)) ; then
            my_curl_response["my_age"]=$(echo $i | tr -d '\r')
        elif (($nb==3)) ; then
            my_curl_response["my_varnish_id"]=$(echo $i | tr -d '\r')
        fi
    done    
    if (( ${my_curl_response[my_rc]} == 200 )) ; then
        echo "code: ${my_curl_response[my_rc]} age: ${my_curl_response[my_age]} ip: ${my_curl_response[my_varnish_id]} url: $line" >> /tmp/200
    elif (( ${my_curl_response[my_rc]} > 300 && ${my_curl_response[my_rc]} < 400  )) ; then
        echo "code: ${my_curl_response[my_rc]} age: ${my_curl_response[my_age]} ip: ${my_curl_response[my_varnish_id]} url: $line" >> /tmp/300
    elif (( ${my_curl_response[my_rc]} > 400 && ${my_curl_response[my_rc]} < 500 )) ; then
        echo "code: ${my_curl_response[my_rc]} age: ${my_curl_response[my_age]} ip: ${my_curl_response[my_varnish_id]} url: $line" >> /tmp/400
    elif (( ${my_curl_response[my_rc]} => 500 )) ; then
        echo "code: ${my_curl_response[my_rc]} age: ${my_curl_response[my_age]} ip: ${my_curl_response[my_varnish_id]} url: $line" >> /tmp/500
    else
        echo "code: ${my_curl_response[my_rc]} age: ${my_curl_response[my_age]} ip: ${my_curl_response[my_varnish_id]} url: $line" >> /tmp/my_catchall
    fi
    sleep $my_main_loop_delay
done < $my_url_list_file

echo "ending at $(date +%D-%T)" | tee -a  $my_standard_log
export my_ending_time=$(date +%s)
echo "Time to parsing: $((( ($my_ending_time - $my_starting_time) /60 )))m" | tee -a $my_standard_log

declare -a my_used_files
for i in 200 300 400 500 my_catchall $(basename $my_error_log) ; do
    if [ -f  /tmp/$i ] ; then
        my_used_files+="$i "
        echo "nb entry: $(wc -l /tmp/$i)" | tee -a $my_standard_log
    fi
done
echo -e "Please consult : \n$(for i in ${my_used_files[@]} ; do echo /tmp/$i ; done)"
    
