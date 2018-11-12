extends KinematicBody

# Affects camera angle (when mouse is moved vertically)
const CAMERA_X_ROT_MIN = -20
const CAMERA_X_ROT_MAX = 30

# Affects mouse sensitivity for camera control
var sensitivity = 0.01

# Internal camera variables
var camera_x_rot = 0.0
var is_camera_locked = false
var camera_y_rot

# Movement variables
var speed = 30
var jumpforce = 3
var forward
var back
var left
var right
var jump
var motion = Vector3()

# Movement constants
const gravity = -9.8
#const jump_deacceleration = 3

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
			$"../Overlay/Crosshair".show()
		else:
			# Camera is about to be unlocked, store current player (camera) direction
			camera_y_rot = $CameraBase.rotation.y
			$"../Overlay/Crosshair".hide()

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
		$CameraBase/CameraRotation.rotation.z =  camera_x_rot


func _physics_process(delta):
	motion.x=0
	motion.z=0
	
	
	# INPUT KEYS
	forward = Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W)
	
	back = Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S)
	
	left = Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)
	
	right= Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)
	
	jump = Input.is_key_pressed(KEY_SPACE)
	
	#print(is_on_floor())
	# Move forwards
	if forward:
		print("going forwards")
		motion.x = speed
		
	# Move left
	if left:
		print("going left")
		motion.z = -speed
	
	# Move right
	if right:
		print("going right")
		motion.z = speed
		
	# Move backwards
	if back:
		print("going back")
		motion.x = -speed
		
	#JUMPING WIP
	if jump and is_on_floor():
		
#		print("jump")
		self.move_and_slide(Vector3(0,100,0),Vector3(0,1,0))
		
	# Gravity
	motion.y += gravity * delta
	
	motion = move_and_slide(motion,Vector3(0,1,0))
