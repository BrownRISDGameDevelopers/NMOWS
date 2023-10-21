extends RigidBody2D


var frameCounter = 0  # Initialize a variable to keep track of the frame count.
var dir = 0
var pixelSize = 32
var numFrames = 20

var hiding = false
var visionBlockerSizeNormal = 0.3
var visionBlockerSizeHiding = 0.15
var visionBlockerSizeChangeSpeed = 0.0003
var visionBlocker
var popupText

var in_hiding_range
var preHideLocation
var hideLocation


var canMove


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	get_tree().call_group("killer", "set_player", self)
	visionBlocker = get_node("VisionBlocker")
	popupText = get_node("Label")
	in_hiding_range = false
	canMove = true
	popupText.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func movement_function():
	if not canMove:
		return
		
	var direction = Vector2.ZERO

	if dir == 0: 
		$AnimationPlayer.play("WalkRight")
		direction.x += pixelSize
	if dir == 1:
		$AnimationPlayer.play("WalkLeft")
		direction.x -= pixelSize
	if dir == 2: 
		$AnimationPlayer.play("WalkDown")
		direction.y += pixelSize
	if dir == 3:
		$AnimationPlayer.play("WalkUp")
		direction.y -= pixelSize

	move_and_collide(direction)


func _input(event):
	if event.is_action_pressed("interact"):
		if in_hiding_range and not hiding:
			hide_player()
		elif in_hiding_range and hiding:
			unhide_player()

func _process(delta):
	frameCounter += 1
	
	# Check if the frame counter has reached 5 (or any desired frame interval).
	if frameCounter >= numFrames:
		frameCounter = 0  # Reset the frame counter.
		movement_function()
	if Input.is_action_pressed("move_right"):
		dir = 0
	elif Input.is_action_pressed("move_left"):
		dir = 1
	elif Input.is_action_pressed("move_down"):
		dir = 2
	elif Input.is_action_pressed("move_up"):
		dir = 3
	else:
		dir = 4
		
	if hiding:
		var currsize = visionBlocker.scale
		currsize.x = max(currsize.x - visionBlockerSizeChangeSpeed, visionBlockerSizeHiding)
		currsize.y = max(currsize.y - visionBlockerSizeChangeSpeed, visionBlockerSizeHiding)
		visionBlocker.scale = currsize
	else:
		var currsize = visionBlocker.scale
		currsize.x = min(currsize.x + visionBlockerSizeChangeSpeed, visionBlockerSizeNormal)
		currsize.y = min(currsize.y + visionBlockerSizeChangeSpeed, visionBlockerSizeNormal)
		visionBlocker.scale = currsize
		
	
		
func hide_player():
	get_node("CollisionShape2D").disabled = true
	preHideLocation = global_position
	global_position = hideLocation
	print("Transporting into hiding position")
	print(hideLocation)
	hiding = not hiding
	get_tree().call_group("killer", "set_hiding", hiding)
	# disable movement and rendering
	canMove = false
	get_node("Sprite2D").visible = false
	popupText.text = "Press E to unhide"

func unhide_player():
	get_node("CollisionShape2D").disabled = false
	global_position = Vector2(preHideLocation.x, preHideLocation.y)
	print("Transporting to Prehide:")
	print(Vector2(preHideLocation.x, preHideLocation.y))
	hiding = not hiding
	get_tree().call_group("killer", "set_hiding", hiding)
	# enable movement and rendering
	canMove = true
	get_node("Sprite2D").visible = true
	popupText.text = "Press E to hide"
	

func _on_interaction_range_body_entered(body):
	print("Entering")
	if (body.name.substr(0, 8) == "hideable"):
		print("EnteringHideable")
		in_hiding_range = true
		hideLocation = body.global_position
		popupText.visible = true
		popupText.text = "Press E to hide"
		
		


func _on_interaction_range_body_exited(body):
	print("Exiting")
	if (body.name.substr(0, 8) == "hideable"):
		print("ExitingHideable")
		in_hiding_range = false
		popupText.visible = false
		

func _integrate_forces(state):
	rotation = 0 # prevent player from rotating