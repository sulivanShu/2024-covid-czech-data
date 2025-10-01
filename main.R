source("variables.R")
source("functions.R")

load_or_install_then_load(Libraries)

downloadAndCheckData(CzechDataCsv, CzechDataCsvUrl, CzechDataCsvb3sum, CzechDataCsvQuote)

message("\n🛈 Chargement de trois colonnes uniquement")

load_csv_data(CzechDataCsv, with = MyCzechHeader) ->
	CzechData

	message("\n🛈 Traduction des entêtes en anglais")

CzechData |>
	setnames(MyEnglishHeader) ->
	EnglishCzechData

message("\n🛈 Contrôle des incohérences...")
message("\n🛈 Les colonnes sont de type `character` alors que les données sont de type `intervale de dates`. Pour des raisons de praticité et de simplicité, ces colonnes doivent formatées en `date` unique:")

EnglishCzechData |>
	lapply(class)

message("\n🛈 Certains individus seraient nés avant 1895 et encore vivants en 2020, ce qui est impossible (record de longévité: 121 ans). Il s'agit d'erreurs de saisies. Par ailleurs, même pour les individus qui seraient nés avant 1920, le risque d'erreur de saisie existe, de sorte qu'un individu né en 2015 pourrait avoir été enregistré comme né en 1915. Par conséquent, les individus enregistrés comme nés avant 1920 seront écartés. Par ailleurs, les individus dont la valeur de naissance est `-`, qui signifie probablement une donnée absente, doivent également être écartés:")

EnglishCzechData$date_of_birth |>
	unique() |>
	sort()

message("\n🛈 Certains individus sont déclarés morts avant le début de la campagne de vaccination. Il ne font donc pas l'objet de cette étude et seront donc écartés:")

EnglishCzechData$date_of_death |>
	unique() |>
	sort()

message("\n🛈 Pas d'incohérence visible:")

EnglishCzechData$vaccination_date |>
	unique() |>
	sort()

message("\n🛈 Échantillon des données réelles:")

EnglishCzechData |>
	head() |> 
	print() ->
	MySetOfEnglishCzechData 


message("\n🛈 Données fictives:")

DummyData |> 
	print() ->
	MySetOfEnglishCzechData 

# Données réelles: attention, assez gros
# MySetOfEnglishCzechData = EnglishCzechData

message("\n🛈 Formatage et exclusion des données invalides:")

MySetOfEnglishCzechData |>
	as.data.frame() |>
	formatData() |>
	excludeInvalidData() |>
	print()
