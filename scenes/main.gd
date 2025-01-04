extends Node

var traffic_scene = preload("res://scenes/traffic.tscn")
var wheel_scene = preload("res://scenes/wheel.tscn")
var balloon_scene = preload("res://scenes/balloon.tscn")
var obs_types := [traffic_scene, wheel_scene, balloon_scene]
var OBS_START := [99, 1, 0]
var OBS_MIN := 1
var OBS_MAX := 100
var OBS_K := [-10000, 10000, 50000]

var obstacles : Array

const CHAR_START_POS := Vector2i(215, 450)
const CAM_START_POS := Vector2i(576, 324)

const START_SPEED : float = 600.0
const MAX_SPEED : int = 1500
const SPEED_K : int = 100
const SCORE_K : int = 1000
const MIN_OBS_DIST : int = 500
const MAX_OBS_DIST : int = 5000

var is_dying : bool = false
var random

var old_score := 0
func debug_print_tick(score: int, speed: float) -> void:
	if score - old_score < 3:
		return
	old_score = score
	var distance = $Char.position.x - CHAR_START_POS.x
	#PrintToScreen.print_to_screen("distance = " + str(distance))
	#PrintToScreen.print_to_screen("score = " + str(score))
	PrintToScreen.print_to_screen("speed = " + str(speed))
	#PrintToScreen.print_to_screen("obstacles.size = " + str(obstacles.size()))
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Char.set_char_name(["Alex", "Kirill", "Max", "Vitaliy"].pick_random())
	random = RandomNumberGenerator.new()
	$Char.position = CHAR_START_POS
	$Char.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$HUD.set_high_score(Globals.high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dying:
		return
	
	var speed = get_speed(delta)
	var score = get_score()
	
	generate_obs()
	
	$Char.position.x += speed * delta
	$Camera2D.position.x += speed * delta
	$HUD.set_score(score)
	
	clean_obs()
	
	#debug_print_tick(score, speed)

func get_speed(delta: float) -> float:
	var distance = $Char.position.x - CHAR_START_POS.x
	var speed = START_SPEED + distance / SPEED_K
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	return speed

func get_score() -> int:
	var distance = $Char.position.x - CHAR_START_POS.x
	var score = distance / SCORE_K
	return score

func should_generate_obs() -> bool:
	#generate if no obstacles exist
	if obstacles.is_empty():
		return true
	
	var last_obs_dist = obstacles.back().position.x
	var new_obs_dist = $Camera2D.position.x + $Camera2D/ObsGroundSpawnPoint.position.x
	
	# check probability if we should generate
	if last_obs_dist + randi_range(MIN_OBS_DIST, MAX_OBS_DIST) > new_obs_dist:
		return false
	
	return true

func get_probs() -> Array:
	var distance = $Char.position.x - CHAR_START_POS.x
	var obs_probs = OBS_START
	for i in OBS_START.size():
		obs_probs[i] = OBS_START[i] + distance / OBS_K[i]
		if obs_probs[i] < OBS_MIN:
			obs_probs[i] = OBS_MIN
		if obs_probs[i] > OBS_MAX:
			obs_probs[i] = OBS_MAX
	return obs_probs

func generate_obs() -> void:
	if not should_generate_obs():
		return
	
	var probs = get_probs()
	var obs = obs_types[random.rand_weighted(probs)].instantiate()
	var obs_h = obs.get_node("Sprite2D").texture.get_height()
	
	var SpawnPoint = $Camera2D/ObsGroundSpawnPoint.position
	if obs.has_node("IsFlying"):
		SpawnPoint = $Camera2D/ObsSkySpawnPoint.position
	
	var obs_x = $Camera2D.position.x + SpawnPoint.x + randi_range(0, 1000)
	var obs_y : int = $Camera2D.position.y + SpawnPoint.y
	
	#PrintToScreen.print_to_screen("Generated obs at " + str(obs_x) + ", " + str(obs_y))
	#PrintToScreen.print_to_screen("Probs [" + str(probs[0]) + ", " + str(probs[1]) + ", " + str(probs[2]) + "]")
	
	obs.position = Vector2i(obs_x, obs_y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func clean_obs() -> void:
	for obs in obstacles:
		if obs.position.x < ($Camera2D.position.x - get_window().size.x):
			#PrintToScreen.print_to_screen("Clean obs at " + str(obs.position.x))
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
