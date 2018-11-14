extends KinematicBody

# movement variables
var speed = 30
var jumpforce = 3
var forward
var back
var left
var right
var jump
var motion = Vector3()
#var raycast
#var normal

# Movement Constants
const gravity = Vector3(0,-9,0)
const vertical_powah = gravity
#const jump_deacceleration = 3 

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#raycast = get_node("CollisionShape/RayCast")
	pass
	
	
func _physics_process(delta):
#	motion.x=0
#	motion.z=0
	
	
	# INPUT KEYS
	forward = Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W)
	
	back = Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S)
	
	left = Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)
	
	right= Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)
	
	jump = Input.is_key_pressed(KEY_SPACE)
	
	if is_on_floor():
		motion.x=0
		motion.z=0
		vertical_powah= gravity
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
		vertical_powah = Vector3(0,2,0)
#		motion.y=jump_powah
#		motion = move_and_slide(motion,Vector3(0,1,0))
		
	# Gravity
	if !is_on_floor():
		#motion += gravity * delta
		vertical_powah +=  gravity * delta

	
	motion = move_and_slide(motion + vertical_powah,Vector3(0,1,0))
	print (self.translation)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
