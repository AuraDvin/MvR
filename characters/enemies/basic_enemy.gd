class_name BasicEnemy
extends Enemy

var stopped: bool = false


func _physics_process(delta: float) -> void:
	self.velocity.x += -self.speed
	if abs(self.velocity.x) >= self.max_speed:
		self.velocity.x = sign(self.velocity.x) * self.max_speed
	var neki := move_and_collide(self.velocity * delta)
	if neki:
		print_debug("Basic enemy colllided with something: ", neki.get_collider())
		stopped = true
		self.velocity = Vector2.ZERO


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	stopped = true
	print_debug("Something is in attack area ", body)


func _process(_delta: float) -> void:
	if stopped:
		print_debug("Enemy stopped for some reason!")
	else:
		print_debug("Enemy is not stopping")


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	stopped = false
	print_debug("The body", body, " has left the attack area for some reason")
