extends Area2D

class_name HITBOX

export(int) var dano:int setget set_dano, get_dano

onready var collShape = get_node("CollisionShape2D")

func set_dano(valor):
	dano = valor

func get_dano():
	return dano

func ligar_hitbox():
	collShape.disabled = false
	
func desligar_hitbox():
	collShape.disabled = true
