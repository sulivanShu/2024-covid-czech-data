@info "Filtering data (parallel)"
filter!(is_valid_df, dfs)
ThreadsX.foreach(df -> modify_df!(df), dfs)
@info "Filtering completed (parallel)"
