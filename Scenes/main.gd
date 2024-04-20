extends Node2D

var day: int = 1

@export var max_days: int = 60
@export var main_theme: AudioStream

@onready var player: Player = $Player as Player
@onready var current_scene_container: Node2D = $CurrentScene

func _ready() -> void:
	if main_theme:
		MusicPlayer.play(main_theme)

#func _change_scene(new_scene: PackedScene) -> void:
	#var current_scene = current_scene_container.get_child(0)
	#current_scene.call_deferred("free")
	#current_scene_container.call_deferred("remove_child", current_scene)
	#current_scene_container.add_child(new_scene.instantiate())
