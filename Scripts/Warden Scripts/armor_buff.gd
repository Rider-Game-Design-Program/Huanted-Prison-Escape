extends State

var can_transition = false # Flag Variable
@export var animated_sprite_2d: AnimatedSprite2D

func enter(): # Plays Armor_Buff animation.
	super.enter()
	animated_sprite_2d.play("Armor_Buff")
	await animated_sprite_2d.animation_finished
	can_transition = true

func transition(): # Transition to Follow.
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
