extends Node2D
class_name MerchantShop

@onready var merchant_inventory: MerchantInventory = $MerchantInventory
@onready var merchant_dialog: CanvasLayer = $MerchantDialog
@onready var exit_button: Button = %ExitButton
@onready var gold_text: Label = %GoldText
@onready var sale_notification: ColorRect = %SaleNotification

@export var notification_scene: PackedScene

func _ready() -> void:
	GlobalSignals.transaction_complete.connect(_on_transaction_complete)
	GlobalSignals.not_enough_gold.connect(_not_enough_gold)
	GlobalSignals.inventory_full.connect(_inventory_full)
	
func _on_exit_button_pressed() -> void:
	GlobalSignals.change_scene.emit(GlobalSignals.GameScene.MAIN_MENU)

func _on_exit_button_mouse_entered() -> void:
	merchant_inventory.set_info_text("Exit Shop")

func _on_exit_button_mouse_exited() -> void:
	merchant_inventory.set_info_text("")

func toggle_scene(show_scene: bool) -> void:
	visible = show_scene
	merchant_inventory.visible = show_scene
	merchant_dialog.visible = show_scene
	exit_button.visible = show_scene
	
	if show_scene:
		var player: Player = get_tree().get_first_node_in_group("Player") as Player
		gold_text.text = "%sg" % player.gold

func _on_transaction_complete(item: Item, current_gold: int) -> void:
	gold_text.text = "%sg" % current_gold
	var notification_instance = notification_scene.instantiate()
	notification_instance.notification_message = item.display_name + " purchased."
	sale_notification.add_child(notification_instance)

func _not_enough_gold() -> void:
	var notification_instance = notification_scene.instantiate()
	notification_instance.notification_message = "Insufficient gold."
	sale_notification.add_child(notification_instance)

func _inventory_full() -> void:
	var notification_instance = notification_scene.instantiate()
	notification_instance.notification_message = "Inventory full."
	sale_notification.add_child(notification_instance)
