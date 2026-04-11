extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)
signal died

@export var stats: CombatStats
@export var skill_1_scene: PackedScene
@export var skill_2_scene: PackedScene

@onready var animator: SheetAnimator = $Sprite2D
@onready var attack_area: Area2D = $AttackArea

var current_health := 0
var facing_direction := Vector2.DOWN
var attack_cooldown_remaining := 0.0
var skill_1_remaining := 0.0
var skill_2_remaining := 0.0
var _attack_lock := 0.0
var _hurt_lock := 0.0
var _is_dead := false


func _ready() -> void:
	add_to_group("player")
	current_health = stats.max_health
	health_changed.emit(current_health, stats.max_health)
	_update_attack_area()


func _physics_process(delta: float) -> void:
	_tick_cooldowns(delta)
	if _is_dead:
		return

	if Input.is_action_just_pressed("attack"):
		_try_attack()
	if Input.is_action_just_pressed("skill_1"):
		_try_skill_1()
	if Input.is_action_just_pressed("skill_2"):
		_try_skill_2()

	if _hurt_lock > 0.0:
		_hurt_lock -= delta
	if _attack_lock > 0.0:
		_attack_lock -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length_squared() > 0.0:
		facing_direction = input_vector.normalized()
		velocity = facing_direction * stats.move_speed
		if _hurt_lock <= 0.0:
			animator.play_animation("run", facing_direction)
	else:
		velocity = Vector2.ZERO
		if _hurt_lock <= 0.0:
			animator.play_animation("idle", facing_direction)

	_update_attack_area()
	move_and_slide()


func take_damage(amount: int) -> void:
	if _is_dead:
		return

	current_health = maxi(current_health - amount, 0)
	health_changed.emit(current_health, stats.max_health)
	if current_health <= 0:
		_die()
		return

	_hurt_lock = 0.18
	animator.play_animation("hurt", facing_direction, false, true)


func get_skill_1_remaining() -> float:
	return skill_1_remaining


func get_skill_2_remaining() -> float:
	return skill_2_remaining


func _try_attack() -> void:
	if attack_cooldown_remaining > 0.0:
		return

	attack_cooldown_remaining = stats.attack_cooldown
	_attack_lock = 0.22
	_update_attack_area()
	animator.play_animation("attack", facing_direction, false, true)

	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy) or not enemy.has_method("take_damage"):
			continue
		var enemy_node := enemy as Node2D
		if enemy_node == null:
			continue
		var to_enemy: Vector2 = enemy_node.global_position - global_position
		if to_enemy.length() > stats.attack_range:
			continue
		if to_enemy.normalized().dot(facing_direction) < -0.2:
			continue
		enemy.take_damage(stats.attack_damage)


func _try_skill_1() -> void:
	if skill_1_remaining > 0.0 or skill_1_scene == null:
		return

	skill_1_remaining = stats.skill_1_cooldown
	var projectile := skill_1_scene.instantiate()
	get_parent().add_child(projectile)
	if projectile.has_method("setup"):
		projectile.setup(global_position + facing_direction * 32.0, facing_direction)
	else:
		projectile.global_position = global_position + facing_direction * 32.0


func _try_skill_2() -> void:
	if skill_2_remaining > 0.0 or skill_2_scene == null:
		return

	skill_2_remaining = stats.skill_2_cooldown
	var burst := skill_2_scene.instantiate()
	get_parent().add_child(burst)
	burst.global_position = global_position + facing_direction * 48.0
	animator.play_animation("attack", facing_direction, false, true)


func _tick_cooldowns(delta: float) -> void:
	attack_cooldown_remaining = maxf(attack_cooldown_remaining - delta, 0.0)
	skill_1_remaining = maxf(skill_1_remaining - delta, 0.0)
	skill_2_remaining = maxf(skill_2_remaining - delta, 0.0)


func _update_attack_area() -> void:
	attack_area.position = facing_direction.normalized() * (stats.attack_range * 0.5)


func _die() -> void:
	_is_dead = true
	velocity = Vector2.ZERO
	animator.play_animation("death", facing_direction, false, true)
	died.emit()
