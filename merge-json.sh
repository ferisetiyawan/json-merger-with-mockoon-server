#!/bin/bash

# Define the folder containing JSON files
folder="json_collection"

# Define the folder output for JSON file
output="build"

# Define the JSON template file
template_file="main.json"

# Read the contents of the template file
template_data=$(< "$template_file")

# Extract the values of "uuid", "lastMigration", etc. from the template
uuid=$(jq -r '.uuid' <<< "$template_data")
lastMigration=$(jq -r '.lastMigration' <<< "$template_data")
name=$(jq -r '.name' <<< "$template_data")
endpointPrefix=$(jq -r '.endpointPrefix' <<< "$template_data")
latency=$(jq -r '.latency' <<< "$template_data")
port=$(jq -r '.port' <<< "$template_data")
hostname=$(jq -r '.hostname' <<< "$template_data")
proxyMode=$(jq -r '.proxyMode' <<< "$template_data")
proxyHost=$(jq -r '.proxyHost' <<< "$template_data")
proxyRemovePrefix=$(jq -r '.proxyRemovePrefix' <<< "$template_data")
tlsOptions=$(jq -r '.tlsOptions' <<< "$template_data")
cors=$(jq -r '.cors' <<< "$template_data")
headers=$(jq -r '.headers' <<< "$template_data")
proxyReqHeaders=$(jq -r '.proxyReqHeaders' <<< "$template_data")
proxyResHeaders=$(jq -r '.proxyResHeaders' <<< "$template_data")
# Add other fields as needed

# Create an empty object to store merged data
merged_json=$(jq -n --arg uuid "$uuid" --arg lastMigration "$lastMigration" --arg name "$name" --arg endpointPrefix "$endpointPrefix" --arg latency "$latency" --arg port "$port" --arg hostname "$hostname" --arg proxyMode "$proxyMode" --arg proxyHost "$proxyHost" --arg proxyRemovePrefix "$proxyRemovePrefix" --arg tlsOptions "$tlsOptions" --arg cors "$cors" --arg headers "$headers" --arg proxyReqHeaders "$proxyReqHeaders" --arg proxyResHeaders "$proxyResHeaders" '{
    uuid: $uuid,
    lastMigration: $lastMigration,
    name: $name,
    endpointPrefix: $endpointPrefix,
    latency: $latency,
    port: $port,
    hostname: $hostname,
    proxyMode: $proxyMode,
    proxyHost: $proxyHost,
    proxyRemovePrefix: $proxyRemovePrefix,
    tlsOptions: ($tlsOptions | fromjson),
    cors: $cors,
    headers: ($headers | fromjson),
    proxyReqHeaders: ($proxyReqHeaders | fromjson),
    proxyResHeaders: ($proxyResHeaders | fromjson)
    # Add other fields as needed
}')

# Find all JSON files recursively in the folder and its subfolders
while IFS= read -r -d '' file; do
    # Read the contents of each JSON file
    file_content=$(< "$file")
    
    # Merge the contents of each JSON file into the merged JSON object
    merged_json=$(jq --argjson merged_json "$merged_json" --argjson file_content "$file_content" '
        .folders += [$file_content.folders[]] | 
        .routes += [$file_content.routes[]] | 
        .rootChildren += [$file_content.rootChildren[]]
    ' <<< "$merged_json")
done < <(find "$folder" -type f -name '*.json' -print0)

# Output the merged JSON object to a new file in the root directory
if [ ! -d "$output" ]; then
    mkdir "$output"
fi
echo "$merged_json" > $output/mock-collection.json

echo "Merged JSON file created: mock-collection.json"
