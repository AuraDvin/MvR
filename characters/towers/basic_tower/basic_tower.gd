extends Tower
class_name BasicTower

func _init():
	self.price = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# strelja
func _on_timer_timeout():
	#print("attacking")
	attack_timer.start()
