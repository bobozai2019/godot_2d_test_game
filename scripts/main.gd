extends Node2D

@onready var player = $Player
@onready var hud = $HUD
@onready var enemy_spawner = $EnemySpawner

var defeated_enemies := 0
var _start_msec := 0
var _is_finished := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.health_changed.connect(hud.set_health)
	player.died.connect(_on_player_died)
	enemy_spawner.wave_changed.connect(hud.set_wave)
	enemy_spawner.enemy_defeated.connect(_on_enemy_defeated)
	enemy_spawner.all_waves_cleared.connect(_on_all_waves_cleared)
	hud.set_health(player.current_health, player.stats.max_health)
	hud.set_objective("Defeat the slimes")
	_start_msec = Time.get_ticks_msec()
	enemy_spawner.start()


func _process(_delta: float) -> void:
	hud.set_skills(player.get_skill_1_remaining(), player.get_skill_2_remaining())
	if Input.is_action_just_pressed("pause") and not _is_finished:
		_set_paused(not get_tree().paused)
	if Input.is_action_just_pressed("interact") and _is_finished:
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_enemy_defeated(total_defeated: int) -> void:
	defeated_enemies = total_defeated


func _on_player_died() -> void:
	_finish_run("Defeat")


func _on_all_waves_cleared() -> void:
	_finish_run("Victory")


func _finish_run(result_text: String) -> void:
	_is_finished = true
	hud.set_pause_visible(false)
	hud.set_result(result_text, defeated_enemies, _get_elapsed_time())
	get_tree().paused = true


func _set_paused(is_paused: bool) -> void:
	get_tree().paused = is_paused
	hud.set_pause_visible(is_paused)


func _get_elapsed_time() -> float:
	return float(Time.get_ticks_msec() - _start_msec) / 1000.0
