@info "Loading functions"

# Downloads
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
function HashCheck(file::AbstractString, b3sum::AbstractString)
	hasher = Blake3Ctx()
	update!(hasher, read(file))
	hash = digest(hasher)
	computed = bytes2hex(hash)
	if computed != b3sum
		error("The hash of file $(file) does not match the expected value.")
	end
	hash_int = reinterpret(UInt64, hash[1:8])[1]
	return hash_int
end

# Load
function load_csv_data(file::AbstractString, select_cols)
	return CSV.File(file; select=select_cols) |> DataFrame
end

# Consistency check
function dose_rank_consistency(df::DataFrame)
    count = nrow(filter(row ->
        ismissing(row.week_of_dose1) &&
        (
            !ismissing(row.week_of_dose2) ||
            !ismissing(row.week_of_dose3) ||
            !ismissing(row.week_of_dose4) ||
            !ismissing(row.week_of_dose5) ||
            !ismissing(row.week_of_dose6) ||
            !ismissing(row.week_of_dose7)
        ), df))
    count != 0
end

# Remove unused columns
function drop_unused_columns!(df::DataFrame)
	select!(df, Not([
									 :week_of_dose2,
									 :week_of_dose3,
									 :week_of_dose4,
									 :week_of_dose5,
									 :week_of_dose6,
									 :week_of_dose7
									 ]))
end

# Format
function convert_to_uint8!(df::DataFrame, col::Symbol)
	df[!, col] = convert(Vector{Union{Missing, UInt8}}, df[!, col])
	return df
end

function parse_year_column!(df::DataFrame, col::Symbol) # encoder avec UInt8 est possible mais moins lisible.
	df[!, col] = map(x -> 
									 length(String(x)) == 1 ? missing : UInt16(parse(Int, first(String(x), 4))),
									df[!, col]
									)
	return df
end

function isoweek_to_date!(df::DataFrame, col::Symbol) # encodage alternatif possible: YYYYWW (32bit), YYWW (16bit) ou encodage perso UInt8.
	df[!, col] = map(x -> 
									 ismissing(x) ? missing : begin
										 year, week = parse.(Int, split(x, "-"))
										 Date(year, 1, 1) + Week(week - 1)  # premier jour de la semaine -- UInt32
									 end,
									df[!, col])
	return df
end

# Vérifie si un DataFrame doit être conservé
function is_valid_df(df::DataFrame)
    first_row = df[1, :]
    !ismissing(first_row._5_years_cat_of_birth) &&
    1920 <= first_row._5_years_cat_of_birth < 2020 &&
    !ismissing(first_row.sex)
end

# Modifie le DataFrame en place
function modify_df!(df::DataFrame)
    cutoff = Date("2020-12-27")
    filter!(row -> (ismissing(row.infection_rank) || row.infection_rank == 1) &&
                  (ismissing(row.week_of_death) || row.week_of_death >= cutoff),
            df)
    select!(df, Not(:infection_rank))
end

@info "Loading completed"
