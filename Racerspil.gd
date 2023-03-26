extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var check_for_snyd = true

var omgangstid = 0
var omgang = 0
var omgangstider = []
var mellemtider_passeret = 0

var FIL_NAVN_HI_SCORE_OMGANGSTID = "user://racing-hi-score-omgangstid.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gameover.visible = false

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

func hent_hi_score_fra_fil():
	var hi_score_fil = File.new()
	if not hi_score_fil.file_exists(FIL_NAVN_HI_SCORE_OMGANGSTID):
		return -1
	else:
		hi_score_fil.open(FIL_NAVN_HI_SCORE_OMGANGSTID, File.READ)
		return hi_score_fil.get_float()
