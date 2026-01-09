extends Tower
class_name Mortar


func _init():
	price = 30
	return_price = 10
	needs_check = false
	ability_delay = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# strelja
func ability() -> void:
	#print("attacking")
	pass
