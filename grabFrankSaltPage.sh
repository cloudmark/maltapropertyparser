#!/bin/bash
TEMP_DIR=./temp/franksalt
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
page=1
	echo "Parsing Page -> $page"
	TEMP_FILE="$TEMP_DIR/temp_$page.html"
	echo "" > $TEMP_FILE
	echo "Created Temp File: $TEMP_FILE"
	# echo "CurrentPage:$page" >> $TEMP_FILE
	cp queryFrankSaltParam.txt $TEMP_FILE
	QUERY_STRING=`cat $TEMP_FILE | sed '/^$/d' | grep -v "#" | tr '\r\n' '&' | tr ':' '='`
	QUERY_STRING="$QUERY_STRING"'ctl00$content$gvpDataPager$ddlPageIndex='"$page"
	echo $QUERY_STRING
	curl -s --cookie-jar cookies.txt --data "$QUERY_STRING" "http://www.franksalt.com.mt/Search/SearchResults.aspx" > "$TEMP_FILE"_bak
	cat "$TEMP_FILE"_bak | tr -d "\015" > $TEMP_FILE 
	rm -rf "$TEMP_FILE"_bak
	FORM_FIELDS=`php -f regexFinder.php $TEMP_FILE '<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="[^\"]*" />' | tr " " "\n" | grep "value" | tr "\"" "\n" | head -2 | tail -1` 
	echo $FORM_FIELDS
	echo ""

	page=2
	FORM_FIELDS=$(python -c "import urllib; print urllib.urlencode({'__VIEWSTATE': '''$FORM_FIELDS'''})")
	TEMP_FILE="$TEMP_DIR/temp_$page.html"
	QUERY_STRING="__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&ctl00%24smMainScriptManager=&ctl00%24content%24ddlSort=price-low-to-high&ctl00%24content%24gvpDataPager%24ddlPageIndex=0&ctl00%24content%24gvpDataPager%24btnNext=%3E"'&'"$FORM_FIELDS"
	curl -s --cookie-jar cookies2.txt -b cookies.txt --data "$QUERY_STRING" "http://www.franksalt.com.mt/Search/SearchResults.aspx" > "$TEMP_FILE"_bak
	echo ""
	echo ""
	echo ""	


	cat "$TEMP_FILE"_bak | tr -d "\015" > $TEMP_FILE 
	rm -rf "$TEMP_FILE"_bak
	FORM_FIELDS=`php -f regexFinder.php $TEMP_FILE '<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="[^\"]*" />' | tr " " "\n" | grep "value" | tr "\"" "\n" | head -2 | tail -1` 
	echo $FORM_FIELDS

	page=3
	FORM_FIELDS=$(python -c "import urllib; print urllib.urlencode({'__VIEWSTATE': '''$FORM_FIELDS'''})")
	TEMP_FILE="$TEMP_DIR/temp_$page.html"
	QUERY_STRING="__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&ctl00%24smMainScriptManager=&ctl00%24content%24ddlSort=price-low-to-high&ctl00%24content%24gvpDataPager%24ddlPageIndex=1&ctl00%24content%24gvpDataPager%24btnNext=%3E"'&'"$FORM_FIELDS"


	echo ""
	echo ""
	echo ""
	curl -s --cookie-jar cookies3.txt -b cookies2.txt --data "$QUERY_STRING" "http://www.franksalt.com.mt/Search/SearchResults.aspx" > "$TEMP_FILE"_bak
	cat "$TEMP_FILE"_bak | tr -d "\015" > $TEMP_FILE 
	rm -rf "$TEMP_FILE"_bak
