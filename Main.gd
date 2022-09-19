extends Node

export(PackedScene) var mob_scene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()

func new_game():
	score = 0
	get_tree().call_group("mobs","queue_free")
	$Music.play()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	
	


func _on_MobTimer_timeout():
	#Create a new instance of Mob
	var mob = mob_scene.instance()
	
	#Choose a random location along Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	#set mob's direction perpendicular to path
	var direction = mob_spawn_location.rotation + PI / 2
	
	#set mob's position to random location
	mob.position = mob_spawn_location.position
	
	#add randomness to direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#mob velocity
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn mob
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
