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



#Az összes elsőoldalas link lementése a keresés alapján -> ezek relevánsak nekünk
function getAllLinks {
   [ -e alllinks.csv ] && rm alllinks.csv && echo "Létezett az 'alllinks.csv' ezért eltávolítottam azt"
  echo "Link" > links.csv
  grep -o '<a href="[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "$link" >> alllinks.csv
  done
  echo "Links saved to alllinks.csv"
}

function getWorkingLinks {
  [ -e workinglinks.csv ] && rm workinglinks.csv && echo "Létezett az 'workinglinks.csv' ezért eltávolítottam azt"
  echo "Link" > links.csv
  grep -o '<a href="https://www.jofogas.hu/\(csongrad\|budapest\|gyor_moson_sopron\|baranya\|fejer\|szabolcs_szatmar_bereg\|heves\|pest\|veszprem\)[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "$link" >> workinglinks.csv
  done
  echo "Links saved to workinglinks.csv"
}


function loopLinks {
  # Check if filename argument is provided
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 filename"
    exit 1
  fi
  
  [ -e ads.csv ] && rm ads.csv && echo "Létezett az 'ads.csv' ezért eltávolítottam azt"
  # Read links from file and loop through them

	counter=1
	while read -r link; do
	  # Extract price from link using curl and grep
	  price=$(curl -s "$link" | grep -o '<meta itemprop="price" content="[0-9]*" />' | sed 's/.*content="\([0-9]*\)".*/\1/' | tr -d ' ')
	  date=$(curl -s "$link" | grep -F -w 'class="time"' --text | sed 's/<[^>]*>//g')

	  # Format the link, price, and date with equal columns
	  printf "%-5s | %-60s | %-10s | %-20s\n" "$counter" "$link" "$price Ft" "$date"
	  
	  # Append link, price, and date to output file
	  printf "%-5s | %-130s | %-10s | %-20s\n" "$counter" "$link" "$price Ft" "$date" >> ads.csv
	  
	  ((counter++))
	done < "$1"

}

# Call loopLinks function with filename argument



# Call the getPage and getPrice functions
getPage
getAllLinks
getWorkingLinks
loopLinks "workinglinks.csv"

