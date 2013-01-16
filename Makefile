cleanall: 
	rm -rf data.csv

remax: 
	./grabRemaxPage.sh

franksalt: 
	./grabFrankSaltPage.sh

maltapark: 
	./grabMaltaParkPages.sh

refresh: cleanall remax franksalt maltapark
