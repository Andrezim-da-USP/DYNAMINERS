extends EntityBase

class_name Player

var direction:Vector2
var last_direction: Vector2
var idle:bool = true
var movingVertically: bool
var estaProtegidoDoGas:bool = false
const BOMBA = preload("res://Scenes (.tscn)/Bomba.tscn")

onready var timerMascara = $Timer_Mascara
onready var label = $Label

signal vida_mudou(variacao)
signal alterou_qtd_bomba(variacao)
signal coletou_moeda()
signal coletou_mascara_de_gas()

func _ready():
	set_hp(30)

func _physics_process(delta):
	set_direction()
	movement(direction)
	animation(direction, last_direction, idle)
	put_bomb(self.global_position, last_direction)
	
	velocity = move_and_slide(velocity)
	
func set_direction() -> void:
	direction.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	
	if direction.y != 0:
		movingVertically = true
	else:
		movingVertically = false
		
	if direction != Vector2.ZERO:
		idle = false
	elif direction == Vector2.ZERO:
		idle = true
		
	if direction.x != 0 and direction.y != 0:
		if movingVertically:
			direction.x = 0
		else:
			direction.y = 0
		pass	

func movement(dir:Vector2) -> void:
	if !idle:
		velocity = speed*dir
		last_direction = dir
	else:
		velocity = Vector2.ZERO
	pass
	
func animation(dir:Vector2, last_dir:Vector2, parado:bool) -> void:
	if !parado:
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
	elif parado:
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
	if Input.is_action_just_pressed("ui_accept") and qtdBomba > 0:
		var incremento = dir * 60
		var bomba = BOMBA.instance()
		get_parent().add_child(bomba)
		bomba.global_position = pos + incremento
		emit_signal("alterou_qtd_bomba",-1)
	pass

func _on_Player_vida_mudou(variacao) -> void:
	set_hp(hp + variacao)
	pass # Replace with function body.

func _on_Player_coletou_moeda():
	set_qtdMoeda(qtdMoeda+1)
	label.text = "x" + str(qtdMoeda) + " COINS"
	pass # Replace with function body.

func _on_Player_alterou_qtd_bomba(variacao):
	set_qtdBomba(qtdBomba+variacao)
	pass # Replace with function body.

func _on_Player_coletou_mascara_de_gas():
	estaProtegidoDoGas = true
	timerMascara.start()
	pass # Replace with function body.

func _on_Timer_Mascara_timeout():
	estaProtegidoDoGas = false
	pass # Replace with function body.
