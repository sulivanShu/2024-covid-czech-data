@info "Drop unused columns"
ThreadsX.foreach(drop_unused_columns!, df)
@info "Unused columns droped"
