Libraries = c( "data.table", "ISOweek", "lubridate", "digest", "ggplot2")
CzechDataCsv = "Otevrena-data-NR-26-30-COVID-19-prehled-populace-2024-01.csv"
CzechDataCsvUrl = "https://data.mzcr.cz/data/distribuce/402/Otevrena-data-NR-26-30-COVID-19-prehled-populace-2024-01.csv"
CzechDataCsvb3sum = "28a58ec2c8360cdf4ae599cc59bd6e8c678aa7ccbab7debc5d3c3faf645dfcd6"
CzechDataCsvQuote = "Šanca O., Jarkovský J., Klimeš D., Zelinková H., Klika P., Benešová K., Mužík J., Komenda M., Dušek L. Očkování, pozitivity, hospitalizace pro COVID-19, úmrtí, long covid a komorbidity u osob v ČR. Národní zdravotnický informační portál [online]. Praha: Ministerstvo zdravotnictví ČR a Ústav zdravotnických informací a statistiky ČR, 2024 [cit. 2025-09-29]. Dostupné z: http://www.nzip.cz/data/2135-covid-19-prehled-populace. ISSN 2695-0340"
MyCzechHeader = c("RokNarozeni","Umrti","Datum_Prvni_davka")
MyEnglishHeader = c("date_of_birth", "date_of_death", "vaccination_date")
YEAR_WEEK = c("vaccination_date", "date_of_death")
YEAR_YEAR = c("date_of_birth")
DummyData = data.frame(
	c("1970-1974","-","1950-1955","1860-1864", "1985-1989"),
	c("2022-26","","","","2020-05"),
	c("","2023-09","2021-01","2022-05","")
)
colnames(DummyData) = MyEnglishHeader
