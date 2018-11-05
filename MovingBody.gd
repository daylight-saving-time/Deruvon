extends KinematicBody

# Affects movement speed
const SPEED = 200

# Affects camera angle (when mouse is moved vertically)
const CAMERA_X_ROT_MIN = 0
const CAMERA_X_ROT_MAX = 30

# Affects mouse sensitivity for camera control
var sensitivity = 0.01

# Internal variables
var camera_x_rot = 0.0
var orientation

func _ready():
	# Captur mouse within game
	Input.set_mouse_mode(2)
	set_process_input(true)
	orientation = $"..".global_transform
	orientation.origin = Vector3()
	
func _input(event):
	if event is InputEventMouseMotion:
		$CameraBase.rotate_y(-event.relative.x * sensitivity)
		$CameraBase.orthonormalize()
		camera_x_rot = clamp(
			camera_x_rot - event.relative.y * sensitivity,
			deg2rad(CAMERA_X_ROT_MIN),
			deg2rad(CAMERA_X_ROT_MAX))
		$CameraBase/CameraRotation.rotation.x =  camera_x_rot

func _physics_process(delta):
	var direction = Vector3()
	var move_vector = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vector.y +=1
	if Input.is_action_pressed("move_down"):
		move_vector.y -=1
	if Input.is_action_pressed("move_left"):
		move_vector.x -=1
	if Input.is_action_pressed("move_right"):
		move_vector.x +=1
	
	var cam_z = -$CameraBase/CameraRotation/Camera.global_transform.basis.z
	var cam_x = $CameraBase/CameraRotation/Camera.global_transform.basis.x
	
	cam_z.y = 0
	cam_z = cam_z.normalized()
	cam_x.y = 0
	cam_x = cam_x.normalized()

	move_vector = move_vector.normalized()
	direction += cam_z * move_vector.y
	direction += cam_x * move_vector.x
	direction.y = 0
	direction = direction.normalized()
	var velocity = Vector3()
	velocity = velocity.linear_interpolate(direction * SPEED, 16 * delta)
	move_and_slide(velocity, Vector3(0,1,0))
