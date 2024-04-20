extends Node2D
class_name PlayerForge

@onready var crafting_layer: CanvasLayer = $CraftingLayer

func toggle_scene(show_scene: bool) -> void:
	visible = show_scene
	crafting_layer.visible = show_scene
	
	if show_scene:
		GlobalSignals.start_crafting.emit()
	else:
		GlobalSignals.end_crafting.emit()

func _on_end_crafting_pressed() -> void:
	GlobalSignals.change_scene.emit(GlobalSignals.GameScene.MAIN_MENU)
