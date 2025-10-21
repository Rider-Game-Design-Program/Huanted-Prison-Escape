extends Node2D

var door_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if door_entered == true and Input.is_action_just_pressed("Level_Switch"):
		get_tree().change_scene_to_file("res://godot_scenes/level01.tscn")
		print("Level Switched!")

func _input(event: InputEvent) -> void:
	pass
	

func _on_door_body_entered(body: Node2D) -> void:
	door_entered = true
	#if body == $Player and Input.is_action_just_pressed("Level_Switch"): # X Key
		#get_tree().change_scene_to_file("res://dialogue/level02.tscn")
		#print("Level Switched!")
