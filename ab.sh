#!/bin/bash

# Check if the number of arguments is not equal to 1
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 {max_concurrency} {url}"
    exit 1
fi

url=$2
max_concurrency=$1
connections=2
concurrency=1


# Run Apache Bench in a loop until there are failed requests
while true; do
    # Run Apache Bench
    if [ "${concurrency}" -gt "$max_concurrency" ]; then
        break
    fi 

    ab -n "${connections}" -c "${concurrency}" -v "3" "${url}" &> "${connections}_${concurrency}.txt"

    # Check if timed out from ab exit status
    # Check if there are failed requests in the output
    failed_requests=$(tail -n "30" "${connections}_${concurrency}.txt" | grep "Failed requests" | awk '{print $3}')
    echo "Failed Requests: ${failed_requests}, Options: \"-n ${connections} -c ${concurrency}\""

    results=$(tail -n "40" "${connections}_${concurrency}.txt")
    echo  "$results" > "${connections}_${concurrency}_results.txt"

    connections=$((connections * 2))
    concurrency=$((concurrency * 2))


done


