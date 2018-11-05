extends RigidBody

var speed = 15
var jumpforce = 5
var isgrounded = true
var forward
var back
var left
var right
var jump

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_contact_monitor( true )
	set_max_contacts_reported( 10 )

	
	#self.connect("body_entered",self, "OnCollisionEnter")

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

#func OnCollisionEnter(body):
#	print(body)

	
	
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	


func _on_Player_body_entered(body):
	print(body.name) # replace with function body
	print (body.transform)
