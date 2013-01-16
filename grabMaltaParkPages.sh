#!/bin/bash
TEMP_DIR=./temp/maltapark
DATA_FILE="data.csv"
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
IFS=$(echo -en "\n\b")
for QUERY in `cat queryMaltaParkParam.txt  | grep -E -o "Type=(.*)" | awk -F = '{print $2}' | sed -E 's/,/\'$'\n/g'`
do
	QUERY=`echo $QUERY | tr '[A-Z]' '[a-z]'`
	QUERY_PARAM=$(python -c "import urllib; print urllib.urlencode({'search': '''$QUERY'''})")
	
	
	# Convert the query as a file
	QUERY_AS_FILE=`echo "$QUERY" | tr ' ' '_'`
	
	echo "Query: [$QUERY_AS_FILE]"
	NEXT="1" 
	PAGE=0
	while [ "$NEXT" -ne "0" ]
	do
		PAGE=$(($PAGE+1))
		echo "Parsing [Page -> $PAGE] [Query -> $QUERY_AS_FILE]"
		TEMP_FILE="$TEMP_DIR/temp_""$QUERY_AS_FILE""_""$PAGE"".html"
		
		echo "" > $TEMP_FILE
		echo "Created Temp File: $TEMP_FILE"
		curl -s "http://www.maltapark.com/property/search.aspx?$QUERY_PARAM&searchcat=s3&sortby=2&page=$PAGE" > $TEMP_FILE
		tidy -f errs.txt -m $TEMP_FILE


		NEXT=`cat "$TEMP_FILE" | grep "resultcount" | wc -l | tr -dC [0-9]`
		echo "More Results: [$NEXT]"
		
		if [ "$NEXT" == "1" ]
		then
			for SECTION_ID in `cat $TEMP_FILE | grep -o "ItemID=[0-9]*" | tr -d [a-zA-Z=]  | sort | uniq`
			do
				SECTION_FILE="$TEMP_DIR/section_""$SECTION_ID"".html"
				SECTION_IN_FILE=`cat "$DATA_FILE" | grep "$SECTION_ID" | wc -l | tr -dC [0-9]`
				if [  "$SECTION_IN_FILE" == "0" ]
				then
					echo -e "\t Parsing Property: [$SECTION_ID] -> [$SECTION_FILE]"
					curl -s "http://www.maltapark.com/item.aspx?ItemID=$SECTION_ID" > "$SECTION_FILE""_bak"
					cat "$SECTION_FILE""_bak" | grep -v "DOCTYPE" | tr -d "\r"  > "$SECTION_FILE"
					rm -rf "$SECTION_FILE""_bak"
					DATA=`python parseMaltaParkPage.py "$SECTION_FILE" "$PAGE" "$SECTION_ID"`
					if [ "$DATA" != "" ]; then
						echo "$DATA" >> "$DATA_FILE"
					fi
				else
					echo -e "\t Parsing Property: [$SECTION_ID] -> Duplicate Entry Found.  "
				fi
				
				
				
			done
		fi
		
	done
done