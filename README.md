# Exercise 5.5—Networking

Exercise for MSCH-C220

---

A demonstration of this exercise is available at [https://youtu.be/D08hrt1oWZ4](https://youtu.be/D08hrt1oWZ4)

---

This exercise is a chance to play with Godot's networking capability in a 3D context. We will be extending a simple first-person-controlled character and allow two of these characters to be controlled over the network (localhost).

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-5-5-Networking. Edit the LICENSE and replace BL-MSCH-C220 with your full name. Commit your changes.

Clone the repository to a Local Path on your computer.

Open Godot. Import the project.godot file and open the "Networked Game" project.

In res://Game.tscn, I have provided a starting place for the exercise: the scene contains a parent Node3D node (named Game), a WorldEnvironment, and a StaticBody Ground node (containing a MeshInstance Plane and a CollisionShape). There are two starting locations for the players and a light source. There is also a HUD control node (to show information about the player).

We are now going to make this into a two-player experience (not really a game, yet).

First create a new scene. Make it a User Interface scene (Control) and change the name of the resulting node to Lobby. Add two buttons, Host and Join. Center them on the page, and update their labels to "Host" and "Join" (respectively). Add a Label and set its Layout to Full Rect. You can leave it blank, but center its text horizontally and vertically.

Attach the following script to the Lobby node (save it as `res://Lobby/Lobby.gd`):
```
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
```

Then, attach signals to Host and Join and connect them to the preexisting functions in the Lobby script.

Save the scene as res://Lobby/Lobby.tscn, and then, in the Project menu, Project Settings->Application->Run, set the main scene to `res://Lobby/Lobby.tscn`

Next, edit `res://Game.gd` so that a second player is added:
```
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
```

Finally, we need to create the passive script for the network-controlled player. Create a new script: `res://Player/Player_passive.gd:`
```
extends CharacterBody3D

@rpc("any_peer","call_remote","unreliable_ordered")
func _set_position(pos):
	global_position = pos

@rpc("any_peer","call_remote","unreliable_ordered")
func _set_rotation(rot):
	rotation.y = rot

@rpc("any_peer","call_remote","unreliable_ordered")
func _die():
	queue_free()

```

Then, edit `res://Player/Player.gd` to send the remote procedure calls when the position or rotation is updated, or when the player dies:
```
@rpc("any_peer","call_remote","unreliable_ordered")
func _set_position(p):
	global_position = p

@rpc("any_peer","call_remote","unreliable_ordered")
func _set_rotation(r):
	rotation.y = r

@rpc("any_peer","call_remote","unreliable_ordered")
func _die():
	queue_free()
```
```
	rpc("_set_position", global_position)
```
```
	rpc("_set_rotation", rotation.y)
```
```
	rpc("_die")
```

Test your project. *In the Debug Menu, you can choose to Run Multiple Instances->Run Two Instances.* In one window, select "Host". In the other, select "Join". You should be able to move between the two windows and see the two players updated as they move around.

Quit Godot. In GitHub desktop, add a summary message, commit your changes and push them back to GitHub. If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-5-5-Networking) on Canvas.

The final state of the file should be as follows (replacing the "Created by" information with your name):
```
# Exercise 5.5-Networking

Exercise for MSCH-C220

A simple networked game

To play, run two instances of this exercise in Godot. In one press the Host Game button. Then press the Join Game button in the second window. The position of the players will be relayed over the network (over localhost) from one copy to the other. Each player can be controlled (using WASD) depending on which window is selected.

## Implementation

Built using Godot 4.1.1

## References

[3D Multiplayer for Beginners](https://www.youtube.com/watch?v=K0luHLZxjBA)

## Future Development

None

## Created by 

Jason Francis
```
