df = [DataFrame(g) for g in groupby(df, [:infection_rank, :_5_years_cat_of_birth, :sex])]
