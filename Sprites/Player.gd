extends KinematicBody2D
class_name Player

export(Resource) var statsData

var velocity = Vector2.ZERO
onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.frames = load("res://Resources/PlayerBlueSkin.tres")

func _physics_process(_delta):
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "Run"
		
		animatedSprite.flip_h = input.x > 0
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = statsData.JUMP_FORCE
	else:
		animatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_up") && velocity.y < statsData.JUMP_RELEASE_FORCE:
			velocity.y = statsData.JUMP_RELEASE_FORCE
			
	if velocity.y > 0:
		velocity.y += statsData.ADDITONAL_GRAVITY

	var was_in_air = !is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() && was_in_air
	
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
	
func apply_gravity():
	velocity.y += statsData.GRAVITY
	velocity.y = min(velocity.y, 250)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, statsData.FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, statsData.MAX_SPEED * amount, statsData.ACCELERATION)
	
