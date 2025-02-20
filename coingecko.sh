#!/bin/bash

API_URL="https://api.coingecko.com/api/v3/coins/bitcoin"
CURRENCY="gbp"

fetch_data() {
    echo "Fetching data from: $API_URL"
    response=$(curl -s "$API_URL")

    if [ $? -ne 0 ]; then
        echo "Error: Failed to retrieve data from API. Network issues or invalid URL."
        exit 1
    fi

    if [ -z "$response" ]; then
        echo "Error: Empty response from API."
        exit 1
    fi
}

parse_data() {
    updated_time=$(echo "$response" | jq -r '.last_updated')
    rate=$(echo "$response" | jq -r ".market_data.current_price.$CURRENCY")

    if [ "$updated_time" == "null" ] || [ "$rate" == "null" ]; then
        echo "Error: Failed to parse required data. The response might be invalid or incomplete."
        exit 1
    fi
}

display_info() {
    echo "Bitcoin Information:"
    echo "--------------------"
    echo "Last updated time: $updated_time"
    echo "Bitcoin $CURRENCY rate: $rate"
}

while getopts "u:c:" opt; do
    case $opt in
    u) API_URL="$OPTARG" ;;
    c) CURRENCY="$OPTARG" ;;
    *) echo "Usage: $0 [-u API_URL] [-c CURRENCY]" ;;
    esac
done

fetch_data
parse_data
display_info
