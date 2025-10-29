@info "Splitting data in vector of DataFrames (parallel)"
df = ThreadsX.map(g -> DataFrame(g),
									groupby(df, [:_5_years_cat_of_birth, :sex]))
@info "Splitting completed (parallel)"
