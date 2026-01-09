class_name LevelSelectionItem

extends Button

func _on_pressed() -> void:
	LevelDataManager.current_level_name = "res://assets/levelData/level" + text + ".json"
	print("Level selected: ", LevelDataManager.current_level_name)
	SceneSwitcher.switchScene("res://levels/basic_level/basic_level.tscn")
