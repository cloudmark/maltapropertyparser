#!/bin/bash
TEMP_DIR=./temp/remax
DATA_FILE="data.csv"
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

NEXT="1" 
PAGE=0
while [ "$NEXT" -ne "0" ]
do
	PAGE=$(($PAGE+1))
	echo "Parsing Page -> $PAGE"
	TEMP_FILE="$TEMP_DIR/temp_$PAGE.html"
	echo "" > $TEMP_FILE
	echo "Created Temp File: $TEMP_FILE"
	cp queryRemaxParam.txt $TEMP_FILE
	QUERY_STRING=`cat $TEMP_FILE | sed '/^$/d' | grep -v "#" | tr '\r\n' '&' | tr ':' '='`
	curl -s --data "$QUERY_STRING" "http://www.remax-malta.com/PublicListingList.aspx?CurrentPage=$PAGE" > $TEMP_FILE
	tidy -f errs.txt -m $TEMP_FILE
	NEXT=`cat ./temp/remax/temp_$PAGE.html | grep -o "proplist_address" | wc -l | tr -dC [0-9]`
	echo "More Results: [$NEXT]"
	# Parse the page using python
	python parseRemaxPage.py "$TEMP_FILE" "$PAGE" >> "$DATA_FILE"
	echo ""
done
