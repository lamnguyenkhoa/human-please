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