extends CanvasLayer
class_name CraftingNode

@onready var window: Panel = $CraftingWindow
@onready var recipe_container: VBoxContainer = $CraftingWindow/ScrollContainer/RecipeContainer

@export var known_recipes: Array[CraftingRecipe]
@export var crafting_recipe_ui_scene: PackedScene

@export var anvil_sound: AudioStream

var recipe_uis: Array[CraftingRecipeUI]
var inventory: Inventory

func _ready() -> void:
	for recipe in known_recipes:
		add_recipe_to_container(recipe)
	
	close()
	
	GlobalSignals.start_crafting.connect(open)
	GlobalSignals.end_crafting.connect(close)

func add_recipe_to_container(recipe: CraftingRecipe) -> void:
	var recipe_node = crafting_recipe_ui_scene.instantiate()
	recipe_container.add_child(recipe_node)
	recipe_node.recipe = recipe
	recipe_node.crafting = self
	recipe_uis.append(recipe_node)

func craft(recipe: CraftingRecipe) -> void:
	if anvil_sound:
		SfxPlayer.play(anvil_sound)
	
	for req in recipe.requirements:
		if req.consumed:
			for i in range(req.quantity):
				inventory.remove_item(req.item)
	
	inventory.add_item(recipe.item)
	open()

func add_recipe(recipe: CraftingRecipe) -> void:
	known_recipes.append(recipe)
	add_recipe_to_container(recipe)

func open() -> void:
	window.visible = true
	inventory = get_parent().get_node("Inventory")
	
	for recipe in recipe_uis:
		recipe.update_recipe(inventory)

func close() -> void:
	window.visible = false
