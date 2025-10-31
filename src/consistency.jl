@info "Consistency check (parallel)"
found_inconsistent = ThreadsX.any(dose_rank_consistency, dfs)
if found_inconsistent
    error("Inconsistency found in vaccine dose ranks!")
end
@info "No inconsistency found (parallel)"
