extends MovingEntity
# Keep in mind CharacterBody2D, might be better ?


class_name Player

var screen_size: Vector2
var can_attack: bool = true
var pointer_position: Vector2

var AttackSceneNoPart = preload("res://scenes/sprites/AttackSpriteNoParts.tscn")
var AttackSceneLow = preload("res://scenes/sprites/AttackSpriteLow.tscn")
var AttackSceneMed = preload("res://scenes/sprites/AttackSpriteMed.tscn")
var AttackSceneHigh = preload("res://scenes/sprites/AttackSpriteHigh.tscn")

var available_power_level: Array = ['NoPowerLevel', 'LowPowerLevel', 'MedPowerLevel', 'HighPowerLevel']
var power_level = 'NoPowerLevel'
var AttackScene = AttackSceneNoPart

@export var walk_factor: float = 0.3
@export var run_multiplier: float = 2.0
@export var attack_cd: float = 1.0
# @export var speed: int = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AttackTimer.wait_time = attack_cd
	$AttackTimer.one_shot = true
	$AttackTimer.timeout.connect(_on_attack_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var character_velocity: Vector2 = get_velocity_from_inputs()
	update_sprites(character_velocity)
	update_position_from_velocity_and_delta(character_velocity, delta)

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pointer_position = event.position
		attack()

func change_power_level(new_power_level) -> void:
	if new_power_level not in available_power_level:
		push_error("VALUE ERROR: Player.change_power_level() - new_power_level not in avaailable level powers")
	power_level = new_power_level
	if power_level == 'NoPowerLevel':
		AttackScene = AttackSceneNoPart
	elif power_level == 'LowPowerlevel':
		AttackScene = AttackSceneLow
	elif power_level == 'MidPowerLevel':
		AttackScene = AttackSceneMed
	elif power_level == 'HighPowerLevel':
		AttackScene = AttackSceneHigh
	else:
		push_error("VALUE ERROR: Player.change_power_level() - Unknown power_level")

func attack() -> void:
	if not can_attack:
		return
	can_attack = false

	var atk = AttackScene.instantiate()
	atk.position  = global_position
	atk.direction = (pointer_position - global_position).normalized()
	
	# add it to the same parent as the player (e.g. your level root)
	get_parent().add_child(atk)
	$AttackTimer.start()

func start(pos: Vector2) -> void:
	set_new_position(pos)
	show()
	$CollisionShape2D.disabled = false

func set_new_position(wanted_position: Vector2) -> void:
	position = wanted_position

func update_position_from_velocity_and_delta(velocity: Vector2, delta: float) -> void:
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

# computes the velocity of the character based on it's properties and pressed inputs
func get_velocity_from_inputs() -> Vector2:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("walk_front"):
		velocity.y += walk_factor
	if Input.is_action_pressed("walk_back"):
		velocity.y -= walk_factor
	if Input.is_action_pressed("walk_left"):
		velocity.x -= walk_factor
	if Input.is_action_pressed("walk_right"):
		velocity.x += walk_factor
	velocity = velocity.normalized() * speed
	if Input.is_action_pressed("run"):
		velocity *= run_multiplier
	return velocity

# updates the sprites of the character based on the velocity of the character
func update_sprites(velocity: Vector2) -> void:
	$AnimatedSprite2D.play()
	# walk and run right
	if 0 < velocity.x and velocity.x < 1.0:
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = true
	elif 1.0 <= velocity.x:
		$AnimatedSprite2D.animation = "run_right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = true
	# walk and run left
	elif -1.0 < velocity.x and velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	elif velocity.x <= -1:
		$AnimatedSprite2D.animation = "run_left"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	# walk and run front (down)
	elif 0 < velocity.y and velocity.y < 1.0:
		$AnimatedSprite2D.animation = "walk_front"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	elif 1.0 <= velocity.y:
		$AnimatedSprite2D.animation = "run_front"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	# walk and run back (up)
	elif -1.0 < velocity.y and velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_back"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	elif velocity.y <= -1.0:
		$AnimatedSprite2D.animation = "run_back"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	# idle 
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false

func _on_attack_timer_timeout() -> void:
	can_attack = true
