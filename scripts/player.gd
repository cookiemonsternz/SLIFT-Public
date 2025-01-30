extends CharacterBody2D

@export var jump_buffer_timer: Timer
@export var Kyote: Timer


const JUMP_VELOCITY = -700.0 # Maximum jump strength


const gravity_strength = 3000
var light_exposure = 0
var can_kyote: bool = false
var coyote_jump_available := true
var kyote_timer_reset = true
var timer = Timer.new()


func _process(delta: float) -> void:
	print(light_exposure)
	var input_chosen = Input.get_axis("move_left", "move_right")
	var hit_jump = Input.is_action_just_pressed("player_jump")
	
	if is_on_floor():
		can_kyote = true
		kyote_timer_reset = true
		
	if can_kyote == true and velocity.y > 0 and kyote_timer_reset == true:
		Kyote.start()
		kyote_timer_reset = false
		
	if not is_on_floor() and can_kyote == true and hit_jump and Kyote.time_left > 0:
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor():
		velocity.y += gravity_strength * delta
		
	if not is_on_floor() and hit_jump:
		jump_buffer_timer.start()
		
	if is_on_floor() and jump_buffer_timer.time_left >  0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer.stop()
	
	velocity.x = 500 * input_chosen
	if hit_jump and is_on_floor():
		can_kyote = false
		velocity.y = JUMP_VELOCITY
	move_and_slide()
