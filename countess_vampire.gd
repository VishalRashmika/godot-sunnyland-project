extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false

# Idle Animation For Countess
func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	


# Movement For Frog
func _physics_process(delta):
	# Gravity for frog
	velocity.y += gravity * delta
	
	
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Run")
		
		player = get_node("../../Player")
		
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = false
		else:
			get_node("AnimatedSprite2D").flip_h = true
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")		
		velocity.x = 0
	move_and_slide()
#"res://player.tscn"



func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase  = true 


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase  = false


func _on_enemy_vulnerable_body_entered(body):
	if body.name == "Player":
		death()


func _on_enemy_attack_body_entered(body):
	if body.name == "Player":
		Globalgamescript.player_health -= 1
		#print("countess glb scrip" + str(Globalgamescript.player_health))
		death()
	
func death():
	Globalgamescript.game_score += 5
	#Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free() # remove the countess

