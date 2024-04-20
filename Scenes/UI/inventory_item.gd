extends Button
class_name InventoryItem

var item: Item
var quantity: int
var inventory: Inventory

@onready var item_icon: TextureRect = $Icon
@onready var inventory_text: Label = $InventoryText

func set_item(new_item: Item) -> void:
	item = new_item
	quantity = 1
	
	if item == null:
		item_icon.visible = false
	else:
		item_icon.visible = true
		item_icon.texture = item.item_icon
	
	update_quantity_text()

func add_item() -> void:
	if quantity < item.max_stack_size:
		quantity += 1
		update_quantity_text()

func remove_item() -> void:
	quantity -= 1
	update_quantity_text()
	
	if quantity <= 0:
		set_item(null)

func update_quantity_text() -> void:
	if quantity > 1:
		inventory_text.text = str(quantity)
	else:
		inventory_text.text = ""

func _on_mouse_entered() -> void:
	if item:
		inventory.set_info_text(item.display_name)
	else:
		inventory.set_info_text("")

func _on_mouse_exited() -> void:
	inventory.set_info_text("")

func _on_pressed() -> void:
	pass # Replace with function body.
