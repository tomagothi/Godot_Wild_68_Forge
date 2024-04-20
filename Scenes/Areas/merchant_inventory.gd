extends CanvasLayer
class_name MerchantInventory

var items: Array[SellableItem]
@onready var item_info_text: Label = $Control/VBoxContainer/ItemInfoText
@onready var item_container: GridContainer = $Control/VBoxContainer/ItemsContainer

@export var starting_items: Array[Item]
@export var rep2_items: Array[Item]
@export var rep3_items: Array[Item]
@export var rep4_items: Array[Item]
@export var rep5_items: Array[Item]

func _ready() -> void:
	for child in item_container.get_children():
		if child is SellableItem:
			items.append(child)
			child.set_item(null)
			child.merchant_inventory = self
			child.visible = false
	
	for item in starting_items:
		add_item(item)

func add_item(item: Item) -> void:
	var sell_item: SellableItem = get_sellable_item_to_add(item)
	
	if sell_item:
		sell_item.set_item(item)

func remove_item(item: Item) -> bool:
	var sell_item: SellableItem = get_sellable_item_to_remove(item)
	
	if sell_item:
		sell_item.remove_item()
		return true
	else:
		return false

func get_sellable_item_to_add(item: Item) -> SellableItem:
	for sell_item in items:
		if sell_item.item == null:
			return sell_item
	
	return null

func get_sellable_item_to_remove(item: Item) -> SellableItem:
	for sell_item in items:
		if sell_item.item == item:
			return sell_item

	return null

func set_info_text(info: String) -> void:
	item_info_text.text = info

func add_rep_items(reputation: int) -> void:
	var items_to_add: Array[Item]
	match reputation:
		2:
			items_to_add = rep2_items
		3:
			items_to_add = rep3_items
		4:
			items_to_add = rep4_items
		5:
			items_to_add = rep5_items
	
	for item in items_to_add:
		add_item(item)
