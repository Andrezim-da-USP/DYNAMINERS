extends KinematicBody2D

class_name Bomba

export(int) var explosionTime:int = 3
export(int) var danoBase:int = 5
export(int) var danoExtra:int = 10
var initial_scale:Vector2 = Vector2(.3,.3)
var final_scale:Vector2 = Vector2(10,10)

onready var timer:Timer = get_node("Timer") as Timer
onready var area:Area2D = get_node("Area2D") as Area2D
onready var collisionArea:CollisionShape2D = get_node("Area2D/CollisionShape2D") as CollisionShape2D
onready var sprite:AnimatedSprite = get_node("AnimatedSprite") as AnimatedSprite

func _ready():
	sprite.set_scale(initial_scale)
	timer.start(explosionTime)

func explode()->void:
	collisionArea.set_disabled(false)
	sprite.play("explosion")	
	sprite.set_scale(final_scale)
	yield(sprite,"animation_finished")
	self.queue_free()
	
func _on_Timer_timeout()->void:
	explode()

func _on_Area2D_body_entered(body:BlocoDestrutivelBase)->void:
	if not body: return
	body.emit_signal("vida_mudou",self.danoBase + self.danoExtra)

func _on_Area2D_area_entered(area:Area2D):
	if not area: return
	if area.is_in_group("Player"):
		area.get_parent().emit_signal("vida_mudou",-danoBase-danoExtra)
	
