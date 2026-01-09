extends Tower
class_name SolarPannel

const ENERGY_PICKUP = preload("uid://bxst250rs3x0w")
var rng: RandomNumberGenerator

@onready var energy_generate: AudioStreamPlayer2D = $Energy

func _init():
	price = 25
	return_price = 10
	needs_check = false
	ability_delay = 3
	ability_value = 10
<<<<<<< HEAD
=======
	type = "solarpannel"
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	attack_timer.start()
<<<<<<< HEAD
=======
	$Upgrades.connect("special", set_special)
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
	super()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(attack_timer.time_left)
	pass

func set_special():
	$Sprite2D.frame = 3

# strelja
func ability() -> void:
<<<<<<< HEAD
	#print("attacking")
	energy_generate.play()
=======
	if special:
		var energy = $"../../../Player".spend_energy(ability_value * (-1))
		$"../../../Hud"._on_basic_level_energy_changed(energy)
		return
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
	var pickup_inst = ENERGY_PICKUP.instantiate()
	var rand_offset = Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1)).normalized() 
	pickup_inst.position = global_position + (rand_offset * 50)
	pickup_inst.energy_amount = ability_value
	$"../../Pickups".add_child(pickup_inst)
