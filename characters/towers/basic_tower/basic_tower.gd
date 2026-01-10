extends Tower
class_name BasicTower

const TURRET_PROJECTILE = preload("uid://ookojfhe8b4l")
@onready var tower_attack: AudioStreamPlayer2D = $Attack

func _init():
	max_health=4
	current_health=4
	self.price = 10
	needs_check = true
	ability_value = 1
	type = "basictower"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Upgrades.connect("special", set_special)
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_special():
	$Sprite2D.frame = 1

# strelja
func ability() -> void:
	var projectile_inst = TURRET_PROJECTILE.instantiate()
	tower_attack.play()
	projectile_inst.position = global_position + Vector2(45,-20)
	projectile_inst.damage = ability_value
	if special:
		projectile_inst.special()
	$"../../Projectiles".add_child(projectile_inst)
	
