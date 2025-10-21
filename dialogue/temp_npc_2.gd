extends CharacterBody2D

const SPEED = 30
var current_state = IDLE

var direction = Vector2.RIGHT
var start_position

var is_roaming = true
var is_chatting = false
var in_chat_zone = false

var player
var player_in_chat_zone = false

enum {
	IDLE, 
	NEW_DIRECTION,
	MOVE
}

# Runs at start.
func _ready() -> void:
	randomize()
	start_position = position # position = position of NPC
	

# Runs every frame.
func _process(delta: float) -> void:
	if current_state == 0 or current_state == 1: # 0 = IDLE, 1= NEW_DIRECTION
		$AnimatedSprite2D.play("Idle")
	elif current_state == 2 and !is_chatting:
		if direction.x == -1:
			$AnimatedSprite2D.play("Left_Walk")
		if direction.x == 1:
			$AnimatedSprite2D.play("Right_Walk")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIRECTION:
				direction = choose([Vector2.RIGHT, Vector2.LEFT]) # Can add Vector2.UP and Vector2.DOWN if needed.
			MOVE:
				move(delta)
	#print(NEW_DIRECTION)
	if Input.is_action_just_pressed("Chat") and player_in_chat_zone == true: # Currently C key.
		print("Chatting With Npc.")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("Idle")

# Creates an array and shuffles it, return the first value after shuffling.
func choose(array):
	array.shuffle() # Mixes array around.
	return array.front() # Returns first value from the shuffle.

func move(delta):
	if !is_chatting:
		position += direction * SPEED * delta

func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true
		print("entered")

func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = false
		print("exited")

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1.0, 1.5])
	current_state = choose([IDLE, NEW_DIRECTION, MOVE])

func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false
	is_roaming = true
