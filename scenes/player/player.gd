class_name Player

extends CharacterBody2D

@export var movement_data: PlayerMovementData

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer

var air_jump: bool = false


func _process(delta: float):
	apply_gravity(delta)
	handle_jump()
	handle_wall_jump()
	var input_axis: float = Input.get_axis("move_left", "move_right")
	handle_accleration(input_axis, delta)
	handle_air_accleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animation(input_axis)
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	var just_left_ledge: bool = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()


func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += movement_data.gravity * delta


func handle_wall_jump():
	if not is_on_wall(): return
	var wall_normal: Vector2 = get_wall_normal()
	if Input.is_action_just_pressed("move_left") and wall_normal == Vector2.LEFT:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_speed
	if Input.is_action_just_pressed("move_right") and wall_normal == Vector2.RIGHT:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_speed


func handle_jump():
	if is_on_floor(): air_jump = true
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_speed
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_speed / 2.0:
			velocity.y = movement_data.jump_speed / 2.0
		
		if Input.is_action_just_pressed("jump") and air_jump:
			velocity.y = movement_data.jump_speed * 0.8
			air_jump = false


func apply_air_resistance(input_axis: float, delta: float):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


func apply_friction(input_axis: float, delta: float):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)


func handle_accleration(input_axis: float, delta: float):
	if not is_on_floor():
		return
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_accleration(input_axis: float, delta: float):
	if is_on_floor():
		return
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func update_animation(input_axis: float):
	if input_axis:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
