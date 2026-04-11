extends Node2D

@onready var player = $Player
@onready var hud = $HUD
@onready var enemy_spawner = $EnemySpawner


func _ready() -> void:
	player.health_changed.connect(hud.set_health)
	player.died.connect(_on_player_died)
	enemy_spawner.wave_changed.connect(hud.set_wave)
	enemy_spawner.all_waves_cleared.connect(_on_all_waves_cleared)
	hud.set_health(player.current_health, player.stats.max_health)
	hud.set_result("Defeat the slimes")
	enemy_spawner.start()


func _process(_delta: float) -> void:
	hud.set_skills(player.get_skill_1_remaining(), player.get_skill_2_remaining())


func _on_player_died() -> void:
	hud.set_result("Defeat")
	get_tree().paused = true


func _on_all_waves_cleared() -> void:
	hud.set_result("Victory")
