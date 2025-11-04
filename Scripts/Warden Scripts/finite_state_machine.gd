extends Node2D

var current_state: State
var previous_state: State

func _ready() -> void:
	current_state = get_child(0) as State # starts with the first/idle state on ready.
	previous_state = current_state
	current_state.enter()

func change_state(state): # function to change states.
	current_state = find_child(state) as State
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
