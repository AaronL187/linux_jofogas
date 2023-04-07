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

function getDate {
  echo "Date" > date.csv
  grep -o '<div class="time">[^<]*</div>' jofogas.html | while read -r date; do
    date=$(echo "$date" | sed 's/<[^>]*>//g' | tr -d '[:space:]')
    echo "$date" >> date.csv
  done
  echo "Dates saved to date.csv"
}

function getLink {
  echo "Link" > links.csv
  grep -o '<a href="[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "https://www.jofogas.hu$link" >> links.csv
  done
  echo "Links saved to links.csv"
}




# Call the getPage and getPrice functions
getPage
getPrice
getDate
getLink

