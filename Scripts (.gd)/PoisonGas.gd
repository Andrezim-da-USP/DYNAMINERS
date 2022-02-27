extends Area2D

export var damage:int = -5
var exited:bool = false

func _ready():
	pass # Replace with function body.

func _on_PoisonGas_body_entered(body:Player)->void:
	if not body:
		return
	exited = false
	deal_damage(body,damage)

func deal_damage(player:Player, dano:int)->void:
	if not player:
		return
	if player.estaProtegidoDoGas:
		pass
	else:
		player.emit_signal("vida_mudou", dano)
		yield(get_tree().create_timer(1.0),"timeout")
		if !player.estaProtegidoDoGas and !exited:
			deal_damage(player,dano)

func _on_PoisonGas_body_exited(body:Player)->void:
	if not body:
		return
	exited = true
	pass # Replace with function body.
