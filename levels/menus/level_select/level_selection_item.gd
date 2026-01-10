class_name LevelSelectionItem

extends Button

@onready var confetti = $Confetti

func _on_pressed() -> void:
	if text == "The end":
		# spawn particles
		for c in confetti.get_children():
			c.emitting  = true
		return
	LevelDataManager.current_level_name = "res://assets/levelData/level" + text + ".json"
	print("Level selected: ", LevelDataManager.current_level_name)
	SceneSwitcher.switchScene("res://levels/basic_level/basic_level.tscn")
