class_name LevelSelect

extends Control

@export var settings_res_path = "res://levels/menus/settings/settings.tscn"

# Back arrow: 
# https://www.flaticon.com/free-icon/arrow_507257?term=return&page=1&position=59&origin=search&related_id=507257
# Settings icon same as the other menu

func _on_return_btn_pressed() -> void:
	SceneSwitcher.returnToPrevScene()

# todo: return to this page instead of main menu 
func _on_settings_btn_pressed() -> void:
	SceneSwitcher.switchScene(settings_res_path)
