#!/bin/bash

# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {url}"
    exit 1
fi

url=$1
connections=2
concurrency=1


# Run Apache Bench in a loop until there are failed requests
while true; do
    # Run Apache Bench
    ab -n "${connections}" -c "${concurrency}" -v "3" "${url}" &> "${connections}_${concurrency}.txt"

    # Check if timed out from ab exit status
    # Check if there are failed requests in the output
    failed_requests=$(tail -n "25" "${connections}_${concurrency}.txt" | head -n "1" | awk '{print $3}')
    echo "${failed_requests} -n ${connections} -c ${concurrency}"

    results=$(tail -n "40" "${connections}_${concurrency}.txt")
    echo  "$results" > "${connections}_${concurrency}_results.txt"

    if [ "$failed_requests" != 0 ]; then
        break
    fi
    connections=$((connections * 2))
    concurrency=$((concurrency * 2))


done

# Display a message indicating completion
echo "Failed ${failed_requests} at ${connections} connections and ${concurrency} concurrency"

