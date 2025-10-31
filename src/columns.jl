@info "Drop unused columns"
ThreadsX.foreach(drop_unused_columns!, dfs)
@info "Unused columns droped"
