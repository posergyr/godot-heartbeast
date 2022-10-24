extends Area2D

func _on_Hitbox_body_entered(body):
	if body is Player:
		var logMessage = get_tree().reload_current_scene()
		print("Reload scene: " + str(logMessage))
