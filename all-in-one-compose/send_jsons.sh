#!/bin/sh
# This script finds each *.yml file in /data/json,
# extracts configuration including headers, and sends HTTP requests dynamically.

CONFIG_DIR="/data/json"

# Loop over all YAML configuration files in the folder
for config in "$CONFIG_DIR"/*.yml; do
    # Get the base file name (e.g., request1)
    base=$(basename "$config" .yml)
    jsonfile="$CONFIG_DIR/${base}.json"

    if [ ! -f "$jsonfile" ]; then
        echo "JSON file not found for configuration '$config'. Skipping..."
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
        # Identify any line starting with "headers:" and subsequent lines for headers
        if echo "$line" | grep -q "^headers:"; then
            # Read header lines until another top-level key or EOF
            while IFS= read -r header_line && ! echo "$header_line" | grep -q "^[^[:space:]]"; do
                # Extract and format headers dynamically
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

    # Build and execute the curl command with dynamic headers
    curl_cmd="curl -k -X ${method} ${auth_opt} ${headers} -d @${jsonfile} -w '\nHTTP Status Code: %{http_code}\n' ${url}"
    echo "Executing: ${curl_cmd}"
    eval ${curl_cmd}

    echo "\n-------------------------\n"
done
