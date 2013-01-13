#!/bin/bash
TEMP_DIR=./temp/franksalt
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

	echo "Parsing Page -> $page"
	TEMP_FILE="$TEMP_DIR/temp_$page.html"
	echo "" > $TEMP_FILE
	echo "Created Temp File: $TEMP_FILE"
	# echo "CurrentPage:$page" >> $TEMP_FILE
	cp queryFrankSaltParam.txt $TEMP_FILE
	QUERY_STRING=`cat $TEMP_FILE | sed '/^$/d' | grep -v "#" | tr '\r\n' '&' | tr ':' '='`
	QUERY_STRING="$QUERY_STRING"'ctl00$content$gvpDataPager$ddlPageIndex='"$page"
	echo $QUERY_STRING
	curl -s --data "$QUERY_STRING" "http://www.franksalt.com.mt/Search/SearchResults.aspx" > $TEMP_FILE

	tidy -f errs.txt -m $TEMP_FILE
	FORM_FIELDS=`php -f regexFinder.php $TEMP_FILE '/<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE"[^>]*>[^<]*<\/input>?/'`
	echo $FORM_FIELDS

	echo $FORM_FIELDS 
	# Parse the page using python
	# python parseRemaxPage.py "$TEMP_FILE" "$page" >> data.csv
