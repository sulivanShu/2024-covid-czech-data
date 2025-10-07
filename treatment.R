message("\n🛈 Échantillon des données réelles:")

english_czech_data |>
  (\(data) data[, c("infection", "sex", "birth_year", "date_dose1", "date_of_death_registry")])() |>
  head(1000) |> # commenter la ligne pour avoir toutes les données
  print() ->
my_set_of_english_czech_data

message("\n🛈 Formatage et exclusion des données invalides:")

my_set_of_english_czech_data |>
  lapply(class)

my_set_of_english_czech_data |>
  as.data.frame() |>
  format_data() |>
  exclude_invalid_data() |>
  nrow() |>
  # as.data.table() |> # ne fonctionne pas avec plus de 100 lignes
  print()
# https://r-dev-perf.borishejblum.science/parallelisation-du-code-r
#
# help("as.data.table")
