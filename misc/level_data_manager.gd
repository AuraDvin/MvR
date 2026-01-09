extends Node

class LevelData: 
	var current_score: int			# From defeated enemies up until this point
	var max_score: int  			# After defeating all the enemies
	var enemy_queue = []			# Spawning information (swarms)
	var background_path: String		# Image to use as background 
	
	var energy: int					# Player's energy before pausing
	var enemies = [[], [], [], []]	# Placed enemies 
	var towers = []					# Placed towers
	var projectiles = []			# Projectiles on screen
	var pickups = []				# Pickups on screen

# Holds the data of level being currently played 
# This gets cleared on level exit
var current_level_data: LevelData = null
var current_level_name: String = "res://assets/levelData/level1.json"

func remove_existant_data() -> void: 
	current_level_data = null

func get_data(res_path: String) -> LevelData: 
	if current_level_data == null: 
		return loadLevel(res_path)
	return current_level_data 

func loadLevel(res_path: String) -> LevelData: 
	var json = JSON.new()
	var file = FileAccess.open(res_path, FileAccess.READ)
	if file.get_error() != OK: 
		print_debug("error opening file")
		return null
	
	var error = json.parse(file.get_as_text())
	
	if error != OK:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", res_path, " at line ", json.get_error_line())
		return null
	
	current_level_data = LevelData.new()
	var data_received = json.data
	var data_dict: Dictionary = type_convert(data_received, TYPE_DICTIONARY)
	
	if data_dict == null:
		push_error("Json data is not dictionary") 
		return null
	
	current_level_data.energy = data_dict["energy"]
	current_level_data.background_path = data_dict["background"]
	
	if typeof(data_dict["enemies"]) == TYPE_ARRAY:
		for enemies_arr in data_dict["enemies"]: 
			var swarm = 0
			for enemy_dict in enemies_arr:
				while current_level_data.enemy_queue.size() <= swarm: 
					current_level_data.enemy_queue.append([])
				current_level_data.enemy_queue[swarm].append(enemy_dict)
			swarm += 1
		return current_level_data
	else:
		push_error("Unexpected data")
		return null

func save_state(level: BasicLevel) -> void: 
	for i in range(1, 5): 
		current_level_data.enemies[i-1] = level.lanes.find_child(str(i)).get_children().duplicate()
	current_level_data.towers = level.grid_towers.duplicate()
	current_level_data.pickups = level.grid_pickups.duplicate()
	current_level_data.projectiles = level.grid_projectiles.duplicate()

func load_state(level: BasicLevel) -> bool:
	if current_level_data == null: 
		return false
	
	for i in range(1, 5): 
		level.lanes.find_child(str(i)).add_child(current_level_data.enemies[i-1])
	for t in current_level_data.towers:
		level.grid_towers.add_child(t)
	for p in current_level_data.pickups: 
		level.grid_pickups.add_child(p)
	for pr in current_level_data.projectiles:
		level.grid_projectiles.add_child(pr)
	return true
