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

var current_animation := ""
var current_direction := Vector2.DOWN
var current_frame := 0
var is_finished := false
var _elapsed := 0.0
var _loop := true


func _ready() -> void:
	region_enabled = true
	play_animation("idle", Vector2.DOWN)


func _process(delta: float) -> void:
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
		return 2 if direction.x < 0.0 else 3
	return 1 if direction.y < 0.0 else 0


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

