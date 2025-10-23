# using JLD2
@time include("src/project.jl")
@time include("src/packages.jl")
@time include("src/variables.jl")
@time include("src/functions.jl")
@time include("src/download.jl")
@time include("src/checksum.jl")
@time include("src/load.jl") # Ne pas oublier de charger aussi la mortalité covid pour comparer avec la mortalité normale. Vérifier aussi s'il n'y a pas de gens qui se sont fait vacciner une deuxième fois sans s'être fait vaccinés une première...
# @save "data/exp_pro/unformated_df.jld2" df
# @load "data/exp_pro/unformated_df.jld2" df
# include("src/header.jl")
# @time include("src/format.jl") # serial (slower)
# @load "data/exp_pro/unformated_df.jld2" df
@time include("src/header.jl")
@time include("src/subdivide2.jl") # parallel (same)
# subidiver avec week_of_dose1 aussi! vaccinés et non-vaccinés sont mélangés!
# ceux qui sont nés avant 1940 ans ne sont pas réunis dans un même dataframe!
# ajouter ici les tests au sujet de la mortalité et des secondes vaccinations! Ou les ajouter ailleurs?
@time include("src/format2.jl") # parallel (faster)
# using JLD2
# @save "data/exp_pro/formated_df.jld2" df
#
# Serial version
# @load "data/exp_pro/formated_df.jld2" df
# @time include("src/exclude.jl") # serial
# @load "data/exp_pro/formated_df.jld2" df
# @time include("src/subdivide.jl") # serial (faster)
# @load "data/exp_pro/formated_df.jld2" df
# @time include("src/subdivide2.jl") # parallel (slower)
@time include("src/exclude2.jl") # parallel
# using JLD2
# @save "data/exp_pro/excluded_df.jld2" df
# @load "data/exp_pro/excluded_df.jld2" df
# merge les >80 ans. mais on ne peut pas merger les +80 ans sans les standardiser! Peut-être les traiter à part? standardiser plus tard, lors des standardisations... en tout cas, il faut merger les infection_rank...
# mettre les tests (2e doses sans 1er, mort du covid mais pas mort) ici? ou alors les mettre dans exclude2.jl ?
# ensuite censurer les données à partir d'une certaine date...
length(df)

df |>
    x -> ThreadsX.map(subdf -> first(subdf, 1), x) |>
    x -> reduce(vcat, x) |>
    x -> sort(x, [:sex, :_5_years_cat_of_birth, :week_of_dose1]) |>
		x -> select(x, :vaccinated) |>
    x -> show(x, allrows = true)

println("Taille mémoire du DataFrame : ", round(Base.summarysize(df) / 1024^2), " Mo")
df
typeof(df)
df = nothing
names(df)
