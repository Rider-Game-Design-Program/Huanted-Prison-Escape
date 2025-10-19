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

# Runs every frame.
func on_process(delta: float):
	pass

# Runs every frame.
func on_physics_process(delta: float):
	var direction : int
	
	if health > 0:
		
		if character_body_2d.global_position > player.global_position:
			animated_sprite_2d.flip_h = false
			direction = -1
			#print("Attack State FLip")
		elif character_body_2d.global_position < player.global_position:
			animated_sprite_2d.flip_h = true
			direction = 1
	
		animated_sprite_2d.play("Attack")
	
		character_body_2d.velocity.x += direction * speed * delta
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_speed, max_speed)
		character_body_2d.move_and_slide()
		
		# if player takes damage, knockback enemy, turn value taking_damage back to false.
		if taking_damage == true:
			var knockback_direction = character_body_2d.position.direction_to(player.position) * -50
			character_body_2d.velocity = knockback_direction
			print("Knockback!")
			taking_damage = false
	
	if dead == true:
		print("Warden is dead!")

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
	print("player in enemy area")
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)
