@abstract
class_name Enemy
extends CharacterBody2D

# This can be used to play an effect or sound or smth
signal enemy_felled(enemy_id) 
static var line_count: int = 5

var id: int = IdGenerator.get_id()
var line: int = randi() % line_count # [0, line_count - 1]
var speed: float 
var max_speed: float = 1000.0
var health_points: int = 3

func _ready() -> void:
	print_debug("Enemy with id %d ready on line %d" % [id, line])
	pass

func _process(delta: float) -> void:
	@warning_ignore("standalone_expression")
	delta
	if self.health_points <= 0: 
		enemy_felled.emit(self.id)
	
	pass

func _physics_process(delta: float) -> void:
	self.velocity.x += -self.speed * delta
	if abs(self.velocity.x) >= self.max_speed:
		self.velocity.x = sign(self.velocity.x) * self.max_speed
	move_and_slide()
	
	# For testing purposes - remove if off-screen
	if self.position.x <= -20000.0:
		queue_free()

func _init(starting_line:int = 0, starting_speed:float = 600.0, starting_health:int = 3) -> void:
	self.line = starting_line
	self.speed = starting_speed
	self.health_points = starting_health

func _exit_tree() -> void:
	print_debug("Enemy with id %d removed from tree" % self.id)
	IdGenerator.remove_id(self.id)
