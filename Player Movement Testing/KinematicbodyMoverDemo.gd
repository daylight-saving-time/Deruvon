extends KinematicBody

var gravity = -9.8

var velocity = Vector3()

var camera


const SPEED = 6

const ACCELERATION = 100

const DE_ACCELERATION = 100



func _ready():

	# Called every time the node is added to the scene.

	# Initialization here

	# pass

	camera = get_node("./Camera").get_global_transform()


#func _process(delta):

#	# Called every frame. Delta is time since last frame.

#	# Update game logic here.

#	pass


func _physics_process(delta):

	var dir = Vector3()

 

	if(Input.is_key_pressed(KEY_W)):

		dir += -camera.basis[2]

	if(Input.is_key_pressed(KEY_S)):

		dir += camera.basis[2]

	if(Input.is_key_pressed(KEY_A)):

		dir += -camera.basis[0]

	if(Input.is_key_pressed(KEY_D)):

		dir += camera.basis[0]
	var jump = Input.is_key_pressed(KEY_SPACE)
		
	if jump and is_on_floor():
		
#		print("jump")
		self.move_and_slide(Vector3(0,100,0),Vector3(0,1,0))
		pass	

 

	dir.y = 0

	dir = dir.normalized()

 
	if !is_on_floor():
		velocity.y += delta * gravity

 

	var hv = velocity

	hv.y = 0

 

	var new_pos = dir * SPEED

	var accel = DE_ACCELERATION

 

	if (dir.dot(hv) > 0):

		accel = ACCELERATION

 

	hv = hv.linear_interpolate(new_pos, accel * delta)

 

	velocity.x = hv.x

	velocity.z = hv.z

 

	velocity = move_and_slide(velocity, Vector3(0,1,0))	