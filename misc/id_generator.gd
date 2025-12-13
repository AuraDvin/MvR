class_name IdGenerator

static var _ids : Dictionary

static func get_id() -> int:
	var return_val = randi()
	while _ids.find_key(return_val):
		return_val = randi()
	_ids[return_val] = null
	return return_val

static func remove_id(id):
	_ids.erase(id)
