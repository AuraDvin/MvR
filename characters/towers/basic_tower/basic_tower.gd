extends Tower
class_name BasicTower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ReloadTimer.start(attack_delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# strelja
func _on_timer_timeout():
	print("attacking")
	$ReloadTimer.start(attack_delay)
