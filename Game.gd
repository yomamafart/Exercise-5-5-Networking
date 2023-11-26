extends Node3D

@onready var controlled = load("res://Player/Player.gd")
@onready var passive = load("res://Player/Player_Passive.gd")

func _ready():
	var player1 = preload("res://Player/Player.tscn").instantiate()	# instance player 1
	player1.name = "Player1"
	player1.position = $Player1_Spawn.position
	player1.get_node("Mesh").mesh.material.albedo_color = Color8(34,139,230,255)
	player1.peer_id = multiplayer.get_unique_id()
	if Global.which_player == 1:
		player1.script = controlled
	else:
		player1.script = passive
	add_child(player1)
	
	var player2 = preload("res://Player/Player.tscn").instantiate()	# instance player 1
	player2.peer_id = multiplayer.get_unique_id()
	player2.name = "Player2"
	player2.position = $Player2_Spawn.position
	player2.get_node("Mesh").mesh.material.albedo_color = Color8(250,82,82,255)
	if Global.which_player == 2:
		player2.script = controlled
	else:
		player2.script = passive
	add_child(player2)
