extends Control

const IP_ADDRESS = "127.0.0.1"
const PORT = 13458
const MAX_CLIENTS = 16

func _ready():
	multiplayer.peer_connected.connect(_player_connected)


func _player_connected(id):						# When the connection has successfully been made, load the Game scene and hide the lobby
	Global.player2id = id
	var game = preload("res://Game.tscn").instantiate()
	get_tree().get_root().add_child(game)
	hide()


func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	Global.which_player = 1						# The hosting instance will control player 1 
	$Label.text = "Hosting"
	$Host.hide()
	$Join.hide()


func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	Global.which_player = 2						# Control player 2
	$Label.text = "Joining"
	$Host.hide()
	$Join.hide()
