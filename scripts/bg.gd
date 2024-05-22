extends ParallaxBackground


@export var bg_change: CompressedTexture2D = preload("res://assets/textures/bg/Pink.png")
@export var scroll_speed = 20
@onready var sprite = $ParallaxLayer/Sprite2D

func _ready():
	sprite.texture = bg_change
	
func _process(delta):
	if sprite.region_rect.position >= Vector2(64, 64):
		sprite.region_rect.position = Vector2.ZERO
	sprite.region_rect.position += delta * Vector2(0, scroll_speed)
	
