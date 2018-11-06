extends RigidBody

# Camera Control Variables
# Affects camera angle (when mouse is moved vertically)
const CAMERA_X_ROT_MIN = 0
const CAMERA_X_ROT_MAX = 30

# Affects mouse sensitivity for camera control
var sensitivity = 0.01

# Internal variables
var camera_x_rot = 0.0

# Movement Variables
var speed = 15
var jumpforce = 3
var isgrounded = true
var forward
var back
var left
var right
var jump


func _ready():
	# Capture mouse within game
	Input.set_mouse_mode(2)
	set_process_input(true)


func _input(event):
	if event is InputEventMouseMotion:
		# Left and right camera movement
		$CameraBase.rotate_y(-event.relative.x * sensitivity)
		$CameraBase.orthonormalize()

		# Up and down camera movement
		camera_x_rot = clamp(
			camera_x_rot - event.relative.y * sensitivity,
			deg2rad(CAMERA_X_ROT_MIN),
			deg2rad(CAMERA_X_ROT_MAX))
		$CameraBase/CameraRotation.rotation.x =  camera_x_rot


func _process(delta):
	forward = Input.is_key_pressed(KEY_UP)
	back = Input.is_key_pressed(KEY_DOWN)
	left = Input.is_key_pressed(KEY_LEFT)
	right= Input.is_key_pressed(KEY_RIGHT)
	jump = Input.is_key_pressed(KEY_SPACE)
	if jump and isgrounded:
		self.apply_impulse(Vector3(0,0,0), Vector3(0,10,0))
	if forward:
		print("going forwards")
		self.global_translate((Vector3(speed,0,0)*delta ))
	if left:
		print("going left")
		self.global_translate((Vector3(0,0,-speed)*delta))
	if right:
		print("going right")
		self.global_translate((Vector3(0,0,speed)*delta))
	if back:
		print("going back")
		self.global_translate((Vector3(-speed,0,0)*delta ))
	


func _on_Player_body_entered(body):
	var _floor = (get_node("../Floor"))
	print(body)
	print (_floor)
	if body == _floor:
		print ("grounded")
		self.isgrounded = true


func _on_Player_body_exited(body):
	var _floor = (get_node("../Floor"))
	print(body)
	print (_floor)
	if body == _floor:
		print ("jumped")
		self.isgrounded = false
