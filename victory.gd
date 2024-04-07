extends Node2D


func _ready():
	Utils.resetGame()
	Utils.loadGame()

func _on_quit_pressed():
	get_tree().quit()

