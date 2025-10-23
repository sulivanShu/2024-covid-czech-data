@info "Splitting data in vector of DataFrames (parallel)"
df.:vaccinated = .!ismissing.(df.:week_of_dose1)
using ThreadsX
df = ThreadsX.map(g -> DataFrame(g),
									groupby(df, [:vaccinated, :_5_years_cat_of_birth, :sex]))
@info "Splitting completed (parallel)"

df
