#!/bin/bash
TEMP_DIR=./temp/franksalt
COOKIE_DIR=./temp/franksalt/cookies
DATA_FILE='data.csv'
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
mkdir -p $COOKIE_DIR


# Determine whether there are any more results.  
# @return NEXT variable.  
function moreResults {
	NEXT=`php -f regexFinder.php ./temp/franksalt/temp_1.html '/<span id="content_lblResultSummary">[^<]*<\/span>/'`
	NEXT=`echo "$NEXT" | tr -dC [0-9\ ] | awk '{if ($2 == $3) {print 0} else {print 1} }'`
	echo "Has More: $NEXT"
}


# Set temporary file. 
# @return TEMP_FILE variable.  
# @return PREVIOUS_PAGE variable
# @return PREVIOUS_TEMP_FILE variable.  
function setTempFile {
	PAGE=$1
	
	# Set the previous page variable too.   
	PREVIOUS_PAGE=$(($PAGE-1))
	if [ "$PREVIOUS_PAGE" -lt "0" ] 
	then 
		PREVIOUS_PAGE=$PAGE
	fi
	
	PREVIOUS_TEMP_FILE="$TEMP_DIR/temp_""$PREVIOUS_PAGE"".html"
	TEMP_FILE="$TEMP_DIR/temp_$PAGE.html"
	echo "" > $TEMP_FILE
	echo "Created Temp File: $TEMP_FILE"
	# TEMP_FILE being returned. 
}

# Grabs a page from a URL, this function manages its own cookies
#  
function grabPage { 
	PAGE=$1
	echo "Parsing Page -> $PAGE" 
	setTempFile "$PAGE"
	
	# We always save the page cookies.  
	SAVE_COOKIES="cookies_""$PAGE"".txt"
	if [ "$PAGE" -eq "1" ]
	then
		echo "First Page Detected... Reading Query Variables.  "
		# It is the first page thus we load the parameters which the user gave.    
		cp queryFrankSaltParam.txt $TEMP_FILE
		QUERY_STRING=`cat $TEMP_FILE | sed '/^$/d' | grep -v "#" | tr '\r\n' '&' | tr ':' '='`
		QUERY_STRING="$QUERY_STRING"'ctl00$content$gvpDataPager$ddlPageIndex='"$page"
		LOAD_COOKIES=""
	else
		# It is the next page, we need the url encoded form from the previous page and the cookies.  
		LOAD_COOKIES="cookies_""$PREVIOUS_PAGE"".txt"
		echo "Form Resubmission Detected ... [Previous Page: $PREVIOUS_PAGE] [Previous Temp File: $PREVIOUS_TEMP_FILE] [Cookies: $LOAD_COOKIES]"
		# This function will override the query string.  
		grabFormFields "$PREVIOUS_TEMP_FILE"
	fi

	# Grab the URL with the updates.  
	grabUrl "$PAGE" "$QUERY_STRING" 'http://www.franksalt.com.mt/Search/SearchResults.aspx' "$TEMP_FILE" "$LOAD_COOKIES" "$SAVE_COOKIES" 
	
}

function grabIndividualResults {
	TEMP_FILE=$1
	PAGE=$2
	# Now grab all the page references.
	for reference in `cat "$TEMP_FILE" | grep -o "viewProperty(.*)" | tr -Cd [0-9'\n'] | awk '/[0-9]+/ {print $1}' | sort | uniq` 
	do 
		# Retrieve the page so that it can be easily parsed.   
		PAGE_FILE="$TEMP_DIR/page_$reference.html"
		echo -e "\t Reference: [$reference] from File: [$TEMP_FILE] Page File: [$PAGE_FILE]"
		curl -s "www.franksalt.com.mt/Search/PropertyDetails.aspx?id=$reference" > $PAGE_FILE
		# Now parse the page using python.  
		python parseFrankSaltPage.py "$PAGE_FILE" "$PAGE" "$reference" >> "$DATA_FILE"
	done

}

function grabUrl {
	PAGE=$1
	QUERY_STRING=$2
	URL=$3
	TEMP_FILE=$4
	LOAD_COOKIE=$5
	SAVE_COOKIE=$6
	
	if [[ "$LOAD_COOKIES" == "" ]] 
	then
		LOAD_COOKIE=`mktemp -t cookie`
		# Start off the file. 
		echo "" > $LOAD_COOKIE
		echo "WARNING: Load cookie file not found, Created Temp File [$LOAD_COOKIE]"
	fi
	
	if [[ "$SAVE_COOKIES" == "" ]]
	then
		SAVE_COOKIES=`mktemp -t cookie`
		echo "WARNING: Save cookie file not found, Created Temp File [$SAVE_COOKIE]"
	fi
	
	curl -s --cookie-jar "$COOKIE_DIR/$SAVE_COOKIE" -b "$COOKIE_DIR/$LOAD_COOKIE" --data "$QUERY_STRING" "$URL" > "$TEMP_FILE""_bak"
	
	# Remove the windows like carraige return. 
	cat "$TEMP_FILE"_bak | tr -d "\015" > $TEMP_FILE 
	rm -rf "$TEMP_FILE"_bak
}

# Grabs the Form fields from a give crawled result. 
# $PAGE the page you are currently retrieving.  
# $PREVIOUS_TEMP_FILE the previous file which was crawled.  
# @return QUERY_STRING overrides the Query String variable. 
function grabFormFields {
	PAGE_INDEX=$(($PAGE-2))
	FORM_FIELDS=`php -f regexFinder.php $PREVIOUS_TEMP_FILE '<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="[^\"]*" />' | tr " " "\n" | grep "value" | tr "\"" "\n" | head -2 | tail -1` 
	FORM_FIELDS=$(python -c "import urllib; print urllib.urlencode({'__VIEWSTATE': '''$FORM_FIELDS'''})")
	QUERY_STRING="__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&ctl00%24smMainScriptManager=&ctl00%24content%24ddlSort=price-low-to-high&ctl00%24content%24gvpDataPager%24ddlPageIndex=$PAGE_INDEX&ctl00%24content%24gvpDataPager%24btnNext=%3E"'&'"$FORM_FIELDS"
	# Set the query string.  
}

PAGE="1"
# Grab the first page.  
grabPage "$PAGE"
moreResults
if [ $NEXT -ne 0 ]
then 
	grabIndividualResults "$TEMP_FILE" "$PAGE"
fi

while [ $NEXT -ne 0 ]
do
	PAGE=$(($PAGE + 1))
	sleep "1s"
	echo ""
	grabPage "$PAGE"
	moreResults
	
	if [ $NEXT -ne 0 ]
	then 
		grabIndividualResults "$TEMP_FILE" "$PAGE"
	fi
	
done
