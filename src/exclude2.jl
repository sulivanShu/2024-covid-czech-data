using ThreadsX
df = filter(!isnothing, ThreadsX.map(subdf -> exclude!(subdf), df))
