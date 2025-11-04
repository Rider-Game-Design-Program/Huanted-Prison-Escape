extends State
@export var animated_sprite_2d: AnimatedSprite2D

func enter(): # Upon entering, set the owner's physics process to true and play the Idle animation.
	super.enter()
	owner.set_physics_process(true)
	animated_sprite_2d.play("Idle")

func exit(): # Upon exiting, set the owner's physics process to false.
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	
	if distance < 30: # Transitions if the distance to the player is less than 30.
		get_parent().change_state("MeleeAttack")
	elif distance > 130: # Changes to a random state between Gunshot and Lockup.
		var chance = randi() % 2
		
		match chance:
			0:
				get_parent().change_state("Gunshot")
			1:
				get_parent().change_state("LockUp")
		
