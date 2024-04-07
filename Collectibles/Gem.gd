extends Area2D

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _on_body_entered(body):
	if body.name == "Player":
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		Game.Gems += 1
		get_node("AnimatedSprite2D").play("Collected")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
