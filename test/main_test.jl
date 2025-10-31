@time include("src/project.jl")
@time include("src/packages.jl")
@time include("src/variables.jl")
@time include("src/functions.jl")
@time include("src/download.jl")
# @time include("src/checksum.jl")
@time include("src/load.jl")
# @save "data/exp_pro/unformated_dfs.jld2" dfs
# @load "data/exp_pro/unformated_dfs.jld2" dfs
@time include("src/header.jl")
@time include("src/subdivide.jl") # parallel (same)
# @save "data/exp_pro/subdivised_dfs.jld2" dfs
# ceux qui sont nés avant 1940 ans ne sont pas réunis dans un même dataframe!
# @load "data/exp_pro/subdivised_dfs.jld2" dfs
@time include("src/columns.jl")
@time include("src/format.jl") # parallel (faster)
# @save "data/exp_pro/formated_dfs.jld2" dfs
# @load "data/exp_pro/formated_dfs.jld2" dfs
@time include("src/exclude.jl") # parallel
# @save "data/exp_pro/excluded_dfs.jld2" dfs
# merge les >80 ans. mais on ne peut pas merger les +80 ans sans les standardiser! Peut-être les traiter à part? standardiser plus tard, lors des standardisations... en tout cas, il faut merger les infection_rank...
# @load "data/exp_pro/excluded_dfs.jld2" dfs
# ensuite censurer les données à partir d'une certaine date...
length(dfs)
