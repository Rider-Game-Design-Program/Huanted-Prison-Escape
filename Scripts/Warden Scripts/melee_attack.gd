extends State
@export var animated_sprite_2d: AnimatedSprite2D

func enter(): # On entering, play the Warden's Melee Attack animation.
	super.enter()
	animated_sprite_2d.play("Melee_Attack")

func transition(): # Transitions back to Follow if the distance is greater than 30.
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
