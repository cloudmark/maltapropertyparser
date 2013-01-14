cleanall: 
	rm -rf data.csv

remax: 
	./grabRemaxPage.sh

franksalt: 
	./grabFrankSaltPage.sh

refresh: cleanall remax franksalt
