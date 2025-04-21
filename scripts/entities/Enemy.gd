extends MovingEntity
class_name Enemy

var health: int = 3
var damage: int = 1

func _ready():
	push_error("UNIMPLENTED ERROR: Enemy._ready()")

func _process(delta):
	_ai_behavior(delta)

func _ai_behavior(delta):
	push_error("UNIMPLENTED ERROR: Enemy._ai_behavior()")
