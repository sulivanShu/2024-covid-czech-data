@info "Splitting data in vector of DataFrames (parallel)"
using ThreadsX
df = ThreadsX.map(g -> DataFrame(g),
                 groupby(df, [:infection_rank, :_5_years_cat_of_birth, :sex]))
@info "Splitting completed (parallel)"
