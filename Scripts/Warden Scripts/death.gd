extends State

@export var animated_sprite_2d: AnimatedSprite2D

func enter(): # Plays the Warden's Death animation.
	super.enter()
	animated_sprite_2d.play("Death")
	await animated_sprite_2d.animation_finished
	animation_player.play("boss_slayed")
	print("Boss slayed!")
