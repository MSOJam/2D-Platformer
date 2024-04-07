extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED = 50
var JUMP = -150
var player
var chase = false
var floorCoordinate = 478

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			player = get_node("../../Player/Player")
			var direction = (player.position - self.position).normalized()
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = true
			else:
				get_node("AnimatedSprite2D").flip_h = false
			if self.position[1] >= floorCoordinate:
				velocity.x = direction.x * SPEED
				velocity.y = JUMP
			if velocity.y < 0:
				get_node("AnimatedSprite2D").play("Jump")
			else:
				get_node("AnimatedSprite2D").play("Landing")
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
			velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		Utils.saveGame()
		_mob_death()

func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 1
		Utils.saveGame()
		

func _mob_death():
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
