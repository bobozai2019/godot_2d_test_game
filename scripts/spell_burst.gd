extends Area2D

@export var damage := 35
@export var knockback_force := 180.0
@export var lifetime := 0.28

var _age := 0.0
var _hit_enemies: Array[Node] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	for body in get_overlapping_bodies():
		_on_body_entered(body)


func _process(delta: float) -> void:
	_age += delta
	scale = Vector2.ONE * lerpf(0.5, 1.2, minf(_age / lifetime, 1.0))
	modulate.a = lerpf(0.9, 0.0, minf(_age / lifetime, 1.0))
	if _age >= lifetime:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies") or body in _hit_enemies:
		return

	_hit_enemies.append(body)
	var away := (body.global_position - global_position).normalized()
	if body.has_method("apply_knockback"):
		body.apply_knockback(away * knockback_force)
	if body.has_method("take_damage"):
		body.take_damage(damage)

