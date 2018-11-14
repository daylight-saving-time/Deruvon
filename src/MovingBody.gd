extends KinematicBody

# Affects movement speed
const SPEED = 30

# Affects camera angle (when mouse is moved vertically)
const CAMERA_X_ROT_MIN = -20
const CAMERA_X_ROT_MAX = 10
const CAMERA_ZOOM_MAX = 1.5
const CAMERA_ZOOM_MIN = 0.5

# Affects mouse sensitivity for camera control
var sensitivity = 0.005
var inverse_y_axis = false

# Internal variables
var camera_x_rot = 0.0
var is_camera_locked = false
var camera_y_rot
var zoom

# Nodes
var camera_base
var camera_rotation
var camera
var tps_camera_location


func _ready():
	camera_base = $CameraBase
	camera_rotation = $CameraBase/CameraRotation
	camera = $CameraBase/CameraRotation/Camera
	tps_camera_location = $CameraBase/CameraRotation/TPSCameraLocation

	# Capture mouse within game
	camera_y_rot = camera_rotation.rotation.y
	zoom = camera_base.scale.x
	Input.set_mouse_mode(2)
	set_process_input(true)


func _input(event):

	# Mouse scroll to zoom in and out
	if event.is_action_pressed("zoom_in") and not is_camera_locked:
		zoom = clamp(zoom - 0.1, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
		camera_rotation.scale = Vector3(zoom, zoom, zoom)
	if event.is_action_pressed("zoom_out") and not is_camera_locked:
		zoom = clamp(zoom + 0.1, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
		camera_rotation.scale = Vector3(zoom, zoom, zoom)

	# Press TAB to toggle camera lock
	if event is InputEventKey and event.scancode == KEY_TAB and not event.pressed:
		var other_cam_transform

		if not is_camera_locked:
			$AnimationPlayer.play("aiming")
			$"../CrosshairLayer/Crosshair".show()

			# Camera is about to be locked, look at the player now
			camera_base.rotation.y = camera_y_rot
			camera_rotation.scale = Vector3(1, 1, 1)

			camera_x_rot = 0.0
			camera_rotation.rotation.x =  camera_x_rot

			other_cam_transform = camera.global_transform
			camera.global_transform = tps_camera_location.global_transform
			tps_camera_location.global_transform = other_cam_transform

		else:
			# TODO: Change to idle animation when we have it
			$AnimationPlayer.stop()
			$"../CrosshairLayer/Crosshair".hide()

			# Camera is about to be unlocked, store current player (camera) direction
			camera_y_rot = camera_base.rotation.y
			camera_rotation.scale = Vector3(zoom, zoom, zoom)

			other_cam_transform = tps_camera_location.global_transform
			tps_camera_location.global_transform = camera.global_transform
			camera.global_transform = other_cam_transform

		is_camera_locked = not is_camera_locked

	# Move mouse for mouselook
	if event is InputEventMouseMotion:
		# Handle horizontal mouselook
		if is_camera_locked:
			# Move the entire player and its cameras if the camera is locked
			rotate_y(-event.relative.x * sensitivity)
		else:
			# Only move the camera if the camera is unlocked
			camera_base.rotate_y(-event.relative.x * sensitivity)
			camera_base.orthonormalize()

		# Handle vertical mouselook
		if not is_camera_locked:
			camera_x_rot = clamp(
				camera_x_rot + event.relative.y * sensitivity,
				deg2rad(CAMERA_X_ROT_MIN),
				deg2rad(CAMERA_X_ROT_MAX))
			camera_rotation.rotation.x =  camera_x_rot
		else:
			camera_x_rot = clamp(
				camera_x_rot - event.relative.y * sensitivity,
				deg2rad(CAMERA_X_ROT_MIN),
				deg2rad(CAMERA_X_ROT_MAX))
			camera.rotation.x = camera_x_rot


func _physics_process(delta):
	# Raycasting test
	# NOTE: One click triggers this multiple times
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and is_camera_locked:
		var cam_direction = get_viewport().size / 2
		var from = camera.project_ray_origin(cam_direction)
		var to = from + camera.project_ray_normal(cam_direction) * 1000
		var direct_state = PhysicsServer.space_get_direct_state(camera.get_world().get_space())
		var result = direct_state.intersect_ray(from, to, [self])
		if result:
			print(result["collider"].get_name())

	var speed = SPEED
	var move_vector = Vector2()
	var direction = Vector3()
	var cam_z
	var cam_x

	if Input.is_key_pressed(KEY_SHIFT):
		speed *= 1.5
	elif Input.is_key_pressed(KEY_CONTROL):
		speed *= 0.5

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
		cam_z = -camera.global_transform.basis.z
		cam_x = camera.global_transform.basis.x
	else:
		# Camera is unlocked, move in direction of the player
		cam_z = global_transform.basis.z
		cam_x = global_transform.basis.x

	cam_z.y = 0
	cam_z = cam_z.normalized()
	cam_x.y = 0
	cam_x = cam_x.normalized()
	move_vector = move_vector.normalized()

	direction += cam_z * move_vector.y
	if is_camera_locked:
		direction += cam_x * move_vector.x
	else:
		direction -= cam_x * move_vector.x
	direction.y = 0
	direction = direction.normalized()

	move_and_slide(direction * speed, Vector3(0,1,0))
