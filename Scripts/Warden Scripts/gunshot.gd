extends State
@export var bullet_node: PackedScene # Export Node
var can_transition: bool = false # Variable Flag

@export var animated_sprite_2d: AnimatedSprite2D

func enter(): # Upon entering, play Gun_Attack animation, wait for animation to end, then shoot.
	super.enter()
	animated_sprite_2d.play("Gun_Attack")
	await animated_sprite_2d.animation_finished
	shoot()
	can_transition = true

# Function to spawn the bullet.
func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = owner.position
	get_tree().current_scene.add_child(bullet)

func transition(): # Transition to Dash State.
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
