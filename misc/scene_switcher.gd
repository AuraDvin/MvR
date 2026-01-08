extends Node

var scene_history = [] 
var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	scene_history.append(current_scene)
#	print_debug(current_scene)

func switchScene(res_path: String) -> void: 
	call_deferred("defferedSwitchScene", res_path)

func defferedSwitchScene(res_path: String) -> void:
	current_scene.free() 
	var s = load(res_path)
	current_scene = s.instantiate()
	scene_history.append(res_path) 
	get_tree().root.add_child(current_scene)

func returnToPrevScene() -> void: 
	scene_history.pop_back() # current scene
	var s = scene_history.pop_back() # last scene
	# Fallback to main_menu scene
	if s == null: 
		s = "res://levels/menus/main_menu/main_menu.tscn"
	switchScene(s)
