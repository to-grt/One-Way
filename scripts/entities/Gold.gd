extends ImmobileEntity


class_name Gold

var amount: int = 10

func collect(by):
	by.gold += amount
	queue_free()
