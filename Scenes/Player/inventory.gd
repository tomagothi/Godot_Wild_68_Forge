extends CanvasLayer
class_name Inventory

var items: Array[InventoryItem]
@onready var window: Panel = $InventoryWindow
@onready var item_info_text: Label = $InventoryWindow/ItemInfoText
@onready var item_container: GridContainer = $InventoryWindow/InventoryItemsContainer

@export var starting_items: Array[Item]

func _ready() -> void:
	for child in item_container.get_children():
		if child is InventoryItem:
			items.append(child)
			child.set_item(null)
			child.inventory = self
	
	for item in starting_items:
		add_item(item)

func _process(_delta: float) -> void:
	pass

func toggle_window(open: bool) -> void:
	window.visible = open

func add_item(item: Item) -> bool:
	var inv_item: InventoryItem = get_inv_item_to_add(item)
	
	if inv_item:
		if inv_item.item == null:
			inv_item.set_item(item)
		else:
			inv_item.add_item()
		return true
	else:
		return false

func remove_item(item: Item) -> bool:
	var inv_item: InventoryItem = get_inv_item_to_remove(item)
	
	if inv_item:
		inv_item.remove_item()
		return true
	else:
		return false

func get_inv_item_to_add(item: Item) -> InventoryItem:
	for inv_item in items:
		if inv_item.item == item and inv_item.quantity < item.max_stack_size:
			return inv_item
	
	for inv_item in items:
		if inv_item.item == null:
			return inv_item
	
	return null

func get_inv_item_to_remove(item: Item) -> InventoryItem:
	for inv_item in items:
		if inv_item.item == item:
			return inv_item

	return null

func set_info_text(info: String) -> void:
	item_info_text.text = info
	
func get_number_of_items(item: Item) -> int:
	var total: int = 0
	
	for inv_item in items:
		if inv_item.item == item:
			total += inv_item.quantity
	
	return total

func inventory_full() -> bool:
	for inv_item in items:
		if inv_item.item == null:
			return false
	
	return true
