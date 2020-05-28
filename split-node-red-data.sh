#!/bin/bash
set -eu

echo "Nodered split data (c) Ayuda Digital 2020"
echo ""

if [ $# -ne 2 ]; then
    echo "Usage: split-node-red-data.sh [nodered_data_file] [output_directory]"
    echo
    echo "Example:"
    echo "   nodered-split-data.sh data/flows.json items"
    echo
    echo "This will split the data/flows.json node-red data file into individual json files (one per tab) saving they into 'items' directory"
    echo "All json files in 'itens' directory will be removed before the split process"
    exit 1
fi

inputFile=$(echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")")
echo -ne "\t# Input data file check '${inputFile}': "
jq empty $inputFile  || (echo "Aborting"; exit 1)
inputDirectory=$(echo "$(cd "$(dirname "$inputFile")"; pwd)")
echo "OK"
outputDirectory=$(echo "$(cd "$2"; pwd)")
echo -ne "\t# Output directory check '${outputDirectory}': "
[ ! -d $outputDirectory ] && (echo "does not exist. Aborting"; exit 1)
[ $inputDirectory == $outputDirectory ] && (echo "Input and output directory are the same. Aborting"; exit 1)
echo "OK"
echo
echo "# Removing all .json files '${outputDirectory}/*.json': "
echo "=========="
rm -fv "${outputDirectory}"/*.json
echo "=========="

echo
echo -n "# Extract the ID of each tab: "
idList=$(jq ".[]|select (.type == \"tab\")|.id" $inputFile)
echo "$(echo $idList|wc -w) tabs found"

echo "# Loop tabs extracting content:"
for id in $idList; do
    outputFile="${id%\"}"
    outputFile="${outputDirectory}/${outputFile#\"}".json
    echo -e "\tTab: ${id} => file: ${outputFile}"
    (
        jq ".[]|select ((.id == ${id}) or (.z == ${id}))" $inputFile
    ) | jq -s '.' > "${outputFile}"
done

echo "# FINISH"
