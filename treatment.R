message("\n🛈 Formatage et exclusion des données invalides:")

my_set_of_english_czech_data |>
  as.data.frame() |>
  format_data() |>
  exclude_invalid_data() |>
  nrow() |>
  print()
