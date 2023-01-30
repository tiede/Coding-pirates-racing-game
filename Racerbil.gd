extends RigidBody2D

var STYRING = 50.0
var HASTIGHED = 5.0
var FRIKTION = 2.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	input_key()
	
func input_key():
	if Input.is_action_pressed("Venstre"):
		apply_torque_impulse(-STYRING)
	if Input.is_action_pressed("Hoejre"):
		apply_torque_impulse(STYRING)
	if Input.is_action_pressed("Frem"):
		apply_central_impulse(Vector2(0, -HASTIGHED).rotated(rotation))
	if Input.is_action_pressed("Bak"):
		apply_central_impulse(Vector2(0, HASTIGHED).rotated(rotation))
		
	linear_damp = FRIKTION
	angular_damp = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
