extends Node

# Currently Unused script, keeping it incase we decide to add gravity back to this enemy or any other.
# if want to add gravity back, create a plain node called Gravity and attach it to the enemy 
# character body 2D node.
@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

const GRAVITY: int = 1000

func _physics_process(delta: float) -> void:
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.y += GRAVITY * delta
	
	character_body_2d.move_and_slide()
