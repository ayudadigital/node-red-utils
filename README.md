# Node-red utils

A pair of scripts to split and join node-red data file.

## Overview

Help node-red users to work with individual flows:

- The split script will put each tab into a separate .json file, naming with it's id
- The join script will join all individuals .json files into a big `flows.json` file

Both scripts will use the `jq` package, so it will be installed to run both scripts.

## Usage

- Split script

    ```console
    $ ./split-node-red-data.sh
    Nodered split data (c) Ayuda Digital 2020

    Usage: split-node-red-data.sh [nodered_data_file] [output_directory]

    Example:
    nodered-split-data.sh data/flows.json items

    This will split the data/flows.json node-red data file into individual json files (one per tab) saving they into 'items' directory
    All json files in 'itens' directory will be removed before the split process
    ```

- Join script

    ```console
    $ ./join-node-red-data.sh
    Nodered join data (c) Ayuda Digital 2020

    Usage: join-node-red-data.sh [input_directory]

    Example:
    nodered-split-data.sh items > data/flows.json

    This will join all json files within 'items' directory into 'data/flows.json'
    The process will overwrite the target file
    ```
