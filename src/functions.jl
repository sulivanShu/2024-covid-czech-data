@info "Loading functions"

# Downloads
using Downloads

function DownloadCheck(file::AbstractString, URL::AbstractString)
	if !isfile(file)
		@info "File missing, downloading..."
		Downloads.download(URL, file)
		@info "Download completed."
	else
		@info "File already present."
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
		error("The hash of file $(file) does not match the expected value.")
	else
		@info "The hash of file $(file) matches the expected value."
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
    first_row = df[1, :]
    if ismissing(first_row._5_years_cat_of_birth) ||
       !(1920 <= first_row._5_years_cat_of_birth < 2020) ||
       ismissing(first_row.sex) ||
       !(coalesce(first_row.infection_rank, 0) == 1 || ismissing(first_row.infection_rank))
        return nothing  # supprimer tout le DataFrame
    end
    # filtrer seulement sur week_of_death
    filter!(row -> ismissing(row.week_of_death) || row.week_of_death >= Date("2020-12-27"), df)
    return df
end

@info "Loading completed"
