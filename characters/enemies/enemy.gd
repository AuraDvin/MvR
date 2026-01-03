@abstract
class_name Enemy
extends Node2D

# This can be used to play an effect or sound or smth
static var line_count: int = 5

var line: int = randi() % line_count # [0, line_count - 1]
var velocity: Vector2
var movable: bool = true
var towers_in_range: Dictionary = {}

@export var speed: float
@export var max_speed: float = 1000.0
@export var health_points: int = 3

@onready var body_area: Area2D = $BodyArea2D
@onready var attack_area: Area2D = $AttackArea2D
@onready var attack_timer: Timer = $AttackTimer
# @onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	print_debug("Enemy with id %s ready on line %d" % [name, line])
	body_area.area_entered.connect(self.on_body_area_entered)
	body_area.area_exited.connect(self.on_attack_area_exited)
	attack_area.area_entered.connect(self.on_attack_area_entered)


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
	
	self.velocity.x += -self.speed * delta
	if abs(self.velocity.x) >= self.max_speed:
		self.velocity.x = sign(self.velocity.x) * self.max_speed
	
	self.position += self.velocity * delta
	
	# For testing purposes - remove if off-screen
	if self.position.x <= -20000.0:
		queue_free()


func _init(starting_line: int = 0, starting_speed: float = 600.0, starting_health: int = 3) -> void:
	self.line = starting_line
	self.speed = starting_speed
	self.health_points = starting_health


func _exit_tree() -> void:
	print_debug("Enemy with name %s removed from tree" % self.name)


func ability():
	pass


func on_body_area_entered(area:Area2D) -> void:
	if area.is_in_group("bullet"):
		self.health_points -= 1 
		if self.health_points <= 0: 
			self.queue_free()

func on_attack_area_entered(area:Area2D) -> void: 
	if area.is_in_group("tower"):
		towers_in_range[area] = null

func on_attack_area_exited(area:Area2D) -> void: 
	if area.is_in_group("tower"):
		towers_in_range.erase(area)
