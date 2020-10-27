extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const ACCEL = 4.5
var MOUSE_SENSITIVITY = 0.05

var dir = Vector3()



onready var camera = $"RotationHelperYaxis/RotationHelper/Camera"
onready var rotation_helper = $"RotationHelperYaxis/RotationHelper"
onready var rotationHelperYaxis = $"RotationHelperYaxis"


func _ready():

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	print("ayy")
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()
	#control
	if Input.is_key_pressed(KEY_Z):
		input_movement_vector.y += 1
	if Input.is_key_pressed(KEY_S):
		input_movement_vector.y -= 1
	if Input.is_key_pressed(KEY_Q):
		input_movement_vector.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------
	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	if( dir != Vector3(0,0,0) && rotation.y != rotationHelperYaxis.rotation.y):
		rotate_y(rotationHelperYaxis.rotation.y)
		rotationHelperYaxis.rotate_y(-rotationHelperYaxis.rotation.y)
	

	hvel = hvel.linear_interpolate(target, ACCEL * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), false, 4)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -40, -10)
		rotation_helper.rotation_degrees = camera_rot
