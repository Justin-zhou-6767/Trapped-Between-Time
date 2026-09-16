extends CharacterBody2D


const SPEED = 670.0
const JUMP_VELOCITY = -600.0
const BACKWARDSA = 400.0
const BACKUP = -220

const ACCELERATION =4000.0
const FRICTION = 5000.0
const FALL_GRAVITY_MULT = 1.8
var dead := false
const JUMP_CUT_MULT = 0.5       


func _physics_process(delta: float) -> void:
	
	if dead:

		return
	# Add the gravity.
	if not is_on_floor():
		if velocity.y>0:
			velocity += get_gravity() * delta * FALL_GRAVITY_MULT
		else:
			velocity += get_gravity()*delta
			

	# Handle jump.
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULT
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)

	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)



	move_and_slide()

func die() ->void:
	if dead:
		return
	dead = true
	
	print("died")
	velocity=Vector2.ZERO
	global_position += Vector2(-BACKWARDSA,BACKUP)
	await get_tree().create_timer(0.4).timeout
	dead=false
	
func fullrespawn()->void:
	dead = false
	global_position = Vector2.ZERO
	velocity = Vector2.ZERO
func _on_area_2d_body_entered(body:Node2D) ->void:
	if body is TileMapLayer:
		die()
	
