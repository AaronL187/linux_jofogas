#!/bin/bash

# Megnézzük, hogy a felhasználó megadta-e a szükséges paramétereket
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <keyword> <max_price>"
  exit 1
fi

# Kompatibilissá tesszük a kulccszót a linkkel
keyword=$(echo "$1" | sed 's/ /+/g')
url="https://www.jofogas.hu/magyarorszag?q=$keyword"
max_price=$(($2))


# HTTP lekérdezést csinálunk az URL-re
function getPage {
  curl -s -o jofogas.html "$url"
}



#Az összes link lementése a keresés alapján -> ezek relevánsak nekünk
function getAllLinks {
   [ -e alllinks.csv ] && rm alllinks.csv && echo "Létezett az 'alllinks.csv' ezért eltávolítottam azt"
  echo "Link" > links.csv
  grep -o '<a href="[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "$link" >> alllinks.csv
  done
  echo "Links saved to alllinks.csv"
}

#Azok a specifikus linkek lekérdezése, amik a hírdetésekre mutatnak
function getWorkingLinks {
  [ -e workinglinks.csv ] && rm workinglinks.csv && echo "Létezett az 'workinglinks.csv' ezért eltávolítottam azt"
  echo "Link" > links.csv
  grep -o '<a href="https://www.jofogas.hu/\(csongrad\|budapest\|gyor_moson_sopron\|baranya\|fejer\|szabolcs_szatmar_bereg\|heves\|pest\|veszprem\)[^"]*"' jofogas.html | while read -r link; do
    link=$(echo "$link" | cut -d '"' -f 2)
    echo "$link" >> workinglinks.csv
  done
  echo "Links saved to workinglinks.csv"
}

# Körbe loopolunk a workinglinkseken és kivesszük belőle a price-ot, dátumot, amennyiben eleget tesznek a feltételnek ki is írjuk egy fájlba
function loopLinks {
  # Check if filename argument is provided
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 filename"
    exit 1
  fi
  [ -e ads.csv ] && rm ads.csv && echo "Létezett az 'ads.csv' ezért eltávolítottam azt"
  # Linkek beolvasása körbe loopolás
	counter=1
	while read -r link; do
	  # Ár és dátum kiszedése greppel
	  price=$(curl -s "$link" | grep -o '<meta itemprop="price" content="[0-9]*" />' | sed 's/.*content="\([0-9]*\)".*/\1/' | tr -d ' ')
	  printf "A termék ára: %-15s ------ Az általad megadott ár: %-15s \n" "$price" "$max_price"
	  date=$(curl -s "$link" | grep -F -w 'class="time"' --text | sed 's/<[^>]*>//g')
	   if [ $(($price)) -le $(($max_price)) ]; then
	    # Formázás konzolra
	    printf "\n A termék kiiírásra került a listádba \n %-5s | %-60s | %-10s | %-20s\n" "$counter" "$link" "$price Ft" "$date"
	    
	    # Sorszám, Link, Ár, Dátum hozzáadása egy fájlhoz
	    printf "%-5s | %-130s | %-10s | %-20s\n" "$counter" "$link" "$price Ft" "$date" >> ads.csv
	    
	    ((counter++))
	  fi
	done < "$1"

}


# Szükséges funkciók meghívása
getPage
getAllLinks
getWorkingLinks
loopLinks "workinglinks.csv"
