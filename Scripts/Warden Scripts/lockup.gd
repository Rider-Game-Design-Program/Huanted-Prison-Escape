extends State

@onready var pivot = $"../../Pivot"
var can_transition: bool = false # Flag Variable.

# Assigns the Warden's AnimatedSprite2d in the inspector.
@export var animated_sprite_2d: AnimatedSprite2D 

var lockup_active: bool = false
var stun: bool = false
var timer: Timer # Creates timer variable

# On enter, play Lockup animation.
func enter(): 
	
	# Runs the code in the enter function in the state.gd script alongside with the code written here.
	super.enter()
	lockup() # Calls lockup() function
	await animated_sprite_2d.animation_finished # Waits for "Lockup" animation to finish playing.
	
	can_transition = true # Sets can_transition equal to true after animation finishes playing.

# Aims at the player.
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()

# Creates Lockup behavior (stuns player for 3 seconds, then lets them move again).
func lockup():
	timer = $Timer # Assigns the variable timer to the timer node in the Lockup node in the scene tab.
	
	print("Lockup function triggered")
	lockup_active = true
	
	if lockup_active == true:
		Global.player_stunned = true
		animated_sprite_2d.play("Lockup")
		
		timer.start(3) # Sets timer to 3 seconds, can probably replace this with button mashing code.
		print("Timer: ", timer)
		await timer.timeout # Waits for timer to finish running.
		
		Global.player_stunned = false
		lockup_active = false
		print("Locked")

	else:
		Global.player_stunned = false
		print("Not Stunned")

# Allows the Warden to transition to the Dash state.
func transition():
	if can_transition: # If can_transition is true.
		print("Lockup Played!")
		can_transition = false
		get_parent().change_state("Dash")
