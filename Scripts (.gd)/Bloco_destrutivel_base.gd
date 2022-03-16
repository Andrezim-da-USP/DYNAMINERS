extends StaticBody2D

class_name BlocoDestrutivelBase

onready var sprite = get_node("Sprite")
onready var collShape = get_node("CollisionShape2D")
onready var textureProgress = get_node("TextureProgress")

export(int) var vida:int = 10 setget set_vida, get_vida

signal vida_mudou(variacao)

func _ready():
	textureProgress.set_max(get_vida())
	textureProgress.set_value(get_vida())
	
func bloco_destruido() -> void:
	self.queue_free()

func _on_Bloco_destrutivel_base_vida_mudou(variacao:int):
	var nova_vida = vida-variacao
	set_vida(nova_vida)
	textureProgress.value = nova_vida
	if nova_vida > 0:
		pass
	else:
		self.bloco_destruido()

func set_vida(valor:int):
	vida = valor

func get_vida():
	return vida
