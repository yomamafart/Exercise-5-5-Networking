extends Control

func _ready():
	if Global.which_player != 0:
		$Player.text = "Player " + str(Global.which_player)
