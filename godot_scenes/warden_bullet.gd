extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_parent().find_child("Player")

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	acceleration = (player.position - position).normalized() * 700 # Lets bullet steer towards the player.
	
	velocity += acceleration * delta
	rotation = velocity.angle() # Rotates bullet so it points at the player.
	
	velocity = velocity.limit_length(150)
	
	position += velocity * delta # Updates position with the velocity.

func _on_body_entered(body: Node2D) -> void:
	queue_free() # Upon contact with the player, delete the bullet.
