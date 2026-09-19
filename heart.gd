extends HBoxContainer

@export var hearttexture: Texture2D
@export var maxhearts: int = 6

func update_hearts(currentlives:int)->void:
	for child in get_children():
		child.queue_free()
		
	for i in currentlives:
		var heart:= TextureRect.new()
		heart.texture=hearttexture
		heart.custom_minimum_size=Vector2(32,32)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(heart)


func _ready()->void:
	update_hearts(maxhearts)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
