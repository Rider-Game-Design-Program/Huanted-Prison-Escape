extends Node

@export var node_finite_state_machine: NodeFiniteStateMachine 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # If the body that entered the attack area is assigned to the "Player" Group
		node_finite_state_machine.transition_to("Attack")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): # If the body that entered the attack area is assigned to the "Player" Group
		node_finite_state_machine.transition_to("Idle")
