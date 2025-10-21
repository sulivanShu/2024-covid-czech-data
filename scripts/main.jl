include("src/projectManager.jl")
include("src/variables.jl")
include("src/functions.jl")
include("src/download.jl")
include("src/checksum.jl")
include("src/load.jl")
# using JLD2
# @save "data/exp_pro/unformated_df.jld2" df
# @load "data/exp_pro/unformated_df.jld2" df
include("src/format.jl")
# using JLD2
# @save "data/exp_pro/formated_df.jld2" df
# @load "data/exp_pro/formated_df.jld2" df
include("src/exclude.jl")
# using JLD2
# @save "data/exp_pro/excluded_df.jld2" df
# @load "data/exp_pro/excluded_df.jld2" df
include("src/divide.jl")
