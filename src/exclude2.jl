@info "Filtering data (parallel)"
using ThreadsX
df = filter(!isnothing, ThreadsX.map(subdf -> exclude!(subdf), df))
@info "Filtering completed (parallel)"
