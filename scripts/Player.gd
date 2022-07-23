extends KinematicBody2D

const UP = Vector2(0,-1)
export var GRAVITY = 20
export var ACCELERATION = 50
export var MAX_SPEED = 300
export var JUMP_HEIGHT = -550
var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false;
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = false
	else:
		friction = true
		
	if Input.is_action_just_pressed("ui_attack"):
		$AnimationPlayer.play("attack")
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.4)
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
			
	motion = move_and_slide(motion,UP)
	pass
