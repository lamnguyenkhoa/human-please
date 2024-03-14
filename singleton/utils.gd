extends Node

func get_dialog_data() -> DialogResource:
	for elem in GameManager.current_subject.dialogs:
		if elem.day == GameManager.work_day.day:
			return elem
		else:
			print("DIALOG_AREA: ERROR CANT FIND DIALOG OF DAY ", GameManager.work_day.day)
	return null

func compare_dates(date1_str: String, date2_str: String) -> int:
	# Extract day, month, and year from date strings
	var date1_parts = date1_str.split("/")
	var date2_parts = date2_str.split("/")

	var day1 = int(date1_parts[0])
	var month1 = int(date1_parts[1])
	var year1 = int(date1_parts[2])
	
	var day2 = int(date2_parts[0])
	var month2 = int(date2_parts[1])
	var year2 = int(date2_parts[2])

	# Compare years
	if year1 > year2:
		return 1
	elif year1 < year2:
		return - 1
	
	# If years are equal, compare months
	if month1 > month2:
		return 1
	elif month1 < month2:
		return - 1

	# If months are equal, compare days
	if day1 > day2:
		return 1
	elif day1 < day2:
		return - 1

	# Dates are equal
	return 0