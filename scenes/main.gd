extends Node

var traffic_scene = preload("res://scenes/traffic.tscn")
var obstacles : Array

const CHAR_START_POS := Vector2i(215, 450)
const CAM_START_POS := Vector2i(576, 324)

const START_SPEED : float = 500.0
const MAX_SPEED : int = 1500
const SPEED_K : int = 500
const SCORE_K : int = 1000
const MIN_OBS_DIST : int = 500
const MAX_OBS_DIST : int = 5000

var screen_sz : Vector2i
var ground_h : int

var is_dying : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_sz = get_window().size
	ground_h = $Ground.get_node("CollisionShape2D").get_shape().get_rect().size.y
	$Char.position = CHAR_START_POS
	$Char.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	$HUD.set_high_score(Globals.high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dying:
		return
	
	var speed = get_speed(delta)
	var score = get_score()
	
	generate_obs()
	
	$Char.position.x += speed
	$Camera2D.position.x += speed
	$HUD.set_score(score)
	
	move_gound()
	clean_obs()

func get_speed(delta: float) -> float:
	var distance = $Char.position.x - CHAR_START_POS.x
	var speed = START_SPEED + distance / SPEED_K
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	speed *= delta
	return speed

func get_score() -> int:
	var distance = $Char.position.x - CHAR_START_POS.x
	var score = distance / SCORE_K
	return score

func move_gound() -> void:
	if $Camera2D.position.x - $Ground.position.x > screen_sz.x * 1.5:
		$Ground.position.x += screen_sz.x

func should_generate_obs() -> bool:
	#generate if no obstacles exist
	if obstacles.is_empty():
		return true
	
	var distance = $Char.position.x - CHAR_START_POS.x
	var last_obs_dist = obstacles.back().position.x
	var new_obs_dist = screen_sz.x + distance
	
	# check probability if we should generate
	if last_obs_dist + randi_range(MIN_OBS_DIST, MAX_OBS_DIST) > new_obs_dist:
		return false
	
	return true

func generate_obs() -> void:
	if not should_generate_obs():
		return
		
	var distance = $Char.position.x - CHAR_START_POS.x
	
	var obs = traffic_scene.instantiate()
	var obs_h = obs.get_node("Sprite2D").texture.get_height()
	var obs_scale = obs.get_node("Sprite2D").scale
	var obs_x = screen_sz.x + distance + randi_range(0, 1000)
	var obs_y : int = screen_sz.y - ground_h - (obs_h * obs_scale.y / 2)
	
	obs.position = Vector2i(obs_x, obs_y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func clean_obs() -> void:
	for obs in obstacles:
		if obs.position.x < ($Camera2D.position.x - screen_sz.x):
			obs.queue_free()
			obstacles.erase(obs)

func hit_obs(body) -> void:
	if body.name == "Char":
		is_dying = true
		$Char.die()

func _on_char_death_animation_finished() -> void:
	Globals.current_score = get_score()
	if Globals.high_score < Globals.current_score:
		Globals.high_score = Globals.current_score
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
