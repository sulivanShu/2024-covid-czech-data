@info "Filtering data (parallel)"
df = filter(!isnothing, ThreadsX.map(subdf -> exclude!(subdf), df))
@info "Filtering completed (parallel)"
