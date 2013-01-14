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

doc = lxml.html.parse(sys.argv[1])
property_element=doc.xpath(".//span[@id='content_lblLocality']")
price_element=doc.xpath(".//span[@id='content_lblPrice']")
type_element=doc.xpath(".//span[@id='content_lblType']")
property_location=property_element[0].text_content()
line = sys.argv[2] + ","
line += "http://www.franksalt.com.mt/Search/PropertyDetails.aspx?id=" + sys.argv[3] + ","
line +=  clean_string(property_location) + ","
if len(price_element):
	line += clean_integer_string(price_element[0].text_content()) + ","
else: 
	line += "NA,"
line += "Frank Salt" + ","
line += "NA" + ","
line += clean_string(type_element[0].text_content()) 
print smart_str(line)
