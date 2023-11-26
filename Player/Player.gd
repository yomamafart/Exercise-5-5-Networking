extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SCROLL_SPEED = 1.0
const MOUSE_SENSITIVITY = 0.002
const MOUSE_RANGE = 0.5

var peer_id = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	$Pivot/Camera.current = true
		

func _unhandled_input(event):
	if event is InputEventMouseMotion: 
		$Pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -MOUSE_RANGE, MOUSE_RANGE)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("Shoot"):
		$Pivot/Blaster.shoot()
			
		

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	rpc("_set_position", global_position)
	rpc("_set_rotation", rotation.y)


func die():
	rpc("_die")
	queue_free()


@rpc("any_peer","call_remote","unreliable_ordered")
func _set_position(pos):
	global_position = pos

@rpc("any_peer","call_remote","unreliable_ordered")
func _set_rotation(rot):
	rotation.y = rot

@rpc("any_peer","call_remote","unreliable_ordered")
func _die():
	queue_free()
