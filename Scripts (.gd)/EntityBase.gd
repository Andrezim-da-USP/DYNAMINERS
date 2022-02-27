extends KinematicBody2D

class_name EntityBase

export(int) var hp:int   setget set_hp, get_hp
export(int) var max_hp:int setget set_max_hp, get_max_hp
export(int) var speed:float = 300 setget set_speed, get_speed
var velocity:Vector2 = Vector2.ZERO
var qtdMoeda:int setget set_qtdMoeda, get_qtdMoeda
var qtdBomba:int = 2 setget set_qtdBomba, get_qtdBomba

onready var anim = $AnimatedSprite
onready var collShape = $CollisionShape2D

func _ready():
	pass
	
func _physics_process(delta):
	pass
func set_hp(value:int) -> void:
	hp = value
func get_hp() -> int:
	return hp
func set_max_hp(value:int) -> void:
	max_hp = value
func get_max_hp() -> int:
	return max_hp
func set_speed(value: float) -> void:
	speed = value	
func get_speed() -> float:
	return speed
func set_qtdMoeda(value) -> void:
	qtdMoeda = value
func get_qtdMoeda() -> int:
	return qtdMoeda
func set_qtdBomba(value)->void:
	qtdBomba = value
func get_qtdBomba() -> int:
	return qtdBomba
