extends Node


var hp:int = 20 setget set_hp, get_hp
var max_hp:int = 50 setget set_max_hp, get_max_hp

func set_hp(value:int) -> void:
	hp = value
	if hp > max_hp:
		hp = max_hp
func get_hp() -> int:
	return hp
func set_max_hp(value:int) -> void:
	max_hp = value
func get_max_hp() -> int:
	return max_hp
