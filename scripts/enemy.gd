extends CharacterBody2D

signal died(enemy: Node)

@export var stats: CombatStats
@export var target_path: NodePath

@onready var animator: SheetAnimator = $Sprite2D

var current_health := 0
var facing_direction := Vector2.DOWN
var attack_cooldown_remaining := 0.0
var _attack_lock := 0.0
var _hurt_lock := 0.0
var _is_dead := false
var _target: Node2D


func _ready() -> void:
	add_to_group("enemies")
	current_health = stats.max_health
	if not target_path.is_empty():
		_target = get_node_or_null(target_path)


func set_target(target: Node2D) -> void:
	_target = target


func take_damage(amount: int) -> void:
	if _is_dead:
		return

	current_health = maxi(current_health - amount, 0)
	if current_health <= 0:
		_die()
		return

	_hurt_lock = 0.16
	animator.play_animation("hurt", facing_direction, false, true)


func _physics_process(delta: float) -> void:
	attack_cooldown_remaining = maxf(attack_cooldown_remaining - delta, 0.0)
	if _is_dead:
		return
	if not is_instance_valid(_target):
		_find_player()
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if _hurt_lock > 0.0:
		_hurt_lock -= delta
	if _attack_lock > 0.0:
		_attack_lock -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_target := _target.global_position - global_position
	if to_target.length_squared() > 0.0:
		facing_direction = to_target.normalized()

	if to_target.length() <= stats.attack_range:
		velocity = Vector2.ZERO
		_try_attack()
	else:
		velocity = facing_direction * stats.move_speed
		if _hurt_lock <= 0.0:
			animator.play_animation("run", facing_direction)

	move_and_slide()


func _try_attack() -> void:
	if attack_cooldown_remaining > 0.0:
		if _hurt_lock <= 0.0:
			animator.play_animation("idle", facing_direction)
		return

	attack_cooldown_remaining = stats.attack_cooldown
	_attack_lock = 0.24
	animator.play_animation("attack", facing_direction, false, true)
	if is_instance_valid(_target) and _target.has_method("take_damage"):
		_target.take_damage(stats.attack_damage)


func _find_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_target = players[0]


func _die() -> void:
	_is_dead = true
	velocity = Vector2.ZERO
	remove_from_group("enemies")
	animator.play_animation("death", facing_direction, false, true)
	died.emit(self)
	await get_tree().create_timer(0.55).timeout
	queue_free()

