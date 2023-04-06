#!/bin/bash

# Check if keyword argument is provided
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 keyword"
  exit 1
fi

# Encode keyword for URL
keyword=$(echo "$1" | sed 's/ /+/g')
url="https://www.jofogas.hu/magyarorszag?q=$keyword"

# Make HTTP request and save HTML content to file
function getPage {
  curl -s -o jofogas.html "$url"
}

function getPrice {
  echo "Price" > prices.csv
  grep -o '<span data-hj-suppress class="price-value" itemprop="price" content="[0-9]*">[^<]*</span>' jofogas.html | while read -r price_tag; do
    price=$(echo "$price_tag" | sed 's/.*content="\([0-9]*\)".*/\1/' | tr -d ' ')
    echo "$price Ft" >> prices.csv
  done
  echo "Prices saved to prices.csv"
}



# Call the getPage and getPrice functions
getPage
getPrice
