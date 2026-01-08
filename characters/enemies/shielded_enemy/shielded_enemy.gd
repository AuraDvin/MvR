class_name ShieldedEnemy
extends Enemy

@onready var sprite = $ShieldSprite

# Number of frames in the shield animation
const SHIELD_STAGES: int = 4  # Full, minor cracks, major cracks, gone

# Current shield HP (starts full)
@export var shield_hp: int

# Track shield + enemy health combined
var last_total_hp: int


func _ready() -> void:
	print_debug("ready")
	super()

	# Initialize shield HP to match number of stages
	shield_hp = SHIELD_STAGES

	# Last total HP = enemy health + shield HP
	last_total_hp = health_points + shield_hp

	# Initialize animation
	sprite.frame = 0

func _process(delta: float) -> void:
	super(delta)

func apply_damage(amount: int) -> void:
	# Apply damage to shield first
	if shield_hp > 0:
		var damage_to_shield: int = min(amount, shield_hp)
		shield_hp -= damage_to_shield
		amount -= damage_to_shield
		advance_frame(damage_to_shield)

	# Any leftover damage goes to enemy
	if amount > 0:
		health_points -= amount
		if health_points <= 0:
			print_debug("queueueing freeing here", health_points)
			queue_free()


func advance_frame(frames: int = 1) -> void:
	var frame_count: int = sprite.hframes
	if frame_count <= 0:
		return

	# Advance animation by the number of frames lost
	sprite.frame = min(sprite.frame + frames, frame_count - 1)

func on_body_area_entered(area:Area2D) -> void:
	var before = health_points
	super(area)
	var diff = before - health_points
	if diff == 0: 
		return
	# Handle the shield vs real health
	apply_damage(diff)
