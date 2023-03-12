extends RigidBody2D

export var STYRING = 50.0
export var HASTIGHED = 10.0
export var FRIKTION = 2.0

export var ZOOM = 0.5

var kugle_scene = preload("res://Kugle.tscn")

var timer = 0
var sidst_skudt = 0
var TID_MELLEM_SKUD = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	input_key()
	bil_kamera()
	timer += delta
	
func input_key():
	if Input.is_action_pressed("Venstre"):
		apply_torque_impulse(-STYRING)
	if Input.is_action_pressed("Hoejre"):
		apply_torque_impulse(STYRING)
	if Input.is_action_pressed("Frem"):
		apply_central_impulse(Vector2(0, -HASTIGHED).rotated(rotation))
	if Input.is_action_pressed("Bak"):
		apply_central_impulse(Vector2(0, HASTIGHED).rotated(rotation))
	if Input.is_action_pressed("Skyd"):
		skyd()
		
	linear_damp = FRIKTION
	angular_damp = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#bil_kamera()

func bil_kamera():
	var zoomFaktor = ZOOM + linear_velocity.length() / 1000
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(zoomFaktor, zoomFaktor), 0.01)


func _on_Start_body_entered(body):
	if body.is_in_group('Spiller'):
		var root = get_node("/root/Racerspil")
		root.start_passeret()

func _on_Olieplet_body_entered(body):
	if body.is_in_group('Spiller'):
		apply_central_impulse(Vector2(0, -300).rotated(rotation))
		apply_torque_impulse(5000.0)
		
func skyd():
	if sidst_skudt == 0 || timer > sidst_skudt + TID_MELLEM_SKUD:
		var b = kugle_scene.instance()
		owner.add_child(b)
		b.transform = $SkudPosition.global_transform
		sidst_skudt = timer
