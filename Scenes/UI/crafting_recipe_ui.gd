extends Panel
class_name CraftingRecipeUI

@onready var item_icon: TextureRect = $TextureRect
@onready var recipe_text: Label = $RecipeText
@onready var craft_button: Button = $CraftButton

var recipe: CraftingRecipe
var crafting

func update_recipe(inventory: Inventory) -> void:
	var can_craft: bool = true
	
	if inventory.inventory_full():
		can_craft = false
	else:
		for req in recipe.requirements:
			if inventory.get_number_of_items(req.item) < req.quantity:
				can_craft = false
				break
	
	craft_button.visible = can_craft
	recipe_text.text = recipe.item.display_name
	
	for req in recipe.requirements:
		if req.consumed:
			recipe_text.text += "\n" + req.item.display_name + " x" + str(req.quantity)
	
	item_icon.texture = recipe.item.item_icon

func _on_craft_button_pressed() -> void:
	crafting.craft(recipe)
