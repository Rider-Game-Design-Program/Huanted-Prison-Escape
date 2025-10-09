extends CharacterBody2D

const SPEED = 50
var dir: Vector2

var health = 50
var health_max = 50
var health_min = 0

var is_enemy_chase: bool
var is_roaming: bool
var dead = false
var taking_damage = false

var player: CharacterBody2D
#@onready var hitBox = $EnemyHitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_enemy_chase = true
	#print("Connected Hitbox:", hitBox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

# Function handles the enemy's movement.
func move(delta):
	player = Global.playerBody
	if !dead:
		is_roaming = true
		if !taking_damage and is_enemy_chase:
			#print("moving")
			velocity = position.direction_to(player.position) * SPEED
			dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_direction = position.direction_to(player.position) * -80
			velocity = knockback_direction
		else:
			velocity += dir * SPEED * delta
	elif dead:
		velocity.y += 10 * delta
		velocity.x = 0
	move_and_slide()
	handle_animation()

# Signal emits when the player's attackarea is visible AND enters the enemy's hitbox.
func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	#print(area.name)
	print("player in enemy area")
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)

# Function handles the enemies health based off the damage the player inflicts.
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is ", health)

# Function handles the enemy movement animation and flips the sprite.
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !dead and !taking_damage:
		if dir.x == -1:
			$AnimatedSprite2D.flip_h = true
		elif dir.x == 1:
			$AnimatedSprite2D.flip_h = false
	elif !dead and taking_damage:
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		print("enemy is dead")
