class_name Cart
extends RefCounted

var data: Dictionary = {
	Constants.ITEMS.CIRCLE: 0,
	Constants.ITEMS.RECTANGLE: 0,
	Constants.ITEMS.TRIANGLE: 0,
}


func clear():
	for key in data.keys():
		data[key] = 0


func equals(other: Cart):
	for key in data:
		if key not in other.data.keys():
			return false
		if data[key] != other.data[key]:
			return false
	return true


func update(new_data: Dictionary):
	clear()
	for key in new_data:
		data[key] = new_data[key]


func add_item(key: Constants.ITEMS):
	if key in data:
		data[key] += 1


func remove_item(key: Constants.ITEMS):
	if key in data and data[key] > 0:
		data[key] -= 1


func set_item(key: Constants.ITEMS, value: int):
	if key in data and value >= 0:
		data[key] = value


func get_item(key: Constants.ITEMS) -> int:
	if key in data:
		return data[key]
	return -1
