message("\n🛈 Traduction des entêtes en anglais")

czech_data |>
  setnames(my_english_header) ->
english_czech_data

message("\n🛈 Échantillon des données réelles:")

english_czech_data |>
  (\(data) data[, c("infection", "sex", "birth_year", "date_dose1", "date_of_death_registry")])() |>
  head(1000) |> # commenter la ligne pour avoir toutes les données
  print() ->
my_set_of_english_czech_data
