extends Node

func get_dialog_data() -> DialogResource:
	return GameManager.current_subject.dialog

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

func get_all_children(node):
	var children = []
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		children.append(child)
		children += get_all_children(child) # Recursively call function for each child
	return children

func generate_random_number(digit_count: int=1, exclude_number: int=0) -> int:
	var random_number = 0
	# Calculate the range for random number generation
	var min_number = pow(10, digit_count - 1)
	var max_number = pow(10, digit_count) - 1
	random_number = randi_range(min_number, max_number)
	while random_number == exclude_number:
		random_number = randi_range(min_number, max_number)
	return random_number

func get_number_part(input_string: String) -> int:
	var number_part = ""
	var found_digit = false
	
	# Iterate through each character in the input string
	for num in input_string:
		# Check if the character is a digit
		if num.is_valid_int():
			# If a digit is found, set the flag to true
			found_digit = true
			# Append the digit to the number part
			number_part += num
		elif found_digit:
			# If a digit has already been found and the current character is not a digit, break the loop
			break
	
	# Convert the number part to an integer and return
	return int(number_part)
