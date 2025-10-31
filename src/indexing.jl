@info "Indexing data"
dfs = Dict(
    parse(Int, string(first(df.sex), first(df."_5_years_cat_of_birth"))) => df
    for df in dfs
)
ThreadsX.foreach(subdf -> select!(subdf.second, [:week_of_dose1, :week_of_death]), dfs)
@info "Indexing completed"

