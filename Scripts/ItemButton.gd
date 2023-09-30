extends Button

func _on_pressed():
	get_node("/root/GameManager").load_item(null)
