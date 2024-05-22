extends Node2D

@onready var start= $Start
@onready var player = $Player
@onready var exit = $Exit
@export var next_level: PackedScene = null
@onready var death_zone = $Deathzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer
var timer_node = null
var time_left
@export var level_time = 180
@export var is_final_level: bool = false
var win = false
var gos_scene = preload("res://scenes/game_over_screen.tscn")

func _ready():
	player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.connect("touched_player", _on_trap_touched_player)
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			var gos_scene = preload("res://scenes/game_over_screen.tscn")
			AudioPlayer.play_sfx("hurt")
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	

func _on_deathzone_body_entered(body):
	var gos_scene = preload("res://scenes/game_over_screen.tscn")
	AudioPlayer.play_sfx("hurt")
	reset_player()
	
func _on_trap_touched_player():
	var gos_scene = preload("res://scenes/game_over_screen.tscn")
	AudioPlayer.play_sfx("hurt")
	reset_player()
	

func reset_player():
	var gos_scene = preload("res://scenes/game_over_screen.tscn")
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
	
func _on_exit_body_entered(body):
	if body is Player:
		exit.animate()
	if is_final_level || (next_level != null):
		player.active = false
		await get_tree().create_timer(1.7).timeout
		if is_final_level:
			ui_layer.show_win_screen(true)
		else:
			get_tree().change_scene_to_packed(next_level)
