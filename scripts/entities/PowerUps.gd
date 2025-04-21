extends ImmobileEntity


class_name PowerUp

var effect_strength: int = 1

func apply_to(target):
	if target is Player:
		target.speed += effect_strength
	queue_free()
