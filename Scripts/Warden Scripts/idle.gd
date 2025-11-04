extends State

@onready var collision_shape_2d = $"../../Player Detection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")

# declares player_entered flag variable and makes it a setter function.
var player_entered: bool = false:
	set(value):
		player_entered = value
		collision_shape_2d.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)

func transition():
	if player_entered: # if player enters the detection zone, transtion to follow state.
		get_parent().change_state("Follow")


func _on_player_detection_body_entered(body: Node2D) -> void:
	print("Entered:", body.name)
	player_entered = true # upon entering the zone, player_entered is set to true.
