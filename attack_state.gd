extends NodeState  # Extends from node_state script since we established that as that script's class name.

var player: CharacterBody2D

# @export variables can be changed/assigned in the inspector.
@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int
@export var max_speed: int

# Enemy Health Variables.
@export var health = 24
@export var health_max = 50
@export var health_min = 0

# Temp Enemy Variables
var is_enemy_chase: bool
var is_roaming: bool
var dead = false
var taking_damage = false
var dir: Vector2

func _ready() -> void:
	is_enemy_chase = false
	is_roaming = true
	print("Dialogue in ready:", $Dialogue)
	

# Runs every frame
func _process(delta: float) -> void:
	pass

# Runs every frame.
func _physics_process(delta: float): # o.g. on_physics_process
	
	move(delta)
	handle_animation()

func move(delta):
	# Print statements to see enemy coords and velocity/speed.
	#print("Dir: ", dir)
	#print("Velocity: ", character_body_2d.velocity)
	
	if !dead:
		if !taking_damage and is_enemy_chase:
			player = Global.playerBody
			#print("moving")
			# Sets the velocity of the warden enemy to the direction the player character is in and
			# applies velocity to that direction.
			character_body_2d.velocity = character_body_2d.position.direction_to(player.position) * speed
			dir.x = abs(character_body_2d.velocity.x) / character_body_2d.velocity.x
		elif taking_damage:
			var knockback_direction = character_body_2d.position.direction_to(player.position) * -80
			character_body_2d.velocity = knockback_direction
		elif is_roaming == true and is_enemy_chase == false:
			character_body_2d.velocity += dir * 200 * delta
			#print(character_body_2d.position)
	elif dead:
		character_body_2d.velocity.y += 10 * delta
		character_body_2d.velocity.x = 0
	
	#print("Velocity ", character_body_2d.velocity)
	character_body_2d.move_and_slide()
	handle_animation()

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !dead and !taking_damage:
		animated_sprite_2d.play("Attack")
		if dir.x == -1:
			animated_sprite_2d.flip_h = true
		elif dir.x == 1:
			animated_sprite_2d.flip_h = false
	elif !dead and taking_damage:
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead:
		is_roaming = false
		print("Warden is dead")

# If a CharacterBody2D node enters the enemy's attack area.
func enter():
	# Since it's a collection and there will only ever be 1 object in this group, call index 0.
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	max_speed = speed + 20

func exit():
	pass

# Handles if the enemy takes damage from the player.
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is ", health)

# If an attack area enters the enemy's attack area.
func _on_enemy_hit_box_area_entered(area: Area2D) -> void:
	
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)
	print(is_roaming)

func _on_enemy_hit_box_area_exited(area: Area2D) -> void:
	pass

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 1.5, 2.0]) # adds these options to an array.
	if !is_enemy_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)

func choose(array):
	array.shuffle() # shuffles array.
	return array.front() # sends back a different wait time.

func _on_enemy_hit_box_body_entered(body: Node2D) -> void:
	is_roaming = false
	is_enemy_chase = true
	print(is_roaming, is_enemy_chase)

func _on_enemy_hit_box_body_exited(body: Node2D) -> void:
	is_roaming = true
	is_enemy_chase = false
	print(is_roaming, is_enemy_chase)
