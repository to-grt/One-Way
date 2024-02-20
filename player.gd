extends CharacterBody2D

@export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func _input(event):
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		print("Mouse Motion at: ", event.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("click"):
		print("click")
	if Input.is_action_pressed("walk_front"):
		print("walk_front")
		velocity.y += 0.5
	if Input.is_action_pressed("walk_back"):
		print("walk_back")
		velocity.y -= 0.5
	if Input.is_action_pressed("walk_left"):
		print("walk_left")
		velocity.x -= 0.5
	if Input.is_action_pressed("walk_right"):
		print("walk_right")
		velocity.x += 0.5
		
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed("run"):
		print("run")
		velocity.x *= 2
		velocity.y *= 2
		
	$AnimatedSprite2D.play()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x > 1:
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = true
	elif velocity.x < -1:
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "walk_front"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_back"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
