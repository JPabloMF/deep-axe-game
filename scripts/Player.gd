extends KinematicBody2D

const UP = Vector2(0,-1)
export var GRAVITY = 20
export var ACCELERATION = 50
export var MAX_SPEED = 100
export var JUMP_HEIGHT = -350
var motion = Vector2()
var direction = 'left'

var lives_counter = 3

onready var player_sprite = $PlayerSprite
onready var axe_collision = $PlayerSprite/Axe/CollisionShape2D
onready var lives_counter_sprite = $LivesCounterSprite

const INPUTS = {
	'UP': 'ui_up',
	'DOWN': 'ui_down',
	'RIGHT': 'ui_right',
	'LEFT': 'ui_left',
	'ATTACK': 'ui_attack'
}

const ANIMATIONS = {
	'IDLE': 'Idle',
	'WALK': 'walk',
	'ATTACK': 'attack',
	'REST': 'rest'
}

func _ready():
	lives_counter_sprite.set_frame(lives_counter)
	
func handle_direction():
	if direction == 'left':
		player_sprite.flip_h = false
		axe_collision.position.x = -11.5
	else:
		player_sprite.flip_h = true
		axe_collision.position.x = 11.5

func handle_attack():
	if Input.is_action_just_pressed(INPUTS.ATTACK):
		print('attack')
		$AnimationPlayer.play("attack")

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false;
	
	if Input.is_action_pressed(INPUTS.RIGHT):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		direction = 'right'
	elif Input.is_action_pressed(INPUTS.LEFT):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		direction = 'left'
	else:
		friction = true
		
	handle_attack()
	handle_direction()
		
	if is_on_floor():
		if Input.is_action_just_pressed(INPUTS.UP):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.4)
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
			
	motion = move_and_slide(motion,UP)
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ANIMATIONS.ATTACK:
		$AnimationPlayer.play("idle")

func _on_Player_area_entered(area):
	if 'Enemy' == area.get_name():
		if lives_counter == 1:
			get_tree().reload_current_scene()
		else:
			lives_counter -= 1
			lives_counter_sprite.set_frame(lives_counter)
