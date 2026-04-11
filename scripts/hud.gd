extends CanvasLayer

@onready var health_label: Label = $Root/StatusPanel/MarginContainer/VBoxContainer/HealthLabel
@onready var skill_label: Label = $Root/StatusPanel/MarginContainer/VBoxContainer/SkillLabel
@onready var wave_label: Label = $Root/StatusPanel/MarginContainer/VBoxContainer/WaveLabel
@onready var objective_label: Label = $Root/StatusPanel/MarginContainer/VBoxContainer/ObjectiveLabel
@onready var pause_panel: PanelContainer = $Root/PausePanel
@onready var result_panel: PanelContainer = $Root/ResultPanel
@onready var result_label: Label = $Root/ResultPanel/MarginContainer/VBoxContainer/ResultLabel
@onready var summary_label: Label = $Root/ResultPanel/MarginContainer/VBoxContainer/SummaryLabel


func _ready() -> void:
	set_pause_visible(false)
	set_result_visible(false)


func set_health(current_health: int, max_health: int) -> void:
	health_label.text = "HP %d / %d" % [current_health, max_health]


func set_skills(skill_1_remaining: float, skill_2_remaining: float) -> void:
	var skill_1_text := "Ready" if skill_1_remaining <= 0.0 else "%.1fs" % skill_1_remaining
	var skill_2_text := "Ready" if skill_2_remaining <= 0.0 else "%.1fs" % skill_2_remaining
	skill_label.text = "Skill 1 %s | Skill 2 %s" % [skill_1_text, skill_2_text]


func set_wave(current_wave: int, total_waves: int, remaining_enemies: int) -> void:
	wave_label.text = "Wave %d / %d | Enemies %d" % [current_wave, total_waves, remaining_enemies]


func set_objective(text: String) -> void:
	objective_label.text = text


func set_pause_visible(is_visible: bool) -> void:
	pause_panel.visible = is_visible


func set_result_visible(is_visible: bool) -> void:
	result_panel.visible = is_visible


func set_result(text: String, defeated_enemies := 0, elapsed_time := 0.0) -> void:
	result_label.text = text
	summary_label.text = "Defeated %d | Time %.1fs | Press E to restart" % [defeated_enemies, elapsed_time]
	set_result_visible(true)
