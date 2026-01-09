class_name FastEnemy
extends Enemy

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func attack():
	if(towers_in_range.is_empty()):
		print_debug("Enemy attacking with no towers in range")
		return
	var target:Tower=towers_in_range.keys()[0].get_parent()
	print_debug("Enemy attacks",target)
	attack_sfx.play()
	target.receive_damage(1)
	
