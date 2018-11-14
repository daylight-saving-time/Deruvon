extends RigidBody

var speed = 15
var jumpforce = 3
var isgrounded = true
var forward
var back
var left
var right
var jump
var horizontal
var vertical

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#set_contact_monitor( true )
	#set_max_contacts_reported( 10 )

	
	#self.connect("body_entered",self, "OnCollisionEnter")
	pass

func _process(delta):
	forward = Input.is_key_pressed(KEY_UP)
	back = Input.is_key_pressed(KEY_DOWN)
	left = Input.is_key_pressed(KEY_LEFT)
	right= Input.is_key_pressed(KEY_RIGHT)
	jump = Input.is_key_pressed(KEY_SPACE)
	if jump and isgrounded:
		apply_impulse(Vector3(0,0,0), Vector3(0,10,0))
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

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	


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
		
func _input(event):
	print("input event: " + event.get_class())
	if event is InputEventJoypadMotion:
		print("joystick moved")
		horizontal = Input.get_joy_axis(0,0)
		vertical = Input.get_joy_axis(0,1)
		if(horizontal > 0.25 or horizontal < -0.25 or vertical > 0.25 or vertical < -0.25):
			set_axis_velocity(Vector3(horizontal,0,vertical)*speed)
		
		
