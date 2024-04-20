extends Node2D
class_name MainMenu

@onready var canvas_layer: CanvasLayer = $MenuLayer
@onready var credits_layer: CanvasLayer = $CreditsLayer
#@onready var canvas_panel: Panel = $CanvasLayer/CanvasPanel

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _on_sell_button_pressed() -> void:
	GlobalSignals.change_scene.emit(GlobalSignals.GameScene.PLAYER_SHOP)

func _on_buy_button_pressed() -> void:
	GlobalSignals.change_scene.emit(GlobalSignals.GameScene.MERCHANT_SHOP)

func _on_forge_button_pressed() -> void:
	GlobalSignals.change_scene.emit(GlobalSignals.GameScene.PLAYER_FORGE)

func toggle_scene(show_scene: bool) -> void:
	visible = show_scene
	canvas_layer.visible = show_scene
	credits_layer.visible = false

func _on_credits_button_pressed() -> void:
	credits_layer.visible = true

func _on_back_button_pressed() -> void:
	credits_layer.visible = false
