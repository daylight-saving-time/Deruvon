extends KinematicBody

# Affects movement speed
const SPEED = 50

# Affects camera angle (when mouse is moved vertically)
const CAMERA_X_ROT_MIN = 0
const CAMERA_X_ROT_MAX = 30

# Affects mouse sensitivity for camera control
var sensitivity = 0.01

# Internal variables
var camera_x_rot = 0.0
var is_camera_locked = false
var camera_y_rot

func _ready():
	# Capture mouse within game
	camera_y_rot = $CameraBase.rotation.y
	Input.set_mouse_mode(2)
	set_process_input(true)

func _input(event):
	# Press TAB to toggle camera lock
	if event is InputEventKey and event.scancode == KEY_TAB and not event.pressed:
		if not is_camera_locked:
			# Camera is about to be locked, look at the player now
			$CameraBase.rotation.y = camera_y_rot
			$"../CrosshairLayer/Crosshair".show()
		else:
			# Camera is about to be unlocked, store current player (camera) direction
			camera_y_rot = $CameraBase.rotation.y
			$"../CrosshairLayer/Crosshair".hide()

		is_camera_locked = not is_camera_locked

	# Move mouse for mouselook
	if event is InputEventMouseMotion:
		# Handle horizontal mouselook
		if is_camera_locked:
			# Move the entire player and its cameras if the camera is locked
			rotate_y(-event.relative.x * sensitivity)
		else:
			# Only move the camera if the camera is unlocked
			$CameraBase.rotate_y(-event.relative.x * sensitivity)
			$CameraBase.orthonormalize()

		# Handle vertical mouselook
		camera_x_rot = clamp(
			camera_x_rot - event.relative.y * sensitivity,
			deg2rad(CAMERA_X_ROT_MIN),
			deg2rad(CAMERA_X_ROT_MAX))
		$CameraBase/CameraRotation.rotation.x =  camera_x_rot


func _physics_process(delta):
	var move_vector = Vector2()
	var direction = Vector3()
	var cam_z
	var cam_x

	if Input.is_action_pressed("move_up"):
		move_vector.y += 1
	if Input.is_action_pressed("move_down"):
		move_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vector.x += 1

	if is_camera_locked:
		# Camera is locked, move in direction of the camera
		cam_z = -$CameraBase/CameraRotation/Camera.global_transform.basis.z
		cam_x = $CameraBase/CameraRotation/Camera.global_transform.basis.x
	else:
		# Camera is unlocked, move in direction of the player
		cam_z = global_transform.basis.z
		cam_x = global_transform.basis.x

	cam_z.y = 0
	cam_z = cam_z.normalized()
	cam_x.y = 0
	cam_x = cam_x.normalized()
	move_vector = move_vector.normalized()

	if is_camera_locked:
		direction += cam_z * move_vector.y
	else:
		direction -= cam_z * move_vector.y

	direction += cam_x * move_vector.x
	direction.y = 0
	direction = direction.normalized()

	move_and_slide(direction * SPEED, Vector3(0,1,0))