extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_dialog = Dialogic.start('level_3')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Dialogic.VAR.nextScene == true:
		Dialogic.VAR.nextScene = false
		get_tree().change_scene_to_file("res://DialogueReal/Scenes/ending_comic_scene.tscn")
	pass
