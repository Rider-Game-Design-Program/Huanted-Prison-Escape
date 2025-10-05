extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -400.0

# Gets the value of gravity from project settings to be synced with Rigidbody2D nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Runs every frame.
func _physics_process(delta: float) -> void:
	# Add the gravity. Makes player fall.
	if not is_on_floor():
		velocity.y += gravity * delta # originally get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction:= Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		#print_debug(direction);
		
		if direction == -1: # if player is facing left...
			$AnimatedSprite2D.flip_h = true;
			#print_debug("Flipped!");
		else:
			$AnimatedSprite2D.flip_h = false;
	else: # if direction is 0, move towards velocity.
		velocity.x = move_toward(velocity.x, 0, SPEED / 2) # /2 adds slight drag to the player.
		$AnimatedSprite2D.play("Idle");

# Built in function that takes the velocity and applies it. It moves the object and checks for collisions.
# If it does collide, it slides or stops motion based upon that.
	move_and_slide()
