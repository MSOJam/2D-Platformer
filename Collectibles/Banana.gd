extends Area2D


func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _on_area_entered(area):
	if area.name == "forCollectibles":
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 30), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		
		tween.tween_interval(3)
		tween.tween_property(self, "position", position, 0)
		tween1.tween_interval(3)
		tween1.tween_property(self, "modulate:a", 1, 0.3)
		
		await create_tween().tween_interval(3.3).finished
		
		set_deferred("monitorable", true)
		set_deferred("monitoring", true)
