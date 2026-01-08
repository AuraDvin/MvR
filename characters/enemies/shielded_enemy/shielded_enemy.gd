class_name ShieldedEnemy
extends Enemy

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D_shield

# Number of frames in the shield animation
const SHIELD_STAGES: int = 4  # Full, minor cracks, major cracks, gone

# Current shield HP (starts full)
var shield_hp: int

# Track shield + enemy health combined
var last_total_hp: int


func _ready() -> void:
	super()

	# Initialize shield HP to match number of stages
	shield_hp = SHIELD_STAGES

	# Last total HP = enemy health + shield HP
	last_total_hp = health_points + shield_hp

	# Initialize animation
	anim.stop()
	anim.animation = "shield"
	anim.frame = 0


func _process(delta: float) -> void:
	super(delta)

	# Total HP = shield + enemy health
	var total_hp: int = health_points + shield_hp

	# Detect damage (any HP lost)
	if total_hp < last_total_hp:
		var lost: int = last_total_hp - total_hp
		last_total_hp = total_hp
		apply_damage(lost)


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
			queue_free()


func advance_frame(frames: int = 1) -> void:
	if anim.sprite_frames == null:
		return

	var frame_count: int = anim.sprite_frames.get_frame_count(anim.animation)
	if frame_count <= 0:
		return

	# Advance animation by the number of frames lost
	anim.frame = min(anim.frame + frames, frame_count - 1)
