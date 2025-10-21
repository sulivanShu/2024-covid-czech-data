# Downloads
using Downloads

function DownloadCheck(file::AbstractString, URL::AbstractString)
	if !isfile(file)
		println("Fichier absent, téléchargement en cours…")
		Downloads.download(URL, file)
		println("Téléchargement terminé.")
	else
		println("Fichier déjà présent.")
	end
end

# Checksum
using Blake3Hash

function HashCheck(file::AbstractString, b3sum::AbstractString)
	hasher = Blake3Ctx()
	update!(hasher, read(file))
	hash = digest(hasher)
	computed = bytes2hex(hash)
	if computed != b3sum
		error("Le hash du fichier $(file) ne correspond pas à la valeur attendue.")
	else
		@info "Le hash du fichier $(file) correspond à la valeur attendue."
	end
end

# Load
using CSV, DataFrames

function load_csv_data(file::AbstractString, select_cols)
	return CSV.File(file; select=select_cols) |> DataFrame
end

# Format
function convert_to_uint8!(df::DataFrame, col::Symbol)
	df[!, col] = convert(Vector{Union{Missing, UInt8}}, df[!, col])
	return df
end

function parse_year_column!(df::DataFrame, col::Symbol)
	df[!, col] = map(x -> 
									 length(String(x)) == 1 ? missing : UInt16(parse(Int, first(String(x), 4))),
									 df[!, col]
									)
	return df
end

using Dates
function isoweek_to_date!(df::DataFrame, col::Symbol)
	df[!, col] = map(x -> 
									 ismissing(x) ? missing : begin
										 year, week = parse.(Int, split(x, "-"))
										 Date(year, 1, 1) + Week(week - 1)  # premier jour de la semaine
									 end,
									 df[!, col])
	return df
end

# Exclude
using DataFrames, Dates

function exclude!(df::DataFrame)
    filter!(row ->
        !ismissing(row._5_years_cat_of_birth) &&
        (1920 <= row._5_years_cat_of_birth < 2020) &&
        (ismissing(row.week_of_death) || row.week_of_death >= Date("2020-12-27")) &&
        !ismissing(row.sex) &&
        (coalesce(row.infection_rank, 0) == 1 || ismissing(row.infection_rank)),
        df
    )
    return df
end
