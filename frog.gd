extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var player_health = 10

#Animation For Frog
func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	


# Movement For Frog
func _physics_process(delta):
	# Gravity for frog
	velocity.y += gravity * delta
	
	
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
		
		player = get_node("../../Player")

		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")		
		velocity.x = 0
	move_and_slide()
#"res://player.tscn"

# When Player Enter the Detection Area of the frog
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase  = true

# PLayer Killed The Enemy
func _on_enemy_vulnerable_body_entered(body):
	if body.name == "Player":
		death()

func death():
	Globalgamescript.game_score += 5
	#Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free() # remove the frog

# if the player exit the detection area of the frog
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false

# When Player Is attacked by the Frog
func _on_player_damage_body_entered(body):
	if body.name == "Player":
		#player_health -= 1
		#print(player_health)
		Globalgamescript.player_health -= 1
		#print("from glov script" + str(Globalgamescript.player_health))
		death()
