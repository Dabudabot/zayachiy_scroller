extends CharacterBody2D

signal death_animation_finished

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1500
var char_name : String = "Vitaliy"
var is_dying : bool = false

func set_char_name(new_name: String) -> void:
	char_name = new_name

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	if not is_dying:
		if is_on_floor():
			if Input.is_action_pressed("ui_select"):
				velocity.y = JUMP_SPEED
				$JumpSound.play()
			else:
				$Anim.play("run_" + char_name)
		else:
			$Anim.play("jump_" + char_name)
	move_and_slide()

func die() -> void:
	is_dying = true
	$dieSound.play()
	$Anim.play("die_" + char_name)

func _on_anim_animation_finished() -> void:
	if $Anim.animation == "die_" + char_name:
		emit_signal("death_animation_finished")
