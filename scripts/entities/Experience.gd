extends ImmobileEntity
class_name Experience


var xp_amount: int = 50

func collect(by):
	by.experience += xp_amount
	queue_free()
