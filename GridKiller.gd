extends RigidBody2D

var player = null
var frameCounter = 0  # Initialize a variable to keep track of the frame count.
var pixelSize = 32
var numFrames = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("killer")
	$AnimationPlayer.play("Idle")
	
func _process(delta):
	if player == null:
		return
	frameCounter += 1
	# Check if the frame counter has reached 5 (or any desired frame interval).
	if frameCounter >= numFrames:
		frameCounter = 0  # Reset the frame counter.
		movement_function()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func movement_function():
	var move = Vector2.ZERO
	var vec =  player.global_position - global_position
	print("POSITION", global_position)
	print("VEC ", vec)
	if(abs(vec.x) > abs(vec.y)):
		if(vec.x < 0):
			move.x -= pixelSize
			$AnimationPlayer.play("WalkLeft")
			print("LEFT")
		else:
			move.x += pixelSize
			$AnimationPlayer.play("WalkRight")
			print("RIGHT")
			
	else:
		if(vec.y < 0):
			move.y -= pixelSize
			$AnimationPlayer.play("WalkUp")
			print("UP")
		else:
			move.y += pixelSize
			$AnimationPlayer.play("WalkDown")
			print("DOWN")
	print("MOVE ", move)
	move_and_collide(move)
	

func set_player(p):
	player = p
	print(player)
