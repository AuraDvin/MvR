class_name MainMenu
extends Control


# todo:
@export var settings_path = null
@export var level_select_path = "res://levels/menus/level_select/level_select.tscn"

# Icons are currently from the following sources: 
# Settings:
# https://www.flaticon.com/free-icon/setting_2040504?term=settings&related_id=2040504

# Play:
# https://www.flaticon.com/free-icon/play-button-arrowhead_27223?term=play&page=1&position=1&origin=search&related_id=27223

# Quit:
# https://www.flaticon.com/free-icon/logout_1828479?term=exit&page=1&position=5&origin=search&related_id=1828479

func _on_quit_confirmation_confirmed() -> void:
	get_tree().quit(0)

func _on_quit_btn_pressed() -> void:
	$QuitConfirmation.visible = true

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_packed(load(level_select_path))
	
# todo: settings have to return you to the scene from which you came
func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_packed(settings_path)
