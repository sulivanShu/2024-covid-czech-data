# Variables
unvaccinated = Date("10000-01-01")
still_alive = Date("10000-01-01")
available = Date("-10000-01-01")
unavailable = Date("10000-01-01")
first_monday = Date("2020-12-21")
last_monday = Date("2024-06-24")
subgroup_id = 11920
mondays = collect(first_monday:Week(1):last_monday)
entries = first(mondays, length(mondays)-53)
these_mondays = vcat(entries[1:8], entries[53:131])
subgroup = deepcopy(dfs[subgroup_id]) # créée une vraie copie, pour les tests
weekly_entries = Dict(entry => DataFrame(vaccinated=Bool[],
																				 entry=Date[],
																				 exit=Date[],
																				 death=Date[])
											for entry in entries)
when_what_where_dict = Dict{Date, Dict{Date, Vector{Int}}}()
Random.seed!(0)
# Instructions
for this_monday in mondays
	if this_monday in these_mondays
		weekly_entry = weekly_entries[this_monday]
		# Pour les vaccinés
		vaccinated_count = process_vaccinated!(
																					 subgroup,
																					 weekly_entry,
																					 this_monday)
		# Pour les premiers non-vaccinés
		process_first_unvaccinated!(subgroup,
																weekly_entry,
																this_monday,
																vaccinated_count,
																when_what_where_dict)
		# Sont-ils vraiment gardés 53 semaines, ou 52 seulement?
	end
	# Pour les non-vaccinés de remplacement
	replace_unvaccinated!(this_monday,
												subgroup,
												weekly_entries,
												when_what_where_dict)
	# Sont-ils vraiment gardés 53 semaines, ou 52 seulement?
end
