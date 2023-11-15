extends Node3D


func _ready():
	var player1 = preload("res://Player/Player.tscn").instantiate()	# instance player 1
	player1.name = "Player1"
	player1.position = $Player1_Spawn.position
	player1.get_node("Mesh").mesh.material.albedo_color = Color8(34,139,230,255)
	add_child(player1)
