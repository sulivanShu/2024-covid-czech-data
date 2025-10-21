nrow(df)

first(df)



first(df, 10)
names(df)
ncol(df)

println("Taille mémoire du DataFrame : ", round(Base.summarysize(df) / 1024^2), " Mo")

typeof(df.infection_rank)
typeof(df.sex)
typeof(df._5_years_cat_of_birth)
typeof(df.week_of_dose1)
typeof(df.week_of_death)

unique(df.infection_rank)
unique(df.sex)
unique(df._5_years_cat_of_birth) |> sort
unique(df.week_of_dose1) |> sort
unique(df.week_of_death) |> sort

