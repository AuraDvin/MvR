class_name LevelSelect

extends Control

# todo:
@export var main_menu_path = "res://levels/menus/main_menu/main_menu.tscn"
@export var settings_path = ""

# Back arrow: 
# https://www.flaticon.com/free-icon/arrow_507257?term=return&page=1&position=59&origin=search&related_id=507257
# Settings icon same as the other menu

func _on_return_btn_pressed() -> void:
	get_tree().change_scene_to_packed(load(main_menu_path))

# todo: return to this page instead of main menu 
func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_packed(load(settings_path))
