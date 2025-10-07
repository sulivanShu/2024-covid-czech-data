source("variables.R")
source("functions.R")

load_or_install_then_load(libraries)

download_and_check_data(czech_data_csv, czech_data_csv_url, czech_data_csv_b3sum, czech_data_csv_quote)

load_csv_data(czech_data_csv, with = my_czech_header) ->
czech_data

message("\n🛈 Traduction des entêtes en anglais")

czech_data |>
  setnames(my_english_header) ->
english_czech_data

message("\n🛈 Contrôle des incohérences...")

english_czech_data |>
  lapply(class)

message("\n🛈 Certains individus seraient nés avant 1895 et encore vivants en 2020, ce qui est impossible (record de longévité: 121 ans). Il s'agit d'erreurs de saisies. Par ailleurs, même pour les individus qui seraient nés avant 1920, le risque d'erreur de saisie existe, de sorte qu'un individu né en 2015 pourrait avoir été enregistré comme né en 1915. Par conséquent, les individus enregistrés comme nés avant 1920 seront écartés. Par ailleurs, les individus dont la valeur de naissance est `-`, qui signifie probablement une donnée absente, doivent également être écartés:")


english_czech_data$infection |>
  unique() |>
  sort()

english_czech_data[is.na(english_czech_data$infection)]

english_czech_data$sex |>
  unique() |>
  sort()

english_czech_data[is.na(english_czech_data$sex)]

english_czech_data$birth_year |>
  unique() |>
  sort()

message("\n🛈 Certains individus sont déclarés morts avant le début de la campagne de vaccination. Il ne font donc pas l'objet de cette étude et seront donc écartés:")

english_czech_data$date_of_death_registry |>
  unique() |>
  sort()

message("\n🛈 Pas d'incohérence visible:")

english_czech_data$date_dose1 |>
  unique() |>
  sort()

message("\n🛈 Échantillon des données réelles:")

english_czech_data |>
  (\(data) data[, c("infection", "sex", "birth_year", "date_dose1", "date_of_death_registry")])() |>
  head(1000) |>
  print() ->
my_set_of_english_czech_data


# message("\n🛈 Données fictives:")
# dummy_data |>
# print() ->
# my_set_of_english_czech_data

# Données réelles: attention, assez gros
# my_set_of_english_czech_data = english_czech_data

message("\n🛈 Formatage et exclusion des données invalides:")

my_set_of_english_czech_data |>
  lapply(class)

my_set_of_english_czech_data |>
  as.data.frame() |>
  formatdata() |>
  # (\(data) {
  #   data[, c("date_dose1")] |>
  #     int_start()
  # })() |>
  # unique() |>
  # sort() |>
  exclude_invalid_data() |> # à vérifier!
  nrow() |>
  # as.data.table() |> # ne fonctionne pas avec plus de 100 lignes
  print()
# https://r-dev-perf.borishejblum.science/parallelisation-du-code-r
#
# help("as.data.table")
