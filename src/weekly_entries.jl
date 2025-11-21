# Variables
## Simple variables
unvaccinated = Date("10000-01-01")
still_alive = Date("10000-01-01")
available = Date("-10000-01-01")
unavailable = Date("10000-01-01")
first_monday = Date("2020-12-21")
last_monday = Date("2024-06-24")
mondays = collect(first_monday:Week(1):last_monday)
subgroup_id = 11920
## composed variables
entries = first(mondays, length(mondays)-53)
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
	# if this_monday <= last_monday - Week(53)
	if this_monday <= first_monday + Week(7) # TODO Changer pour le dernier lundi pertinent + éventuels lundis un an après le début de la campagne, si assez de non-vaccinés. pour 11920, 7 max.
		# TODO convertir certains @info en @debug
		weekly_entry = weekly_entries[this_monday]
		@info "$this_monday: Création d'une weekly_entry:"
		@info "$this_monday: pour les vaccinés:"
		my_weekly_entry = weekly_entries[Date("2020-12-28")]
		@info "$this_monday: avant: weekly_entry_2020-12-28 = $my_weekly_entry"
		# Pour les vaccinés
		vaccinated_count = process_vaccinated!(
																					 subgroup,
																					 weekly_entry,
																					 this_monday)
		if this_monday == Date("2021-09-13") || this_monday == Date("2021-03-08")
			@info "$this_monday: après: weekly_entry_2020-12-28 = $my_weekly_entry"
		end
		# Pour les premiers non-vaccinés
		@info "$this_monday: pour les premiers non-vaccinés:"
		process_first_unvaccinated!(subgroup,
																weekly_entry,
																this_monday,
																vaccinated_count,
																when_what_where_dict)
		if this_monday == Date("2021-09-13") || this_monday == Date("2021-03-08")
			@info "$this_monday: après: weekly_entry_2020-12-28 = $my_weekly_entry"
		end
	end
	my_weekly_entry = weekly_entries[Date("2020-12-28")]
	if this_monday == Date("2021-09-13") || this_monday == Date("2021-03-08")
		@info "$this_monday: pour les non-vaccinés de remplacement:"
	end
	# Pour les non-vaccinés de remplacement
	replace_unvaccinated!(this_monday,
												subgroup,
												weekly_entries,
												when_what_where_dict)
	if this_monday == Date("2021-09-13") || this_monday == Date("2021-03-08")
		@info "$this_monday: après: weekly_entry_2020-12-28 = $my_weekly_entry"
	end
	# ————————————————————————————————————————————————
	# envisager de supprimer les lignes inutiles dans subgroup. Il y a un subgroup qui contient des individus et un subgroup qui contient des individus*durée.
end

sort(weekly_entries)
weekly_entries[Date("2021-01-11")]
