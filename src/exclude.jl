@info "Filtering data (parallel)"
dfs = filter(!isnothing, ThreadsX.map(subdf -> exclude!(subdf), dfs))
@info "Filtering completed (parallel)"
