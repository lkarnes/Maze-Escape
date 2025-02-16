extends HBoxContainer

@export var max_hearts: int = 3;
@export var hearts: int = 3;

signal no_hearts_left

func _ready():
	for i in range(max_hearts):
		create_heart();
	
func lose_heart():
	if hearts > 0:
		var heart_nodes = get_children();
		heart_nodes[hearts - 1].queue_free();
		create_heart(false);
		hearts -= 1;
	else:
		no_hearts_left.emit();
	
func gain_heart():
	if hearts == max_hearts:
		max_hearts += 1;
		create_heart();
	hearts += 1;
	
func create_heart(filled: bool = true):
	var heart := TextureRect.new()
	if filled:
		heart.texture = load("res://assets/Character/heart.png");
	else:
		heart.texture = load("res://assets/Character/heart-empty.png");
	
	heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	heart.custom_minimum_size = Vector2(11, 10)
	heart.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var block_lighting: CanvasItemMaterial = CanvasItemMaterial.new();
	block_lighting.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX;
	block_lighting.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED;
	
	heart.material = block_lighting;
	
	add_child(heart)
