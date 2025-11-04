extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -400.0

#@export var attacking = false
var attack_type: String
var current_attack: bool
@onready var deal_damage_zone = $AttackArea

@export var bullet_node: PackedScene

# Gets the value of gravity from project settings to be synced with Rigidbody2D nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#var is_stunned: bool = false

# Runs every frame.
func _ready() -> void:
	Global.playerBody = self
	current_attack = false
	Global.player_stunned = false
	#is_stunned = false

# Runs every frame.
func _physics_process(delta: float) -> void:
	
	Global.playerDamageZone = deal_damage_zone
	
	if not is_on_floor():
		velocity.y += gravity * delta # originally get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction:= Input.get_axis("Left", "Right")
	if direction: # Added !attacking to this statement.
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) #
		
	if !current_attack: # can add a weapon_equip line too for different weapons.
		if Input.is_action_just_pressed("Punch") and is_on_floor():
			current_attack = true # Stops function from looping.
			attack_type = "Single"
			print("punch!");
			
			set_damage(attack_type)
			handle_attack_animation(attack_type)
	# Function flips sprite based off the direction the player is facing.
	flip_sprite(direction)
	
	if Global.player_stunned == false: # Runs if the player is not stunned/hit by the Warden's lockup, essentially locks the player in place.
		# Built in function that takes the velocity and applies it. It moves the object and checks for collisions.
		# If it does collide, it slides or stops motion based upon that.
		#print(Global.player_stunned)
		move_and_slide()
		handle_movement_animation(direction)

# Function handles attack animation based off the type of attack the player is using.
# for now the only attack is Single_Attack (our Punch).
func handle_attack_animation(attack_type):
	if current_attack:
		var animation = str(attack_type, "_Attack") # 
		#print(animation)
		$AnimatedSprite2D.play(animation)
		toggle_damage_collisions(attack_type)

# Toggles AttackArea collision box on only when the player hits their attack, the collision then turns off until
# the attack button is pressed again.
func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	
	if attack_type == "Single":
		wait_time = 0.36 # 9 divided by 18 because the animation is 9 frames at 18fps.
	
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout # creates a timer.
	damage_zone_collision.disabled = true

# Function handles the player's movement animation.
# For now, it only handles the player's idle animation.
func handle_movement_animation(direction):
	if is_on_floor() and !current_attack: # If player is on the ground and not currently attacking
		if !velocity: # If the player is not moving
			$AnimatedSprite2D.play("Idle")
		elif velocity: # If the player is moving.
			$AnimatedSprite2D.play("Walk")
	elif !is_on_floor() and !current_attack: # Plays if the character is in the air AND not attacking.
		$AnimatedSprite2D.play("Jump")

# Function Handles flipping the player sprite based off the direction the player is facing.
func flip_sprite(direction):
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
		deal_damage_zone.scale.x = 1 # Keeps player's AttackArea where it is positioned in the scene.
		#$AnimatedSprite2D.play("Idle")
		#print("Walking Right")
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
		deal_damage_zone.scale.x = -1 # Flips player's AtackArea.
		#$AnimatedSprite2D.play("Idle")
		#print("Walking Left")

# Signal emits when the player attack animation has finished.
func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false
	#print("attack = false")

# Function handles the amount of damage the player inflicts based off their attack type.
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "Single":
		current_damage_to_deal = 8
	
	Global.playerDamageAmount = current_damage_to_deal

func player():
	pass

func shoot(): # Spawns bullet.
	var bullet = bullet_node.instantiate()
	
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position). normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		shoot()
