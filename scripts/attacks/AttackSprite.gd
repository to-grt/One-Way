extends Area2D


class_name AttackSprite

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	rotation = direction.angle()

func _process(delta):
	position += direction * speed * delta
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_AttackSprite_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(1)
		queue_free()
