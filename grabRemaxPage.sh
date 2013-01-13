#!/bin/bash
TEMP_DIR=./temp/remax
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

for page in `seq 1 574`
do 
	echo "Parsing Page -> $page"
	TEMP_FILE="$TEMP_DIR/temp_$page.html"
	echo "" > $TEMP_FILE
	echo "Created Temp File: $TEMP_FILE"
	# echo "CurrentPage:$page" >> $TEMP_FILE
	cp queryRemaxParam.txt $TEMP_FILE
	QUERY_STRING=`cat $TEMP_FILE | sed '/^$/d' | grep -v "#" | tr '\r\n' '&' | tr ':' '='`
	curl -s --data "$QUERY_STRING" "http://www.remax-malta.com/PublicListingList.aspx?results=1&searchAgain=true&CurrentPage=$page" > $TEMP_FILE
	tidy -f errs.txt -m $TEMP_FILE
	# Parse the page using python
	python parseRemaxPage.py "$TEMP_FILE" "$page" >> data.csv
done
