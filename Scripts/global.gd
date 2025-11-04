extends Node

var playerBody: CharacterBody2D

var player_stunned: bool

# So enemy can find player zone.
var playerDamageZone: Area2D

var playerDamageAmount: int

var warden_timer: Timer
