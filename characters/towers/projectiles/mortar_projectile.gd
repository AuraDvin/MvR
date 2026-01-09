extends Node2D

var targetEnemy :Node2D
var damage: int = 3

@export var initial_y_velocity: float = 25
var speed: float = INF
var velocity = Vector2.ONE
var localTimer = Timer.new()

var initial_y
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.y = -initial_y_velocity
	localTimer.wait_time = 0.3
	localTimer.autostart = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if targetEnemy == null:
		return
	if speed == INF:
		initial_y = position.y
		speed = targetEnemy.position.x - position.x 
	velocity.x = speed * delta
	velocity.y += delta * 50
	position += velocity
	if localTimer.is_stopped() and abs(position.y - initial_y) < 10:
		for i in $Area2D.get_overlapping_areas():
			if i.is_in_group("enemy_body"):
				i.get_parent()._cause_damage(2)
		queue_free()
	
