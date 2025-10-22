@info "Formatting data (parallel)"
using ThreadsX
df = ThreadsX.map(subdf -> begin
    convert_to_uint8!(subdf, :sex)
    convert_to_uint8!(subdf, :infection_rank)
    parse_year_column!(subdf, :_5_years_cat_of_birth)
    isoweek_to_date!(subdf, :week_of_dose1)
    isoweek_to_date!(subdf, :week_of_death)
    subdf
end, df)
@info "Formatting completed (parallel)"
