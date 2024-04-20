extends Button
class_name SellableItem

var item: Item
var merchant_inventory: MerchantInventory
var price: int:
	get:
		return price
	set(value):
		price = clampi(value, 1, value)

@onready var item_icon: TextureRect = $Icon
@onready var price_text: Label = $ColorRect/PriceText

@export var cost_modifier: float = 1.0
@export var one_time_purchase: bool = false

func set_item(new_item: Item) -> void:
	item = new_item
	price = 0
	
	if item == null:
		visible = false
	else:
		item_icon.visible = true
		item_icon.texture = item.item_icon
		price = int(item.base_cost * cost_modifier)
		visible = true
	
	update_price_text()

func remove_item() -> void:
	if one_time_purchase:
		set_item(null)

func update_price_text() -> void:
	if price:
		price_text.text = "%s g" % price
	else:
		price_text.text = ""

func _on_mouse_entered() -> void:
	if item:
		merchant_inventory.set_info_text(item.display_name)
	else:
		merchant_inventory.set_info_text("")

func _on_mouse_exited() -> void:
	merchant_inventory.set_info_text("")

func _on_pressed() -> void:
	if item is ItemRecipe or item.item_type == Item.ItemType.CRAFTING_TOOL:
		var player: Player = get_tree().get_first_node_in_group("Player") as Player
		if player.gold >= price:
			GlobalSignals.buy_item.emit(item, price)
			set_item(null)
	else:
		GlobalSignals.buy_item.emit(item, price)
	
