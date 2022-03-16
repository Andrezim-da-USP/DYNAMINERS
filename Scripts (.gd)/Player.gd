extends EntityBase

class_name Player

var direction:Vector2
var last_direction:Vector2
var idle:bool = true
var isAlive:bool = true
var movingVertically:bool
var movingHorizontally:bool
var estaAtacando:bool = false
var estaProtegidoDoGas:bool = false
var layerIndex:int = 5
#var bomba:Bomba

const MAX_HP_INITIAL_VALUE = 50
const HP_INITIAL_VALUE = 35
const TIME_GAS_MASK:int = 15
const BOMBA = preload("res://Scenes (.tscn)/Bomba.tscn")

onready var timerMascara = $Timer_Mascara as Timer
onready var canvasLayer:CanvasLayer = $GUI as CanvasLayer
onready var coinsLabel:Label = $GUI/VBoxContainer/Label as Label
onready var bombsLabel:Label = $GUI/VBoxContainer/Bombs as Label
onready var vida:TextureProgress = $GUI/Vida as TextureProgress
onready var vidaLabel:Label = $GUI/Vida/Label as Label
onready var vidaAnim:AnimationPlayer = $GUI/Vida/AnimationPlayer as AnimationPlayer
onready var animationFadeGasMask = $GUI/VBoxContainer/HBoxContainer/AnimationPlayer
onready var hBoxContainerGasMask = $GUI/VBoxContainer/HBoxContainer
onready var labelGasMask = $GUI/VBoxContainer/HBoxContainer/Label
onready var damageAnimation = $GUI/DamageRect/AnimationPlayer
onready var hitboxR = $HITBOX/RIGHT 
onready var hitboxL = $HITBOX/LEFT 
onready var hitboxU = $HITBOX/UP 
onready var hitboxD = $HITBOX/DOWN 

signal vida_mudou(variacao)
signal alterou_qtd_bomba(variacao)
signal coletou_moeda()
signal coletou_mascara_de_gas()
signal acabou_mascara_de_gas()

func _ready():
	var save_file:File = File.new()
	if not save_file.file_exists("res://Save_Load_Data/game_data.json"): return
	save_file.open("res://Save_Load_Data/game_data.json", File.READ)
	if save_file.get_len() == 0:
		set_max_hp(MAX_HP_INITIAL_VALUE)
		set_hp(HP_INITIAL_VALUE)
	else:
		while save_file.get_position() < save_file.get_len():
			var node_data:Dictionary = parse_json(save_file.get_line())
			if node_data["filename"] == "res://Scenes (.tscn)/Player.tscn":
				set_max_hp(node_data["max_hp"])
				set_hp(node_data["hp"])
				set_qtdBomba(node_data["qtd_bomba"])
				set_qtdMoeda(node_data["qtd_moeda"])
	save_file.close()
	vida.set_max(get_max_hp())
	vida.set_value(get_hp())
	vidaLabel.set_text(str(get_hp()) + "/" + str(get_max_hp()))
	coinsLabel.set_text("x" + str(get_qtdMoeda()) + " COINS")
	bombsLabel.set_text("x" + str(get_qtdBomba()) + " BOMBS")
	
func _physics_process(delta):
	if !estaAtacando: set_direction()
	movement(direction)
	animation(direction, last_direction, idle)
	put_bomb(self.global_position, last_direction)
	attack(last_direction)
	velocity = move_and_slide(velocity)
	
func save():
	var data:Dictionary = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"max_hp" : max_hp,
		"hp" : hp,
		"qtd_bomba" : qtdBomba,
		"qtd_moeda" : qtdMoeda
	}
	return data
	
func set_direction() -> void:
	if Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_released("ui_down") and direction.x == 0:
		direction = Vector2.ZERO
		
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	elif Input.is_action_just_released("ui_up") and direction.x == 0:
		direction = Vector2.ZERO
		
	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_just_released("ui_right") and direction.y == 0:
		direction = Vector2.ZERO
		
	if Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_released("ui_left") and direction.y == 0:
		direction = Vector2.ZERO
	
#	direction.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
#	direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
#
#	if direction.x != 0 and direction.y != 0:
#		if last_direction == Vector2.LEFT or last_direction == Vector2.RIGHT:
#			direction.x = 0
#			movingVertically = true
#		elif last_direction == Vector2.UP or last_direction == Vector2.DOWN:
#			direction.y = 0
#			movingHorizontally = true
#
#	if direction.y != 0:
#		movingVertically = true
#	else:
#		movingVertically = false
#
#	if direction.x !=0:
#		movingHorizontally = true
#	else:
#		movingHorizontally = false

	if direction != Vector2.ZERO:
		idle = false
	elif direction == Vector2.ZERO:
		idle = true
		
#	if movingVertically:
#		if direction.x != 0 and direction.y != 0: direction.y = 0
#	if movingHorizontally:
#		if direction.x != 0 and direction.y != 0: direction.x = 0

func movement(dir:Vector2) -> void:
	if !idle and !estaAtacando and isAlive:
		velocity = speed*dir
		last_direction = dir
	else:
		velocity = Vector2.ZERO
	pass
	
func animation(dir:Vector2, last_dir:Vector2, parado:bool) -> void:
	if !parado and !estaAtacando and isAlive:
		if dir == Vector2.UP:
			anim.play("runBack")
		elif dir == Vector2.DOWN:
			anim.play("runFront")
		elif dir == Vector2.RIGHT:
			anim.play("runSide")
			anim.flip_h = true
		elif dir == Vector2.LEFT:
			anim.play("runSide")
			anim.flip_h = false
	elif parado and !estaAtacando and isAlive:
		if last_dir == Vector2.DOWN:
			anim.play("idleFront")
		elif last_dir == Vector2.UP:
			anim.play("idleBack")
		elif last_dir == Vector2.RIGHT:
			anim.play("idleSide")
			anim.flip_h = true
		elif last_dir == Vector2.LEFT:
			anim.play("idleSide")
			anim.flip_h = false

func put_bomb(pos: Vector2, dir: Vector2) -> void:
	if Input.is_action_just_pressed("ui_accept") and qtdBomba  > 0 and isAlive:
		var incremento:Vector2 = dir * 70
		var bombaInst = BOMBA.instance()
		bombaInst.danoExtra = 500
		get_parent().add_child(bombaInst)
		bombaInst.global_position = pos + incremento
		emit_signal("alterou_qtd_bomba",-1)
	pass
	
func attack(dir:Vector2) -> void:
	if Input.is_action_just_pressed("click") and estaAtacando == false and isAlive:
		estaAtacando = true
		match dir:
			Vector2.RIGHT:
				anim.flip_h = false
				anim.play("attack.R")
				yield(anim,"animation_finished")
				estaAtacando = false
			Vector2.LEFT:
				anim.flip_h = false
				anim.play("attack.L")
				yield(anim,"animation_finished")
				estaAtacando = false
			Vector2.DOWN: 
				anim.flip_h = false
				anim.play("attack.D")
				yield(anim,"animation_finished")
				estaAtacando = false
			Vector2.UP:
				anim.flip_h = false
				anim.play("attack.U")
				yield(anim,"animation_finished")
				estaAtacando = false
	else:
		pass

func death() -> void:
	var new_scale:Vector2 = Vector2(1.75,1.75)
	isAlive = false
	collShape.set_disabled(true)
	anim.set_flip_h(false)
	match last_direction:
		Vector2.UP:
			anim.play("death.U")
			yield(anim,"animation_finished")
#			get_tree().reload_current_scene()
		Vector2.DOWN:
			anim.play("death.D")
			yield(anim,"animation_finished")
#			get_tree().reload_current_scene()
		Vector2.LEFT:
			anim.set_scale(new_scale)
			anim.play("death.L")
			yield(anim,"animation_finished")
#			get_tree().reload_current_scene()
		Vector2.RIGHT:
			anim.set_scale(new_scale)
			anim.play("death.R")
			yield(anim,"animation_finished")
#			get_tree().reload_current_scene()
	get_tree().reload_current_scene()
	
func _on_Player_vida_mudou(variacao:int) -> void:
#	var vida_texture:TextureProgress = get_parent().get_node("Camera/GUI/Vida")
#	var damageAnimation:AnimationPlayer = get_parent().get_node("GUI/VBoxContainer/HBoxContainer/AnimationPlayer")
	if hp <= 0: return
	set_hp(hp + variacao)
	vida.set_value(hp)
	if hp > 0:
		vidaLabel.set_text(str(hp) + "/" + str(max_hp))
	else: vidaLabel.set_text("0/" + str(max_hp))
	
	if variacao < 0:
		damageAnimation.play("Damage")
		if hp <= 0:
			self.death()
	if variacao > 0:
		vidaAnim.play("heal")
	pass # Replace with function body.

func _on_Player_coletou_moeda():
#	var label_moeda:Label = get_parent().get_node("GUI/VBoxContainer/Label")
	set_qtdMoeda(qtdMoeda+1)
	coinsLabel.set_text("x" + str(qtdMoeda) + " COINS")
	pass # Replace with function body.

func _on_Player_alterou_qtd_bomba(variacao:int)->void:
	set_qtdBomba(qtdBomba+variacao)
	bombsLabel.set_text("x" + str(qtdBomba) + " BOMBS")
	pass # Replace with function body.

func _on_Player_coletou_mascara_de_gas():
#	var hBoxContainerGasMask:HBoxContainer = get_parent().get_node("Player/Camera2D/GUI")
	estaProtegidoDoGas = true
	timerMascara.start()
	hBoxContainerGasMask.set_visible(true)
	labelGasMask.set_text(str(int(TIME_GAS_MASK)))
	pass # Replace with function body.

func _on_Timer_Mascara_timeout():
	if (TIME_GAS_MASK - int(labelGasMask.get_text()) == 15) and hBoxContainerGasMask.is_visible():
		estaProtegidoDoGas = false
		hBoxContainerGasMask.set_visible(false)
		emit_signal("acabou_mascara_de_gas")
	else: #TIME_GAS_MASK - int(labelGasMask.get_text()) > 0:
		labelGasMask.set_text(str(int(labelGasMask.get_text())-1))
		timerMascara.start()
	pass # Replace with function body.

func _on_AnimatedSprite_frame_changed():
	if estaAtacando == true:
		match last_direction:
			Vector2.UP:
				if anim.frame == 5:
					hitboxU.disabled = false
				elif anim.frame == 7:
					hitboxU.disabled = true
			Vector2.DOWN:
				if anim.frame == 5:
					hitboxD.disabled = false
				elif anim.frame == 7:
					hitboxD.disabled = true
			Vector2.RIGHT:
				if anim.frame == 5:
					hitboxR.disabled = false
				elif anim.frame == 7:
					hitboxR.disabled = true
			Vector2.LEFT:
				if anim.frame == 5:
					hitboxL.disabled = false
				elif anim.frame == 7:
					hitboxL.disabled = true
	pass # Replace with function body.

func _on_HITBOX_area_entered(area):
	if area.is_in_group("destrutivel"):
		area.get_parent().emit_signal("vida_mudou", $HITBOX.dano)

func _on_HBoxContainer_visibility_changed():
	if hBoxContainerGasMask.is_visible():
		animationFadeGasMask.play("Fade")
	else:
		animationFadeGasMask.stop()
	pass # Replace with function body.

func _on_Player_acabou_mascara_de_gas():
	collShape.set_disabled(true)
	collShape.set_disabled(false)
	pass # Replace with function body.
