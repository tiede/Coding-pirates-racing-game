extends RigidBody2D

var antal_skud = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ramt():
	antal_skud += 1
	
	if antal_skud == 1:
		$Sprite.texture = load("res://Grafik/Objekter/cone_down.png")
	else:
		#visible = false
		queue_free()
