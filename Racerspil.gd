extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var check_for_snyd = true

var omgangstid = 0
var omgang = 0
var omgangstider = []
var mellemtider_passeret = 0
var start_taeller = 3

var FIL_NAVN_HI_SCORE_OMGANGSTID = "user://racing-hi-score-omgangstid.txt"

var kegle_scene = preload("res://Kegle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gameover.visible = false
	$NyHiScore.visible = false
	
	start_nedtaelling(str(3))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	omgangstid += delta
	if omgang == 1:
		$HUD/Omgang1.text = 'Omgang 1: ' + hent_omgangstid(omgangstid)
	elif omgang == 2:
		$HUD/Omgang2.text = 'Omgang 2: ' + hent_omgangstid(omgangstid)
	elif omgang == 3:
		$HUD/Omgang3.text = 'Omgang 3: ' + hent_omgangstid(omgangstid)

func start_passeret():
	if omgang == 0:
		omgang = 1
	else:
		if check_snyd():
			omgang = omgang + 1
			omgangstider.push_back(omgangstid)
			omgangstid = 0
			mellemtider_passeret = 0
		else:
			print_debug('start passeret men mellemtider ikke passeret. Snyder du?')
	
	spawn_forhindringer()
	print('start passeret')
	
	if omgang > 3:
		game_over()

func hent_omgangstid(omgangstid):
	return str(omgangstid).pad_zeros(3).left(7)

func _on_Start_pressed():
	get_tree().reload_current_scene()

func _on_Mellemtid1_body_entered(body):
	mellemtid_passeret(body)

func _on_Mellemtid2_body_entered(body):
	mellemtid_passeret(body)

func _on_Mellemtid3_body_entered(body):
	mellemtid_passeret(body)

func check_snyd():
	if check_for_snyd:
		return mellemtider_passeret >= 3
	
	return true
	

func mellemtid_passeret(body):
	if body.is_in_group('Spiller'):
		mellemtider_passeret += 1
		print ("Mellemtider passeret " + str(mellemtider_passeret))

func game_over():
	$Gameover.visible = true
	var omgangstider_text = "Omgang 1 : " + hent_omgangstid(omgangstider[0]) + "\n"
	omgangstider_text += "Omgang 2 : " + hent_omgangstid(omgangstider[1]) + "\n"
	omgangstider_text += "Omgang 3 : " + hent_omgangstid(omgangstider[2])
	
	var total_tid = omgangstider[0] + omgangstider[1] + omgangstider[2]
	
	$Gameover/Tider.text = omgangstider_text + "\n" + "Total tid : " + hent_omgangstid(total_tid) 
	
	# Save to file
	gem_hi_score_i_fil()	

func hent_hurtigste_omgang():
	var hurtigste_omgangstid = omgangstider[0]
	for omgangstid in omgangstider:
		if omgangstid < hurtigste_omgangstid:
			hurtigste_omgangstid = omgangstid
			
	return hurtigste_omgangstid

func gem_hi_score_i_fil():
	var gemt_hi_score = hent_hi_score_fra_fil()
	var hurtigste_omgang = hent_hurtigste_omgang()
	
	if (gemt_hi_score == -1 || hurtigste_omgang < gemt_hi_score):
		var hi_score_fil = File.new()
		hi_score_fil.open(FIL_NAVN_HI_SCORE_OMGANGSTID, File.WRITE)
		hi_score_fil.store_float(hurtigste_omgang)
		hi_score_fil.close()
		
		hi_score_slaaet(hurtigste_omgang, gemt_hi_score)

func hent_hi_score_fra_fil():
	var hi_score_fil = File.new()
	if not hi_score_fil.file_exists(FIL_NAVN_HI_SCORE_OMGANGSTID):
		return -1
	else:
		hi_score_fil.open(FIL_NAVN_HI_SCORE_OMGANGSTID, File.READ)
		return hi_score_fil.get_float()

func hi_score_slaaet(ny_hi_score, gammel_hi_score):
	$AnimationPlayerVisHiScore.play("Vis hiscore")
	$NyHiScore/Label.text = $NyHiScore/Label.text % [str(ny_hi_score), str(gammel_hi_score)]
	 
	$NyHiScore.visible = true

func start_nedtaelling(text):
	$StartSpil/LabelNedtaelling.text = text
	$AnimationPlayerVisStartSpil.play("Start nedtaelling")
	$AnimationPlayerVisStartSpil.connect("animation_finished", self, "_on_nedtaelling_animation_ended")
	
func _on_nedtaelling_animation_ended(anim_name):
	start_taeller = start_taeller - 1
	
	if (start_taeller == -1):
		start_spil()
	elif (start_taeller == 0):
		start_nedtaelling("GO!")
	else:
		start_nedtaelling(str(start_taeller))
	
func start_spil():
	$StartSpil.visible = false
	$Racerbil.spil_startet()

func spawn_forhindringer():
	# Find 5 random spawn punkter
	var brugte_numre = []
	var kegler_placeret = 0
	while (kegler_placeret <= 5):		
		var rand = randi()%10+1
		if (!brugte_numre.has(rand)):
			brugte_numre.append(rand)
			spawn_forhindring(rand)
			kegler_placeret = kegler_placeret + 1

func spawn_forhindring(spawn_position):
	print_debug("Checker kegle i " + str(spawn_position))
	for barn in $Forhindringer.get_children():
		var spawn_punkt_navn = "Spawn" + str(spawn_position)
		if (barn.name == spawn_punkt_navn):
			print_debug("Laver kegle i " + spawn_punkt_navn)
			var kegle = lav_kegle(barn.global_transform)
			add_child(kegle)

func lav_kegle(transform):
	var kegle = kegle_scene.instance()
	kegle.add_to_group("Forhindring")
	kegle.transform = transform
	return kegle
