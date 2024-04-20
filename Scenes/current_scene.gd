extends Node2D
class_name CurrentScene

@onready var main_menu: MainMenu = $MainMenu
@onready var merchant_shop: MerchantShop = $MerchantShop
@onready var player_shop: PlayerShop = $PlayerShop
@onready var player_forge: PlayerForge = $PlayerForge
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_scene: GlobalSignals.GameScene = GlobalSignals.GameScene.MAIN_MENU
var next_scene: GlobalSignals.GameScene

func _ready() -> void:
	GlobalSignals.change_scene.connect(_change_scene)

func _change_scene(load_scene: GlobalSignals.GameScene) -> void:
	animation_player.play("fade_out")
	next_scene = load_scene

func _on_fade_out_finished() -> void:
	match current_scene:
		GlobalSignals.GameScene.MAIN_MENU:
			main_menu.toggle_scene(false)
		GlobalSignals.GameScene.MERCHANT_SHOP:
			merchant_shop.toggle_scene(false)
		GlobalSignals.GameScene.PLAYER_SHOP:
			player_shop.toggle_scene(false)
		GlobalSignals.GameScene.PLAYER_FORGE:
			player_forge.toggle_scene(false)

	match next_scene:
		GlobalSignals.GameScene.MAIN_MENU:
			main_menu.toggle_scene(true)
		GlobalSignals.GameScene.MERCHANT_SHOP:
			merchant_shop.toggle_scene(true)
		GlobalSignals.GameScene.PLAYER_SHOP:
			player_shop.toggle_scene(true)
		GlobalSignals.GameScene.PLAYER_FORGE:
			player_forge.toggle_scene(true)
	
	current_scene = next_scene
	
	animation_player.play("fade_in")
