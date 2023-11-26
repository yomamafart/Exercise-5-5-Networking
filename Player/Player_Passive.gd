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
