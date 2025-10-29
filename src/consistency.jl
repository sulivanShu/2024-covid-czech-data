@info "Consistency check"
found_inconsistent = ThreadsX.any(dose_rank_consistency, df)
if found_inconsistent
    error("Inconsistency found in vaccine dose ranks!")
end
@info "No inconsistency found"
