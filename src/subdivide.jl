@info "Splitting data in vector of DataFrames (parallel)"
dfs = ThreadsX.map(g -> DataFrame(g),
									groupby(dfs, [:_5_years_cat_of_birth, :sex]))
@info "Splitting completed (parallel)"
