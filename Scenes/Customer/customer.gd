extends Node2D
class_name Customer

enum Spending {FRUGAL, NORMAL, OVERPAY}
enum WealthLevel {POOR, AVERAGE, WEALTHY}

var customer_wealth: WealthLevel
var customer_spending: Spending
var customer_wants: Item
var player_reputation_level: int
var initial_offer: int = 1
var item_base_price: int
var item_high_price: int
var item_low_price: int
var offer_dialog: String
var accept_dialog: String
var reject_dialog: String

@export var level1_items: Array[Item]
@export var level2_items: Array[Item]
@export var level3_items: Array[Item]
@export var level4_items: Array[Item]
@export var level5_items: Array[Item]
@export var available_sprites: Array[Texture2D]

@export_group("Dialog Options")
@export var frugal_poor_dialog: DialogOptions
@export var frugal_average_dialog: DialogOptions
@export var frugal_wealthy_dialog: DialogOptions
@export var normal_average_dialog: DialogOptions
@export var normal_wealthy_dialog: DialogOptions
@export var overspend_wealthy_dialog: DialogOptions

@onready var sprite: Sprite2D = $Sprite2D

func set_new_customer(player_reputation: int) -> void:
	player_reputation_level = player_reputation
	set_random_sprite()
	
	var rand_wealth: int = randi() % 3
	match rand_wealth:
		0:
			customer_wealth = WealthLevel.POOR
			print("Poor customer")
		1:
			customer_wealth = WealthLevel.AVERAGE
			print("Average customer")
		2:
			customer_wealth = WealthLevel.WEALTHY
			print("Wealthy customer")
	
	customer_spending = get_customer_spend()
	determine_what_customer_wants()
	set_dialogs()
	set_item_prices()
	
	if customer_spending == Spending.FRUGAL:
		initial_offer = int(customer_wants.base_cost * 0.75)
	else:
		initial_offer = customer_wants.base_cost

func set_random_sprite() -> void:
	var sprite_index: int = randi() % available_sprites.size()
	sprite.texture = available_sprites[sprite_index]

func get_customer_spend() -> Spending:
	var return_val: Spending = Spending.FRUGAL

	if customer_wealth == WealthLevel.AVERAGE:
		if randi() % 2 == 1:
			return_val = Spending.NORMAL
	elif customer_wealth == WealthLevel.WEALTHY:
		var rand_spend = randi() % 3
		if rand_spend == 1:
			return_val = Spending.NORMAL
		elif rand_spend == 2:
			return_val = Spending.OVERPAY
	
	print("Customer Spend: %s" % return_val)
	return return_val

func determine_what_customer_wants() -> void:
	match player_reputation_level:
		1:
			customer_wants = pick_from_list(level1_items)
		2:
			customer_wants = pick_from_list(level2_items)
		3:
			customer_wants = pick_from_list(level3_items)
		4:
			customer_wants = pick_from_list(level4_items)
		5:
			customer_wants = pick_from_list(level5_items)

func pick_from_list(list: Array[Item]) -> Item:
	var index_value = randi() % list.size()
	return list[index_value]

func set_dialogs() -> void:
	var dialog_options: DialogOptions = frugal_poor_dialog
	if customer_wealth == WealthLevel.AVERAGE:
		if customer_spending == Spending.FRUGAL:
			dialog_options = frugal_average_dialog
		else:
			dialog_options = normal_average_dialog
	elif customer_wealth == WealthLevel.WEALTHY:
		if customer_spending == Spending.FRUGAL:
			dialog_options = frugal_wealthy_dialog
		elif customer_spending == Spending.NORMAL:
			dialog_options = normal_wealthy_dialog
		else:
			dialog_options = overspend_wealthy_dialog
	
	var i: int = dialog_options.initial_offer_dialog.size()
	offer_dialog = dialog_options.initial_offer_dialog[randi() % i]
	i = dialog_options.offer_accepted_dialog.size()
	accept_dialog = dialog_options.offer_accepted_dialog[randi() % i]
	i = dialog_options.offer_rejected_dialog.size()
	reject_dialog = dialog_options.offer_rejected_dialog[randi() % i]

func  set_item_prices() -> void:
	item_base_price = customer_wants.base_cost
	item_high_price = (int)(customer_wants.base_cost * 1.25)
	item_low_price = (int)(customer_wants.base_cost * 0.75)
	
func make_offer(sale_price: int) -> int:
	var rep_gain: int = 0
	if sale_price == item_low_price:
		# 3 points if the seller is wealthy, 2 otherwise
		if customer_wealth == WealthLevel.WEALTHY:
			rep_gain = 3
		else:
			rep_gain = 2
	elif sale_price == item_base_price && customer_wealth != WealthLevel.POOR:
		var sale_made: bool = false
		if customer_spending == Spending.FRUGAL:
			if randi() % 5 + 1 <= player_reputation_level:
				sale_made = true
		else:
			sale_made = true
		
		if sale_made:
			if customer_wealth == WealthLevel.AVERAGE:
				rep_gain = 1
			else:
				rep_gain = 2
	elif sale_price == item_high_price && customer_wealth == WealthLevel.WEALTHY:
		if customer_spending == Spending.OVERPAY:
			rep_gain = 1
		elif customer_spending == Spending.NORMAL:
			if randi() % 5 + 1 <= player_reputation_level:
				rep_gain = 1
	return rep_gain

