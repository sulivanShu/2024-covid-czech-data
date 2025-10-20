source("variables.R")
source("functions.R")

load_or_install_then_load(Libraries)
library()

# Création d'une grande liste
set.seed(1)
# big_list <- lapply(1:1e7, function(x) x)

# Fonctions à tester
f_lapply_unlist <- function(x) unlist(lapply(x, function(y) y + 1))
f_sapply <- function(x) sapply(x, function(y) y + 1)
f_vapply <- function(x) vapply(x, function(y) y + 1, numeric(1))

# Benchmark
res <- microbenchmark(
  lapply_unlist = f_lapply_unlist(big_list),
  sapply = f_sapply(big_list),
  vapply = f_vapply(big_list),
  times = 5
)

print(res)

# rm(big_list)        # supprime l'objet
# gc()                # demande à R de libérer la mémoire inutilisée
#
install.packages(c("xml2", "lintr", "roxygen2"))
install.packages("languageserver")
