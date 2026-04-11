extends Area2D

@export var speed := 360.0
@export var damage := 18
@export var lifetime := 1.2
@export var slow_duration := 1.0
@export var slow_multiplier := 0.55

var direction := Vector2.RIGHT
var _age := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	rotation = direction.angle()


func setup(spawn_position: Vector2, cast_direction: Vector2) -> void:
	global_position = spawn_position
	direction = cast_direction.normalized() if cast_direction.length_squared() > 0.0 else Vector2.RIGHT
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	_age += delta
	if _age >= lifetime:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
	if body.has_method("apply_slow"):
		body.apply_slow(slow_multiplier, slow_duration)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
