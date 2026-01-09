extends Tower
class_name BasicTower

const TURRET_PROJECTILE = preload("uid://ookojfhe8b4l")

func _init():
	self.price = 10
	needs_check = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	attack_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# strelja
func ability() -> void:
	var projectile_inst = TURRET_PROJECTILE.instantiate()
	projectile_inst.position = global_position + Vector2(45,-20)
	$"../../Projectiles".add_child(projectile_inst)
	
