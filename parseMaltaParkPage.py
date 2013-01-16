# The Parser for the REMAX page, it will return the following properties. 
# Page, Property URL, Property Location, Price, Agent, Agent URL, Type
from lxml import etree
from StringIO import StringIO
import lxml.html
import sys
import re
from django.utils.encoding import smart_str, smart_unicode
import ConfigParser, os

def clean_string(str): 
    return str.replace('\r', ' ').replace('\n', ' ').replace(',',' ').strip().lower()

def clean_integer_string(str): 
    str = clean_string(str)
    pattern = re.compile(r'[^\d]+')
    return re.sub(pattern, '', str)

def clean_postcode(str):
    return str.lower().replace("central", "").replace("south", "").replace("north","").strip()

config = ConfigParser.ConfigParser()
config.readfp(open('queryMaltaParkParam.txt'))

type_csv=config.get("Properties", "TypeCSV")
minPrice=config.getint("Properties", "MinPrice")
maxPrice=config.getint("Properties", "MaxPrice")
minNumOfBedrooms=config.getint("Properties", "MinNumOfBedrooms")


filtered=False
doc = lxml.html.parse(sys.argv[1])
wanted_element = doc.xpath(".//span[@class='wanteddet']")
if wanted_element: 
    filtered=True
else :
    title_element = doc.xpath(".//td[@class='title']/a")
    price_element = doc.xpath(".//div[@id='divPrice']")

    type_element = type_csv

    # We have a problem with this, we perhaps have to use heuristics.  
    property_location = "Unknown"

    # Do we filter by price? If the price is set we will check.     
    price = None
    if (len(price_element) == 1):
        price = clean_integer_string(price_element[0].text_content())
        if (price != None) and (price != ""):
            if int(price) < minPrice or int(price) > maxPrice: 
                filtered=True

    list_items = doc.xpath(".//ul[@class='optionaldetails']/li")

    # property_type = [item for item in list_items if item.text_content() == "Property Type:"]
    bedrooms = [item for item in list_items if item.xpath("label")[0].text_content() == "Bedrooms:"]    
    # Do we filter by the number of bedrooms?
    if len(bedrooms):
        bedroomCount=clean_integer_string(bedrooms[0].text_content())
        if int(bedroomCount) < minNumOfBedrooms:
            filtered=True

    # Page, Property URL, Property Location, Price, Agent, Agent URL, Type
    line = sys.argv[2] + ","
    line += "http://www.maltapark.com/item.aspx?ItemID=" + sys.argv[3] + ","
    line +=  clean_string(property_location) + ","
    if price:
        line += price + ","
    else: 
        line += "NA,"
    line += "Malta Park" + ","
    line += "NA" + ","
    line += clean_string(type_element) 
    if not filtered:
        print smart_str(line)