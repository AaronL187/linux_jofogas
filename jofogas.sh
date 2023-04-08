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


function getAllLinks {
  echo "Link" > links.csv
  grep -o '<a href="[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "$link" >> alllinks.csv
  done
  echo "Links saved to alllinks.csv"
}

function getWorkingLinks {
  echo "Link" > links.csv
  grep -o '<a href="https://www.jofogas.hu/\(csongrad\|budapest\|gyor_moson_sopron\|baranya\|fejer\|szabolcs_szatmar_bereg\|heves\|pest\|veszprem\)[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "$link" >> workinglinks.csv
  done
  echo "Links saved to workinglinks.csv"
}


function getItems {
    sed -n '/<div class="col-xs-12 box listing list-item gallery-items   has-bottom-line   priorized  reListElement"/,/<\/div>/p' jofogas.html > items.html
    sed -i 's/^[ \t]*//' items.html
}



function loopLinks {
  # Check if filename argument is provided
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 filename"
    exit 1
  fi
  
  # Read links from file and loop through them
  while read -r link; do
    # Extract price from link using curl and grep
    price=$(curl -s "$link" | grep -o '<meta itemprop="price" content="[0-9]*" />' | sed 's/.*content="\([0-9]*\)".*/\1/' | tr -d ' ')
    date=$(curl -s "$link" | grep -F -w 'class="time"' --text | sed 's/.*<span class="time">//g;s/<\/span>.*//g')

    
    # Print link and price to console
    echo "$link, $price, $date"
    
    # Append link and price to output file
    echo "$link, $price, $date" >> ads.csv
    done < "$1"
  
    rm "workinglinks.csv"
}

# Call loopLinks function with filename argument



# Call the getPage and getPrice functions
getPage
getAllLinks
getWorkingLinks
getItems
loopLinks "workinglinks.csv"

