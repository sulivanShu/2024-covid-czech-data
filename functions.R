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
      data$birth_year |>
        int_start() |>
        (\(x) {
          # La valeur de la catégorie de date de naissance ne doit pas être NA
          !is.na(x) &
            # la valeur de la catégorie de date de naissance comprise entre certaines dates
            x >= as.Date("1920-01-01") &
            x < as.Date("2020-01-01")
        })()
    ) &
      (
        data$date_of_death_registry |>
          int_start() |>
          (\(x) {
            # la valeur de la catégorie de date de décès peut être na (pas encore mort)
            is.na(x) |
              # la valeur de la catégorie de date de décès ne peut pas être antérieure au début de la campagne de vaccination
              x >= as.Date("2020-12-27")
          })()
      ) & # à remplacer par une variable
      # Le sexe des individus doit être connu
      !is.na(data$sex) & # en fait, il n'y a en plus après les traitements ci-dessus
      ( # Pour les infectés le rang de l'infection doit être égale à 1.
        data$infection == 1 |
          # Pour les non-infectés, le rang de l'infection doit être NA.
          data$infection |>
            is.na()
      ),
    # virgule finale nécessaire!
  ]
}
