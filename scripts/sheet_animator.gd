@tool
class_name SheetAnimator
extends Sprite2D

const FRAME_SIZE := Vector2i(64, 64)

@export var idle_texture: Texture2D
@export var run_texture: Texture2D
@export var attack_texture: Texture2D
@export var hurt_texture: Texture2D
@export var death_texture: Texture2D
@export var frames := {
	"idle": 6,
	"run": 8,
	"attack": 8,
	"hurt": 5,
	"death": 7,
}
@export var fps := 10.0
@export_group("Direction Rows")
@export_range(0, 16, 1, "or_greater") var up_row := 0:
	set(value):
		up_row = value
		_refresh_editor_preview()
@export_range(0, 16, 1, "or_greater") var down_row := 1:
	set(value):
		down_row = value
		_refresh_editor_preview()
@export_range(0, 16, 1, "or_greater") var left_row := 2:
	set(value):
		left_row = value
		_refresh_editor_preview()
@export_range(0, 16, 1, "or_greater") var right_row := 3:
	set(value):
		right_row = value
		_refresh_editor_preview()
@export_group("Editor Preview")
@export var enable_editor_preview := true:
	set(value):
		enable_editor_preview = value
		_refresh_editor_preview()
@export_enum("run", "attack", "hurt", "death") var preview_animation := "run":
	set(value):
		preview_animation = value
		_refresh_editor_preview(true)
@export_enum("上", "下", "左", "右") var preview_direction := 1:
	set(value):
		preview_direction = value
		_refresh_editor_preview(true)

var current_animation := ""
var current_direction := Vector2.DOWN
var current_frame := 0
var is_finished := false
var _elapsed := 0.0
var _loop := true
var _preview_frame := 0
var _preview_elapsed := 0.0


func _ready() -> void:
	region_enabled = true
	if Engine.is_editor_hint():
		_refresh_editor_preview(true)
		return

	play_animation("idle", Vector2.DOWN)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_process_editor_preview(delta)
		return

	if is_finished:
		return

	var frame_count := _get_frame_count(current_animation)
	if frame_count <= 1:
		return

	_elapsed += delta
	var frame_time := 1.0 / fps
	while _elapsed >= frame_time:
		_elapsed -= frame_time
		current_frame += 1
		if current_frame >= frame_count:
			if _loop:
				current_frame = 0
			else:
				current_frame = frame_count - 1
				is_finished = true
		_apply_region()


func play_animation(animation_name: String, direction: Vector2, loop := true, force := false) -> void:
	if not force and current_animation == animation_name and current_direction == direction:
		return

	current_animation = animation_name
	current_direction = direction if direction.length_squared() > 0.0 else current_direction
	current_frame = 0
	_elapsed = 0.0
	_loop = loop
	is_finished = false
	texture = _get_texture(animation_name)
	_apply_region()


func _apply_region() -> void:
	var row := _direction_to_row(current_direction)
	region_rect = Rect2(current_frame * FRAME_SIZE.x, row * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
	flip_h = false


func _direction_to_row(direction: Vector2) -> int:
	if absf(direction.x) > absf(direction.y):
		return left_row if direction.x < 0.0 else right_row
	return up_row if direction.y < 0.0 else down_row


func _get_texture(animation_name: String) -> Texture2D:
	match animation_name:
		"run":
			return run_texture
		"attack":
			return attack_texture
		"hurt":
			return hurt_texture
		"death":
			return death_texture
		_:
			return idle_texture


func _get_frame_count(animation_name: String) -> int:
	return int(frames.get(animation_name, 1))


func _refresh_editor_preview(reset_frame := false) -> void:
	if not Engine.is_editor_hint() or not enable_editor_preview:
		return

	region_enabled = true
	if reset_frame:
		_preview_frame = 0
		_preview_elapsed = 0.0

	texture = _get_texture(preview_animation)
	_apply_preview_region()


func _process_editor_preview(delta: float) -> void:
	if not enable_editor_preview:
		return

	var frame_count := _get_frame_count(preview_animation)
	if frame_count <= 1:
		_apply_preview_region()
		return

	_preview_elapsed += delta
	var frame_time := 1.0 / fps
	while _preview_elapsed >= frame_time:
		_preview_elapsed -= frame_time
		_preview_frame = (_preview_frame + 1) % frame_count
		_apply_preview_region()


func _apply_preview_region() -> void:
	var row := _direction_to_row(_preview_direction_to_vector())
	var frame_count := _get_frame_count(preview_animation)
	var frame := mini(_preview_frame, maxi(frame_count - 1, 0))
	region_rect = Rect2(frame * FRAME_SIZE.x, row * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
	flip_h = false


func _preview_direction_to_vector() -> Vector2:
	match preview_direction:
		0:
			return Vector2.UP
		2:
			return Vector2.LEFT
		3:
			return Vector2.RIGHT
		_:
			return Vector2.DOWN
