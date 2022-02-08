extends KinematicBody2D

class_name EntityBase

export(int) var hp:float   setget set_hp, get_hp
export(int) var speed:float = 300 setget set_speed, get_speed
var velocity:Vector2 = Vector2.ZERO
var qtdMoeda:int setget set_qtdMoeda, get_qtdMoeda
var qtdBomba:int setget set_qtdBomba, get_qtdBomba

onready var anim = $AnimatedSprite
onready var collShape = $CollisionShape2D

func _ready():
	pass
	
func _physics_process(delta):
	pass
func set_hp(value: float) -> void:
	hp = value
func get_hp() -> float:
	return hp
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
