@abstract
class_name Enemy
extends Node2D

# This can be used to play an effect or sound or smth
static var line_count: int = 5

# line nastavljaš v spawnerju
var line: int #= randi() % line_count # [0, line_count - 1]
var velocity: Vector2
var movable: bool = true
var towers_in_range = {}
var og_speed
# Override for each enemy type, so bigger/stronger enemies progress the level more
var score: int = 1

signal defeated
signal survived

@export var speed: float
@export var max_speed: float = 10.0
@export var health_points: int = 3


@onready var body_area: Area2D = $BodyArea2D
@onready var attack_area: Area2D = $AttackArea2D
@onready var attack_timer: Timer = $AttackTimer
@onready var enemy_hit: AudioStreamPlayer2D = $Enemy_hit
@onready var tracks: AudioStreamPlayer2D = $Tracks
@onready var attack_sfx: AudioStreamPlayer2D = $Attack
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sprite_2d = $Sprite2D
@onready var slow_timer: Timer = $SlowTimer
# @onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	print_debug("Enemy with id %s ready on line %d" % [name, line])
	body_area.area_entered.connect(on_body_area_entered)
	attack_area.area_exited.connect(on_attack_area_exited)
	attack_area.area_entered.connect(on_attack_area_entered)
	slow_timer.timeout.connect(stop_slow)
	og_speed = speed

func _process(_delta: float) -> void:
	if towers_in_range.keys().is_empty(): 
		attack_timer.stop()
		movable = true
	else: 
		movable = false
		if attack_timer.is_stopped(): 
			attack()
			attack_timer.start()

func attack(): 
	pass

func _physics_process(delta: float) -> void:
	if not movable: 
		return
	
	if not tracks.playing:
		tracks.play()
	
	var veloc = Vector2(-speed, 0) * delta
	position += veloc
	
	# For testing purposes - remove if off-screen
	if position.x <= 0.0:
		emit_signal("survived")
		await get_tree().create_timer(0.2).timeout
		queue_free()


func _init(starting_line: int = 0, starting_speed: float = 600.0, starting_health: int = 3) -> void:
	line = starting_line
	speed = starting_speed
	health_points = starting_health


func _exit_tree() -> void:
	print_debug("Enemy with name %s removed from tree" % name)
	emit_signal("defeated",score)


func ability():
	pass


func on_body_area_entered(area:Area2D) -> void:
	if area.is_in_group("bullet"):
		_cause_damage(area.get_parent().damage)
		area.get_parent().queue_free()
		if area.get_parent().slow:
			slow_timer.start(3)
			sprite_2d.self_modulate = Color.LIGHT_BLUE
			speed = og_speed * 0.1

func on_attack_area_entered(area:Area2D) -> void: 
	if area.is_in_group("tower"):
		towers_in_range[area] = null

func on_attack_area_exited(area:Area2D) -> void: 
	if area.is_in_group("tower"):
		towers_in_range.erase(area)

func _cause_damage(amount: int):
	enemy_hit.play()
	health_points -= amount
	if health_points <= 0: 
		queue_free()
	

func stop_slow():
	sprite_2d.self_modulate = Color.WHITE
	speed = og_speed
