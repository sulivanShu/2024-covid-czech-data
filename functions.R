load_or_install_then_load_one <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}

load_or_install_then_load <- function(pkgs) {
  lapply(pkgs, load_or_install_then_load_one) |>
    invisible()
}

download_and_check_data <- function(file, url, refhash, quote) {
  if (!file.exists(file)) {
    message("\n🛈 Le fichier est absent. Téléchargement en cours...")
    download.file(url, destfile = file, mode = "wb", quiet = TRUE)
    message("\n🛈 Vérification de l'intégrité...\n")
    hash_calc <- digest(file = file, algo = "blake3")
    if (identical(hash_calc, refhash)) {
      message("\n✔ Intégrité vérifiée : le hash correspond. On continue.\n")
    } else {
      stop("\n❌ Erreur : le hash ne correspond pas. Arrêt du programme.")
    }
  } else {
    message("\n🛈 Fichier déjà téléchargé: pas de vérification du hash.")
    message("⚠️ Vérifiez vous-même le hash si vous avez téléchargé le fichier manuellement.")
  }
  message(paste("\n🛈 Source de données: ", quote))
}

load_csv_data <- function(file, with) {
  fread(file, select = with)
}

format_data <- function(data) {
  lapply(data[year_year], \(cell) {
    ifelse(nchar(cell) == 9, sub("(^....).*", "\\1", cell), NA) |>
      paste0("-01-01") |>
      as.Date() |>
      (\(date_start) {
        interval(date_start, date_start + years(4) + months(11) + days(30))
      })()
  }) ->
  data[year_year]
  lapply(data[year_week], \(cell) {
    ifelse(nchar(cell) == 0, NA, cell) ->
    cell
    ifelse(nchar(cell) == 7, sub("(.....)(..)", "\\1W\\2-1", cell), cell) |>
      ISOweek2date() |>
      (\(date_start) interval(date_start, date_start + days(6)))()
  }) ->
  data[year_week]
  data
}

exclude_invalid_data <- function(data) {
  data[
    (
      # la catégorie de date de naissance ne doit pas être NA
      data$birth_year |>
        int_start() |>
        Negate(is.na)() &
        # la catégorie de date de naissance ne doit pas être inférieur à une certaine date
        data$birth_year |>
          int_start() >= as.Date("1920-01-01")) &
      # la catégorie de date de décès peut être NA (pas encore mort)
      (data$date_of_death_registry |>
        int_start() |>
        is.na() |
        # la catégorie de date de décès ne peut pas être antérieur au début de la campagne de vaccination
        data$date_of_death_registry |>
          int_start() >= as.Date("2020-12-21")) & # à remplacer par une variable
      # le sexe des individus doit être connu
      data$sex |>
        Negate(is.na)() & # en fait, il n'y a en plus après les traitements ci-dessus
      # le nombre d'infection doit être égal à 0 ou 1.
      data$infection < 2,
    # firgule finale nécessaire!
  ]
}
