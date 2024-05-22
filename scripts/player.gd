extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var speed = 185
@export var jump_force = 200
@export var jump_force_x = 200
@onready var animated_sprite = $AnimatedSprite2D
var active = true
var direction = 0

func _physics_process(delta):
	if is_on_floor() == false: 
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
		
	if active == true:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force) 
	
		direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	
	velocity.x = direction * speed
	move_and_slide()
	update_animations(direction)


func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force


func update_animations(direction):
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("run")
		else:
			if velocity.y < 0:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("fall")


#BOOLEAN OPERATORS CUH
# and = &&
# or = ||
# not = !

