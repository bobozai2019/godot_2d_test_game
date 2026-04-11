extends Node2D

signal wave_changed(current_wave: int, total_waves: int, remaining_enemies: int)
signal all_waves_cleared

@export var enemy_scene: PackedScene
@export var target_path: NodePath
@export var spawn_points: Array[NodePath] = []
@export var wave_sizes: Array[int] = [3, 5]

var current_wave := 0
var remaining_enemies := 0
var _target: Node2D


func _ready() -> void:
	if not target_path.is_empty():
		_target = get_node_or_null(target_path)


func start() -> void:
	current_wave = 0
	_spawn_next_wave()


func _spawn_next_wave() -> void:
	if current_wave >= wave_sizes.size():
		all_waves_cleared.emit()
		return

	current_wave += 1
	remaining_enemies = wave_sizes[current_wave - 1]
	for index in range(remaining_enemies):
		var enemy := enemy_scene.instantiate()
		enemy.global_position = _get_spawn_position(index)
		if enemy.has_method("set_target") and is_instance_valid(_target):
			enemy.set_target(_target)
		enemy.died.connect(_on_enemy_died)
		get_parent().add_child(enemy)

	wave_changed.emit(current_wave, wave_sizes.size(), remaining_enemies)


func _on_enemy_died(_enemy: Node) -> void:
	remaining_enemies = maxi(remaining_enemies - 1, 0)
	wave_changed.emit(current_wave, wave_sizes.size(), remaining_enemies)
	if remaining_enemies <= 0:
		_spawn_next_wave()


func _get_spawn_position(index: int) -> Vector2:
	if spawn_points.is_empty():
		return global_position

	var marker := get_node_or_null(spawn_points[index % spawn_points.size()]) as Node2D
	if marker == null:
		return global_position
	return marker.global_position
