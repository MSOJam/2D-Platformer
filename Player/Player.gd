extends CharacterBody2D

var curHealth = Game.playerHP
var playerStatus = "Normal"
var playerFlipped = false
var curFlipped = playerFlipped
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	if playerFlipped != curFlipped:
		velocity.y = 0
		curFlipped = playerFlipped
		
	if playerFlipped == false:
		get_node("AnimatedSprite2D").flip_v = false
		get_node("CollisionShape2D").position.y = 4
		get_node("forCollectibles/CollisionShape2D2").position.y = 4
		if Game.playerHP > 0 && playerStatus in ["Normal", "Cherried"]:
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta

			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or playerStatus == "Cherried"):
				if playerStatus == "Cherried":
					playerStatus = "Normal"
				velocity.y = JUMP_VELOCITY
				anim.play("Jump")
				
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction = Input.get_axis("ui_left", "ui_right")
			
			if direction == -1:
				get_node("AnimatedSprite2D").flip_h = true
			elif direction == 1:
				get_node("AnimatedSprite2D").flip_h = false
			if direction:
				velocity.x = direction * SPEED
				if velocity.y == 0:
					anim.play("Run")
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if velocity.y == 0:
					anim.play("Idle")
				
			if velocity.y > 0:
				anim.play("Fall")
		move_and_slide()
	else:
		get_node("AnimatedSprite2D").flip_v = true
		get_node("CollisionShape2D").position.y = -4
		get_node("forCollectibles/CollisionShape2D2").position.y = -4
		
		if Game.playerHP > 0 && playerStatus in ["Normal", "Cherried"]:
			# Add the gravity.
			if not is_on_ceiling():
				velocity.y += -1 * gravity * delta

			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and (is_on_ceiling() or playerStatus == "Cherried"):
				if playerStatus == "Cherried":
					playerStatus = "Normal"
				velocity.y = -1 * JUMP_VELOCITY
				anim.play("Jump")
				
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction = Input.get_axis("ui_left", "ui_right")
			
			if direction == -1:
				get_node("AnimatedSprite2D").flip_h = true
			elif direction == 1:
				get_node("AnimatedSprite2D").flip_h = false
			if direction:
				velocity.x = direction * SPEED
				if velocity.y == 0:
					anim.play("Run")
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if velocity.y == 0:
					anim.play("Idle")
				
			if velocity.y < 0:
				anim.play("Fall")
		move_and_slide()
		
	if Game.playerHP <= 0:
		if $AnimationPlayer.current_animation != "Death":
			anim.play("Death")
			await anim.animation_finished
			get_tree().change_scene_to_file("res://main.tscn")

func _on_area_2d_body_entered(body):
	if "Frog" in body.name:
		if Game.playerHP > 0:
			playerStatus = "Hurt"
			var frogDirection = (body.position - self.position).normalized()
			anim.play("Hurt")
			if frogDirection.x > 0:
				velocity.x = -1 * SPEED / 1.5
				velocity.y = JUMP_VELOCITY / 5
			else:
				velocity.x = 1 * SPEED / 1.5
				velocity.y = JUMP_VELOCITY / 5
			
			await anim.animation_finished
			playerStatus = "Normal"


func _on_for_collectibles_area_entered(area):
	if "Cherry" in area.name:
		playerStatus = "Cherried"
	
	if "Banana" in area.name:
		if playerFlipped:
			playerFlipped = false
		else:
			playerFlipped = true
	if "Spike" in area.name:
		if Game.playerHP > 0:
			playerStatus = "Hurt"
			self.velocity.x = 0
			self.velocity.y = 0
			Game.playerHP -= 1
			anim.play("Hurt")
			await anim.animation_finished
			if area.name == "Spike1":
				self.position = Vector2(1300,625)
			elif area.name in ["Spike2"]:
				playerFlipped = false
				self.position = Vector2(1650,175)
			elif area.name in ["Spike3",]:
				playerFlipped = false
				self.position = Vector2(1900,175)
			playerStatus = "Normal"
