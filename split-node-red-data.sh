#!/bin/bash
set -eu

echo >&2 "Nodered split data (c) Ayuda Digital 2020"
echo >&2 ""

if [ $# -ne 2 ]; then
    echo >&2 "Usage: split-node-red-data.sh [nodered_data_file] [output_directory]"
    echo >&2
    echo >&2 "Example:"
    echo >&2 "   nodered-split-data.sh data/flows.json items"
    echo >&2
    echo >&2 "This will split the data/flows.json node-red data file into individual json files (one per tab) saving they into 'items' directory"
    echo >&2 "All json files in 'itens' directory will be removed before the split process"
    exit 1
fi

echo >&2 -ne "# Chech presence of 'jq' tool: "
which -s jq || (echo >&2 "not installed. Aborting"; exit 1)
echo >&2 "OK"

inputFile=$(cd "$(dirname "$1")"; pwd)/$(basename "$1")
echo >&2 -ne "# Input data file check '${inputFile}': "
jq empty "$inputFile"  || (echo >&2 "Aborting"; exit 1)
inputDirectory=$(cd "$(dirname "$inputFile")"; pwd)
echo >&2 "OK"
outputDirectory=$(cd "$2"; pwd)
echo >&2 -ne "# Output directory check '${outputDirectory}': "
[ ! -d "$outputDirectory" ] && (echo >&2 "does not exist. Aborting"; exit 1)
[ "$inputDirectory" == "$outputDirectory" ] && (echo >&2 "Input and output directory are the same. Aborting"; exit 1)
echo >&2 "OK"
echo >&2
echo >&2 "# Removing all .json files '${outputDirectory}/*.json': "
echo >&2 "=========="
rm -fv "${outputDirectory}"/*.json
echo >&2 "=========="

echo >&2
echo >&2 -n "# Extract the ID of each tab: "
idList=$(jq ".[]|select (.type == \"tab\")|.id" "$inputFile")
echo >&2 "$(echo "$idList"|wc -w) tabs found"

echo >&2 "# Loop tabs extracting content:"
for id in $idList; do
    outputFile="${id%\"}"
    outputFile="${outputDirectory}/${outputFile#\"}".json
    echo >&2 -e "\tTab: ${id} => file: ${outputFile}"
    (
        jq ".[]|select ((.id == ${id}) or (.z == ${id}))" "$inputFile"
    ) | jq -s '.' > "${outputFile}"
done

echo >&2 "# FINISH"
