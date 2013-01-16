# The Parser for the REMAX page, it will return the following properties. 
# Page, Property URL, Property Location, Price, Agent, Agent URL, Type
from lxml import etree
from StringIO import StringIO
import lxml.html
import sys
import re
from django.utils.encoding import smart_str, smart_unicode

def clean_string(str): 
    return str.replace('\r', ' ').replace('\n', ' ').replace(',',' ').strip().lower()

def clean_integer_string(str): 
    str = clean_string(str)
    pattern = re.compile(r'[^\d]+')
    return re.sub(pattern, '', str)

def clean_postcode(str):
    return str.lower().replace("central", "").replace("south", "").replace("north","").strip()


doc = lxml.html.parse(sys.argv[1])
results = doc.xpath('//*[@class="proplist_tbl"]')
for result in results: 
    property_element=result.xpath(".//td[@class='proplist_address']/a")
    price_element=result.xpath(".//a[@class='proplist_price']")
    type_element=result.xpath(".//span[@class='proplist_features']")
    agent_element=result.xpath(".//a[@class='listinglist_agentname']")
    property_url= "www.remax-malta.com" + property_element[0].attrib.get('href')
    property_location=clean_postcode(property_element[0].text)

    line = sys.argv[2] + ","
    line += clean_string(property_url) + ","
    line += clean_string(property_location) + ","
    if len(price_element):
        line += clean_integer_string(price_element[0].text) + ","
    else:
        line += "NA,"
    line += clean_string(agent_element[0].text_content()) + ","
    line += clean_string(agent_element[0].attrib.get('href')) + ","
    line += clean_string(type_element[0].text_content())
    print smart_str(line)
