#!/bin/sh
# This script now supports dynamic HTTP requests for both JSON and NDJSON files.
# Additionally, it handles .sh files by making them executable and executing them.

CONFIG_DIR="/data/json"

# Loop over all YAML configuration files in the folder
for config in "$CONFIG_DIR"/*.yml; do
    # Get the base file name (e.g., request1)
    base=$(basename "$config" .yml)
    jsonfile="$CONFIG_DIR/${base}.json"
    ndjsonfile="$CONFIG_DIR/${base}.ndjson"
    shfile="$CONFIG_DIR/${base}.sh"

    # Check which file exists: JSON, NDJSON, or SH
    if [ -f "$ndjsonfile" ]; then
        datafile="$ndjsonfile"
        content_type="multipart/form-data"
        is_ndjson=true
        echo "Detected NDJSON file: $ndjsonfile"
    elif [ -f "$jsonfile" ]; then
        datafile="$jsonfile"
        content_type="application/json"
        is_ndjson=false
        echo "Detected JSON file: $jsonfile"
    elif [ -f "$shfile" ]; then
        echo "Detected SH file: $shfile"
        chmod +x "$shfile"
        echo "Executing SH file: $shfile"
        eval "$shfile"
        echo "\n-------------------------\n"
        continue
    else
        echo "No data file found for configuration '$config'. Skipping..."
        continue
    fi

    # Extract mandatory fields from the YAML file
    url=$(grep "^url:" "$config" | cut -d':' -f2- | sed 's/^[[:space:]]*//;s/"//g')
    method=$(grep "^method:" "$config" | cut -d':' -f2- | sed 's/^[[:space:]]*//;s/"//g')
    username=$(grep "^username:" "$config" | cut -d':' -f2- | sed 's/^[[:space:]]*//;s/"//g')
    password=$(grep "^password:" "$config" | cut -d':' -f2- | sed 's/^[[:space:]]*//;s/"//g')

    # Collect headers dynamically from YAML configuration
    headers=""
    while IFS= read -r line; do
        if echo "$line" | grep -q "^headers:"; then
            while IFS= read -r header_line && ! echo "$header_line" | grep -q "^[^[:space:]]"; do
                header=$(echo "$header_line" | sed 's/^[[:space:]]*//;s/"//g')
                headers="${headers} -H \"${header}\""
            done
            break
        fi
    done < "$config"

    echo "Processing request: $base"
    echo " - URL: $url"
    echo " - Method: $method"
    if [ -n "$username" ] && [ -n "$password" ]; then
        auth_opt="--user ${username}:${password}"
        echo " - Using authentication for user '$username'"
    else
        auth_opt=""
    fi

    # Construct the curl command
    if [ "$is_ndjson" = true ]; then
        # Handle NDJSON file with multipart/form-data
        headers="${headers} -H \"kbn-xsrf: true\""
        curl_cmd="curl -k -X POST ${auth_opt} ${headers} -F file=@${datafile} -w '\nHTTP Status Code: %{http_code}\n' ${url}"
    else
        # Handle JSON file as usual
        headers="${headers} -H \"Content-Type: ${content_type}\""
        curl_cmd="curl -k -X ${method} ${auth_opt} ${headers} -d @${datafile} -w '\nHTTP Status Code: %{http_code}\n' ${url}"
    fi

    echo "Executing: ${curl_cmd}"
    eval ${curl_cmd}

    echo "\n-------------------------\n"
done
