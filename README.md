Property Parser
==============

Introduction
=============
A set of property parsers to compare the market, the following parsers are implemented: 
  
  * Remax Parser
  * Frank Salt Parser (in progress)

Remax Parser Parameters
=======================

Minimum Price for the property: 

    ctl00$ddlMinPrice:10000 
    MinPrice:10000

Maximum Price for the property: 

    ctl00$ddlMaxPrice:0
    MaxPrice:

Minimum Rental Price for the property: 

    ctl00$ddlRentalMinPrice:0
    RentalMinPrice:

Maximum Rental Price for the property: 

    ctl00$ddlRentalMaxPrice:0
    RentalMaxPrice:

These are the available types.  
* 579  Apartments
* 7943 Boathouse
* 7944 Bungalows
* 7947 Farmhouses
* 582 Garage/Parking Facilities
* 581 House of Character
* 583 Land
* 580 Maisonettes
* 7951 Manor/Palace/Castle
* 7952 Penthouses
* 584 Terraced Houses
* 7945 Townhouses
* 585 Villas


Set the properties here

    ctl00$ddlPropertyType:584
    PropertyType:584


Minimum number of bedrooms: 

    ctl00$ddlMinNumOfBedrooms:3
    MinNumOfBedrooms:3

The transaction type for the property it is set to  'For Sale':
  
    ctl00$ddlTransactionTypeUID:261
    TransactionTypeUID:261

Additional Properties: 

    ComRes:2
    ctl00$ddlComRes:2
    ctl00$ComResGroup:2

    ctl00$btnSearch:Search Again


Frank Salt Parser Parameters
============================
Site Identifier - Always 1
    
	styid:1
    iscom:false
    mtyid:1

Type of property
* -1  Any Type
* 16  Airspace
* 6   Apartment
* 14  Block of Apartments
* 9   Bungalow
* 4   Farmhouse
* 13  Garage
* 3   House of Character
* 8   Maisonette 
* 15  Palazzo 
* 7   Penthouse
* 2   Plot 
* 1   Site
* 30  Terraced House
* 5   Town House
* 10  Villa
* 12  Commercial
typid:30

The location.  
* -1 Any Locality   
* 1 Attard    
* 2 Bahar ic-Caghaq   
* 3 Bahrija    
* 4 Balzan    
* 5 Bidnija    
* 6 Birguma    
* 7 Birkirkara    
* 8 Birzebuggia    
* 9 Blata l-Bajda   
* 10 Bugibba    
* 11 Burmarrad    
* 116 Buskett    
* 12 Cospicua    
* 13 Dingli    
* 14 Dwejra    
* 15 Dwejra - Gozo  
* 16 Fgura    
* 17 Fleur-de-Lys    
* 18 Floriana    
* 127 Fontana    
* 20 Fort Cambridge   
* 19 Fort Chambray   
* 21 Ghajn Tuffieha   
* 22 Ghajnsielem - Gozo  
* 23 Gharb - Gozo  
* 24 Gharghur    
* 25 Ghasri - Gozo  
* 26 Ghaxaq    
* 27 Gnejna    
* -1000 Gozo    
* 29 Gudja    
* 30 Gwardamangia    
* 31 Gzira    
* 32 Hal Saghtrija   
* 33 Hal-Far    
* 34 Hamrun    
* 35 Kalkara    
* 36 Kappara    
* 37 Kempinski    
* 38 Kercem - Gozo  
* 39 Kirkop    
* 41 L'Iklin    
* 40 Lija    
* 42 Luqa    
* 43 Madliena    
* 44 Maghtab    
* 45 Manikata    
* 46 Marsa    
* 47 Marsalforn - Gozo  
* 48 Marsascala    
* 49 Marsaxlokk    
* 50 Mdina    
* 51 Mellieha    
* 52 Mgarr    
* 53 Mgarr - Gozo  
* 54 Mosta    
* 55 Mqabba    
* 56 Mriehel    
* 57 Msida    
* 58 Mtahleb    
* 59 Mtarfa    
* 60 Munxar - Gozo  
* 61 Nadur - Gozo  
* 62 Naxxar    
* 63 Paceville    
* 64 Paola    
* 65 Pembroke    
* 66 Pender Gardens   
* 67 Pieta    
* 68 Portomaso    
* 69 Qala - Gozo  
* 70 Qawra    
* 71 Qormi    
* 72 Qrendi    
* 73 Rabat    
* 74 Safi    
* 75 Salina    
* 76 San Blass - Gozo 
* 77 San Gwann   
* 78 San Lawrenz - Gozo 
* 79 San Pawl tat-Targa  
* 80 Sannat - Gozo  
* 81 Santa Lucia   
* 82 Santa Lucija - Gozo 
* 83 Santa Venera   
* 84 Selmun    
* 85 Senglea    
* 86 Siggiewi    
* 87 Sliema    
* 88 St. Andrews   
* 89 St. Angelo Mansions  
* 90 St. Julians   
* 91 St. Pauls Bay  
* 92 Swatar    
* 93 Swieqi    
* 95 Ta Monita   
* 96 Ta' Qali   
* 97 Ta' Xbiex   
* 94 Ta' l-Ibragg   
* 98 Tarxien    
* 99 Tas Sellum   
* 100 Tigne Point   
* 101 Valletta    
* 102 Victoria - Gozo  
* 103 Vittoriosa    
* 104 Wardija    
* 105 Xaghra - Gozo  
* 106 Xemxija    
* 107 Xewkija - Gozo  
* 108 Xghajra    
* 109 Xlendi - Gozo  
* 110 Zabbar    
* 111 Zebbiegh    
* 112 Zebbug    
* 113 Zebbug - Gozo  
* 114 Zejtun    
* 115 Zurrieq    

Set the properties here

    locid:-1

The price range for the property.  
    
	curid:EUR
    prcfr:-1
    prcto:450000
    avidt:

The Number of meters square the property will have.  

    areafr:0
    areato:-1

Default Parameters
    
	ctl00$smMainScriptManager:
    ctl00$content$ddlSort:price-low-to-high:
    ctl00$content$gvpDataPager$btnNext:>

