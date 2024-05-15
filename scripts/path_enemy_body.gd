extends Enemy

func destroy():
	get_parent().queue_free()
