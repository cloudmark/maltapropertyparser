cleanall: 
	rm -rf data.csv
	touch data.csv

remax: 
	./grabRemaxPage.sh

franksalt: 
	./grabFrankSaltPage.sh

maltapark: 
	./grabMaltaParkPages.sh

refresh: cleanall remax franksalt maltapark
