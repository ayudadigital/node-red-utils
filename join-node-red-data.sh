#!/bin/bash
set -eu

echo >&2 "Nodered join data (c) Ayuda Digital 2020-2023"
echo >&2 ""

if [ $# -ne 1 ]; then
    echo >&2 "Usage: join-node-red-data.sh [input_directory]"
    echo >&2
    echo >&2 "Example:"
    echo >&2 "   nodered-split-data.sh items > data/flows.json"
    echo >&2
    echo >&2 "This will join all json files within 'items' directory into 'data/flows.json'"
    echo >&2 "The process will overwrite the target file"
    exit 1
fi

echo >&2 -ne "# Chech presence of 'jq' tool: "
which -s jq || (echo >&2 "not installed. Aborting"; exit 1)
echo >&2 "OK"

inputDirectory=$(cd "$1"; pwd)
echo >&2 -ne "# Input data files check '${inputDirectory}': "

jq empty "$inputDirectory"/*.json || (echo >&2 "Aborting"; exit 1)
echo >&2 "OK"

echo >&2
echo >&2 -ne "# Join json files: "
jq -s '[.[][]]' "$inputDirectory"/*.json
echo >&2 "OK"

echo >&2 "# FINISH"
