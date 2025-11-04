extends CharacterBody2D

# NOTE: Warden Boss is on layer 4, with no mask.
# The Warden's Play Detection node is on layer 3 and detects nodes on layer 2 (Mask 2).


# Gets the player and sprite nodes.
@onready var player = get_parent().find_child("Player")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar

var direction: Vector2 # Update progress bar using setter variable.

var defense = 0

var health = 100:
	set(value):
		health = value
		progress_bar.value = value
		
		if value <= 0: # If health is less than 0, switch to Death state.
			progress_bar.visible = false
			find_child("Finite State Machine").change_state("Death")
		# If health is less than 50%, switch to ArmorBuff state.
		elif value <= progress_bar.max_value / 2 and defense  == 0: 
			defense = 5
			find_child("Finite State Machine").change_state("ArmorBuff")
		

func _ready() -> void: # Turns off physics process for the Warden Boss right away.
	set_physics_process(false)

func _process(delta: float) -> void:
	direction = player.position - position # Updates direction based on the player's position.
	
	if direction.x < 0:
		animated_sprite_2d.flip_h = true # Flips direction towards the player.
	
	else:
		animated_sprite_2d.flip_h = false

func _physics_process(delta: float) -> void: # Sets motion in physics_process
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func take_damage(): # Function that decreases health.
	health -= 10 - defense
