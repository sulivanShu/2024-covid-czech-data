message("\n🛈 Contrôle des incohérences...")

english_czech_data |>
  lapply(class) |>
  print()

message("\n🛈 Certains individus seraient nés avant 1895 et encore vivants en 2020, ce qui est impossible (record de longévité: 121 ans). Il s'agit d'erreurs de saisies. Par ailleurs, même pour les individus qui seraient nés avant 1920, le risque d'erreur de saisie existe, de sorte qu'un individu né en 2015 pourrait avoir été enregistré comme né en 1915. Par conséquent, les individus enregistrés comme nés avant 1920 seront écartés. Par ailleurs, les individus dont la valeur de naissance est `-`, qui signifie probablement une donnée absente, doivent également être écartés:")


english_czech_data$infection |>
  unique() |>
  sort() |>
  print()

english_czech_data[is.na(english_czech_data$infection)]

english_czech_data$sex |>
  unique() |>
  sort() |>
  print()

english_czech_data[is.na(english_czech_data$sex)]

english_czech_data$birth_year |>
  unique() |>
  sort() |>
  print()

message("\n🛈 Certains individus sont déclarés morts avant le début de la campagne de vaccination. Il ne font donc pas l'objet de cette étude et seront donc écartés:")

english_czech_data$date_of_death_registry |>
  unique() |>
  sort() |>
  print()

message("\n🛈 Pas d'incohérence visible:")

english_czech_data$date_dose1 |>
  unique() |>
  sort() |>
  print()
