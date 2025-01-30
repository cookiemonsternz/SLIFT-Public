extends CharacterBody2D

@export var jump_buffer_timer: Timer


const SPEED = 350.0 # Base horizontal movement speed
const ACCELERATION = 1200.0 # Base acceleration
const FRICTION = 1400.0 # Base friction
const GRAVITY = 2000.0 # Gravity when moving upwards
const FALL_GRAVITY = 3000.0 # Gravity when falling downwards
const FAST_FALL_GRAVITY = 5000.0 # Gravity while holding "fast_fall"
const WALL_GRAVITY = 25.0 # Gravity while sliding on a wall
const JUMP_VELOCITY = -700.0 # Maximum jump strength
const WALL_JUMP_VELOCITY = -700.0 # Maximum wall jump strength
const WALL_JUMP_PUSHBACK = 300.0 # Horizontal push strength off walls
const INPUT_BUFFER_PATIENCE = 0.1 # Input queue patience time
const COYOTE_TIME = 0.08 # Coyote patience time

const gravity_strength = 3000

var input_buffer : Timer # Reference to the input queue timer
var coyote_timer : Timer # Reference to the coyote timer
var coyote_jump_available := true


var timer = Timer.new()


func _process(delta: float) -> void:
	var hit_jump = Input.is_action_just_pressed("player_jump")
	if not is_on_floor():
		velocity.y += gravity_strength * delta
	
	if not is_on_floor() and hit_jump:
		print("Air Jump")
		jump_buffer_timer.start()
		
	if is_on_floor() and jump_buffer_timer.time_left >  0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer.stop()
	
	
	var input_chosen = Input.get_axis("move_left", "move_right")
	velocity.x = 500 * input_chosen
	#print(velocity.x)
	if hit_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#print(velocity.y)
	move_and_slide()
