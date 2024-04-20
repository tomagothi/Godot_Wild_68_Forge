extends Resource
class_name Item

enum ItemType {CRAFTING_MATERIAL, CRAFTING_TOOL, CRAFTABLE_ITEM, RECIPE}

@export var display_name: String
@export var item_icon: Texture2D
@export var base_cost: int
@export var max_stack_size: int
@export var item_type: ItemType
