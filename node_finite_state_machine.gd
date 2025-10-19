class_name NodeFiniteStateMachine
extends Node

@export var initial_node_state: NodeState

var node_states: Dictionary = {}
var current_node_state: NodeState
var current_node_state_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is NodeState: # If childnode of type NodeState
			# Stores childnodes of type NodeState to the node_states dictionary. 
			# sets the node name in lowercase in the dictionary.
			node_states[child.name.to_lower()] = child
	
	if initial_node_state:
		initial_node_state.enter() # calls enter() function in Idle and Attack Scripts.
		current_node_state = initial_node_state 

	#print("Test" , current_node_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_process(delta) # calls the _process function from the idle_state script.
		
	#if taking_damage == true:
		
		#var knockback_direction = position.direction_to(player.position) * -80
		#velocity = knockback_direction
	#print(health)

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_physics_process(delta) # calls the _physics_process function from the idle_state script.
	
	#print("Current State: " , current_node_state.name.to_lower())

func transition_to(node_state_name : String):
	if node_state_name == current_node_state.name.to_lower():
		return
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return
	
	if current_node_state:
		current_node_state.exit()
	
	new_node_state.enter()
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name.to_lower()
