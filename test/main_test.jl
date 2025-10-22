@time include("src/projectManager.jl")
@time include("src/variables.jl")
@time include("src/functions.jl")
@time include("src/download.jl")
@time include("src/checksum.jl")
@time include("src/load.jl") # Ne pas oublier de charger aussi la mortalité covid pour comparer avec la mortalité normale. Vérifier aussi s'il n'y a pas de gens qui se sont fait vacciner une deuxième fois sans s'être fait vaccinés une première...
# using JLD2
# @save "data/exp_pro/unformated_df.jld2" df
# @load "data/exp_pro/unformated_df.jld2" df
# include("src/header.jl")
# @time include("src/format.jl") # serial (slower)
# @load "data/exp_pro/unformated_df.jld2" df
@time include("src/header.jl")
@time include("src/subdivide2.jl") # parallel (same)
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
# ensuite censurer les données à partir d'une certaine date...

println("Taille mémoire du DataFrame : ", round(Base.summarysize(df) / 1024^2), " Mo")

df
typeof(df)
length(df)




df = nothing
names(df)
