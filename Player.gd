extends CharacterBody2D


const SPEED = 670.0
const JUMP_VELOCITY = -600.0
const BACKWARDSA = 400.0
const BACKUP = -167

const LEVEL_MIN_Y = 0.0     
const LEVEL_MAX_Y = 2000.0 
const LEVEL_MIN_X = 0.0
const LEVEL_MAX_X = 3000.0

const ACCELERATION =4000.0
const FRICTION = 5000.0
const FALL_GRAVITY_MULT = 1.8
var dead := false
const JUMP_CUT_MULT = 0.5       
const MAXDEATHS = 5
var corpses: Array[Node]=[]
var Deathcount :=0

@onready var heart_display = get_tree().current_scene.get_node("CanvasLayer/HBoxContainer")
@onready var spawn: Marker2D = get_tree().current_scene.get_node("Marker2D")
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
func spawncorpses()->void:
	var corpse := StaticBody2D.new()
	corpse.global_position = global_position
	
	var sprite := Sprite2D.new()
	sprite.texture = $Sprite2D.texture
	sprite.scale = $Sprite2D.scale
	sprite.modulate = Color(0.5,0.5,0.5)
	corpse.add_child(sprite)
	
	var collision := CollisionShape2D.new()
	collision.shape = $CollisionShape2D.shape
	corpse.add_child(collision)
	
	get_parent().add_child(corpse)
	corpses.append(corpse)
func die() ->void:
	if dead:
		return
	Deathcount+=1
	if(Deathcount>5):
		fullrespawn()
		return
	dead = true
	spawncorpses()
	print("died")
	velocity=Vector2.ZERO
	heart_display.update_hearts(MAXDEATHS-Deathcount)
	
	global_position += Vector2(-BACKWARDSA,BACKUP)
	global_position.x = clamp(global_position.x, LEVEL_MIN_X, LEVEL_MAX_X)
	global_position.y = clamp(global_position.y, LEVEL_MIN_Y, LEVEL_MAX_Y)
	await get_tree().create_timer(0.4).timeout
	dead=false
	
func fullrespawn()->void:
	dead = false
	global_position = spawn.global_position
	velocity = Vector2.ZERO
	for corpse in corpses:
		if is_instance_valid(corpse):
			corpse.queue_free()
	corpses.clear()
	Deathcount=0
	heart_display.update_hearts(MAXDEATHS)
func _on_area_2d_body_entered(body:Node2D) ->void:
	if body is TileMapLayer:
		die()
	
