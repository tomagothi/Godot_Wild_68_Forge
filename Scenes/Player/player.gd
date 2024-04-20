extends Node
class_name Player

@export var gold: int = 50
@export var kaching_audio: AudioStream

@onready var inventory = $Inventory
@onready var player_ui = $UI
@onready var crafting: CraftingNode = $Crafting as CraftingNode
@onready var gold_text: Label = $UI/HBoxContainer/GoldText
@onready var rep_text: Label = $UI/HBoxContainer/ReputationText

var reputation: int = 1 :
	get:
		return reputation
	set(value):
		reputation = value
		perform_rep_updates()
		
var rep_xp: int = 0
var next_level: int = 10

func _ready() -> void:
	GlobalSignals.buy_item.connect(_on_buy_item)
	GlobalSignals.sell_item.connect(_on_sell_item)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		set_gold_text()
		inventory.visible = !inventory.visible
		player_ui.visible = inventory.visible

func _on_buy_item(item: Item, price: int) -> void:
	if price <= gold:
		if item is ItemRecipe:
			gold -= price
			crafting.add_recipe(item.recipe)
			if kaching_audio:
				#print("Hit from Item Recipe")
				SfxPlayer.play(kaching_audio)
			GlobalSignals.transaction_complete.emit(item, gold)
		elif inventory.add_item(item):
			gold -= price
			if kaching_audio:
				#print("Hit from add item")
				SfxPlayer.play(kaching_audio)
			GlobalSignals.transaction_complete.emit(item, gold)
		else:
			GlobalSignals.inventory_full.emit()
	else:
		GlobalSignals.not_enough_gold.emit()

func _on_sell_item(item: Item, price: int) -> void:
	if inventory.remove_item(item):
		gold += price
	else:
		GlobalSignals.item_not_found.emit()

func set_gold_text() -> void:
	gold_text.text = "Gold: %s" % gold

func perform_rep_updates() -> void:
	var rep_title: String
	if reputation > 1:
		var merchant_inv: MerchantInventory = get_tree().get_first_node_in_group("MerchantInventory") as MerchantInventory
		merchant_inv.add_rep_items(reputation)
	
	match reputation:
		1:
			rep_title = "Novice"
		2:
			rep_title = "Journeyman"
		3:
			rep_title = "Craftsman"
		4:
			rep_title = "Export"
		5:
			rep_title = "Master"
		_:
			rep_title = "Novice"
	
	rep_text.text = "Reputation " + rep_title
	GlobalSignals.reputation_increase.emit(rep_title)
	
func gain_rep(amount: int) -> void:
	rep_xp += amount
	if rep_xp >= next_level && reputation < 5:
		reputation += 1
		next_level += (10 * reputation)
