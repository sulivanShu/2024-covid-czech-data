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

formatdata <- function(data) {
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
    (!is.na(int_start(data$birth_year)) &
      int_start(data$birth_year) >= as.Date("1922-07-01")) &
      (is.na(int_end(data$date_of_death_registry)) |
        int_end(data$date_of_death_registry) >= as.Date("2020-12-25")),
  ]
}

average_date <- function(data) {
  lapply(data, \(col) {
    vapply(col, \(cell) {
      mean(c(int_start(cell), int_end(cell)))
    }, numeric(1)) |>
      as.POSIXct(origin = "1970-01-01", tz = "UTC")
  }) |>
    as.data.frame()
}
