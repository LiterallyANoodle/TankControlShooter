extends CharacterBody3D

enum {QUICK_LEFT, QUICK_RIGHT, QUICK_BACK}

const SPEED: float = 5.0
const ANGULAR_SPEED: float = 60.0 # degrees
const DEG_90: float = deg_to_rad(90)
const DEG_180: float = deg_to_rad(180)
const DOUBLE_TAP: int = 500000 # time in usec

@onready var facing_direction: Vector2 = Vector2(0, 1)

@onready var double_tap_left: int
@onready var double_tap_right: int
@onready var double_tap_back: int

func quick_turn(tap_dir: int) -> void:
	var rot_difference: float = 0
	if tap_dir == QUICK_LEFT:
		rot_difference = DEG_90
	if tap_dir == QUICK_RIGHT:
		rot_difference = -DEG_90
	if tap_dir == QUICK_BACK:
		rot_difference = DEG_180
	interpolate_turn(rot_difference)
	
func interpolate_turn(rot_difference: float) -> void:
	rotate_y(rot_difference)
	facing_direction = facing_direction.rotated(rot_difference)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		var now_usec: int = Time.get_ticks_usec()
		if double_tap_left != null:
			if (now_usec - double_tap_left) < DOUBLE_TAP:
				# do the quick turn
				print("QUICK LEFT")
				quick_turn(QUICK_LEFT)
		double_tap_left = now_usec
				
	if event.is_action_pressed("right"):
		var now_usec: int = Time.get_ticks_usec()
		if double_tap_right != null:
			if (now_usec - double_tap_right) < DOUBLE_TAP:
				# do the quick turn
				print("QUICK RIGHT")
				quick_turn(QUICK_RIGHT)
		double_tap_right = now_usec
				
	if event.is_action_pressed("down"):
		var now_usec: int = Time.get_ticks_usec()
		if double_tap_back != null:
			if (now_usec - double_tap_back) < DOUBLE_TAP:
				# do the quick turn
				print("QUICK BACK")
				quick_turn(QUICK_BACK)
		double_tap_back = now_usec
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_mov: int = 0
	if Input.is_action_pressed("up"):
		input_mov += 1
	if Input.is_action_pressed("down"):
		input_mov += -1
		
	var input_rot: int = 0
	if Input.is_action_pressed("right"):
		input_rot += 1
	if Input.is_action_pressed("left"):
		input_rot += -1 
	
	# forwards movement 
	if input_mov != 0:
		velocity.x = facing_direction.x * SPEED * input_mov
		velocity.z = -facing_direction.y * SPEED * input_mov
	else:
		velocity.x = 0
		velocity.z = 0
	
	# rotation
	if input_rot != 0:
		var rot_difference: float = deg_to_rad(ANGULAR_SPEED) * -input_rot * delta
		facing_direction = facing_direction.rotated(rot_difference)
		rotate_y(rot_difference)
	
	move_and_slide()
