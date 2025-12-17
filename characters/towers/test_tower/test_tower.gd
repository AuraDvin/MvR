extends Node2D

@export var reload_timer = 0.5
var local_timer = 0
var bullet_scene = preload("res://characters/towers/test_tower/test_bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	local_timer += delta
	if local_timer > reload_timer:
		local_timer -= reload_timer
		$BulletSpawnPosition.add_child(bullet_scene.instantiate())
