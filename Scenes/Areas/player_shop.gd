extends Node2D
class_name PlayerShop

@export var kaching_audio: AudioStream
@export var sad_trombone: AudioStream

@onready var chat_windows: CanvasLayer = $ChatWindows
@onready var level_up_window: CanvasLayer = %LevelUpWindow
@onready var customer: Customer = $Customer as Customer
@onready var start_position: Vector2 = $Customer.global_position
@onready var customer_chat_window: TextureRect = $ChatWindows/CustomerChat
@onready var customer_chat_text: Label = $ChatWindows/CustomerChat/ChatArea/ChatText
@onready var player_chat_window: TextureRect = $ChatWindows/PlayerChat
@onready var player_chat_text: Label = $ChatWindows/PlayerChat/ChatArea/ChatText
@onready var interaction_container: VBoxContainer = $ChatWindows/InteractionContainer
@onready var offer1_label_text: Label = $ChatWindows/InteractionContainer/Offer1/Label
@onready var offer2_label_text: Label = $ChatWindows/InteractionContainer/Offer2/Label
@onready var offer3_label_text: Label = $ChatWindows/InteractionContainer/Offer3/Label
@onready var offer1_button: Button = $ChatWindows/InteractionContainer/Offer1
@onready var offer2_button: Button = $ChatWindows/InteractionContainer/Offer2
@onready var offer3_button: Button = $ChatWindows/InteractionContainer/Offer3
@onready var continue_button: Button = %ContinueButton
@onready var reputation_level_text: RichTextLabel = %ReputationLevelText

var player: Player
var item_for_sale: Item
var item_unavailable: bool = false

func _ready() -> void:
	GlobalSignals.reputation_increase.connect(_show_level_up_window)
	
func toggle_scene(show_scene: bool) -> void:
	visible = show_scene
	customer_chat_window.visible = false
	player_chat_window.visible = false
	interaction_container.visible = false
	chat_windows.visible = show_scene
	
	if show_scene:
		start_shop()

func start_shop() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player
	customer.set_new_customer(player.reputation)
	
	item_for_sale = customer.customer_wants
	
	await get_tree().create_timer(0.8).timeout
	
	customer.global_position = start_position
	customer.visible = true
	
	var first_position: Vector2 = Vector2(start_position.x, 160)
	var second_position: Vector2 = Vector2(377, 160)
	tween_customer(first_position, second_position, true)

func start_dialog() -> void:
	customer_chat_text.text = customer.offer_dialog % [item_for_sale.display_name, str(customer.initial_offer)]
	customer_chat_window.visible = true
	
	set_player_dialog_options()

func set_player_dialog_options() -> void:
	if player.inventory.get_number_of_items(item_for_sale) < 1:
		item_unavailable = true
		offer1_label_text.text = "Sorry friend. I do not have a %s right now." % item_for_sale.display_name
		offer2_button.visible = false
		offer3_button.visible = false
	else:
		item_unavailable = false
		var low_offer: int = int(item_for_sale.base_cost * 0.75)
		var base_offer: int = item_for_sale.base_cost
		var high_offer: int = int(item_for_sale.base_cost * 1.25)
		
		if customer.initial_offer < item_for_sale.base_cost:
			offer1_label_text.text = "I will accept your offer of %s gold." % low_offer
			offer2_label_text.text = "I must ask for my normal price of %s gold." % base_offer
		else:
			offer1_label_text.text = "I can sell it to your for %s gold." % low_offer
			offer2_label_text.text = "I will accept your offer of %s gold." % base_offer
		
		offer3_label_text.text = "For such quality, I must insist on %s gold." % high_offer
		
		offer2_button.visible = true
		offer3_button.visible = true
		
	interaction_container.visible = true

func _on_offer_1_pressed() -> void:
	interaction_container.visible = false
	player_chat_window.visible = true
	player_chat_text.text = offer1_label_text.text
	if item_unavailable:
		#print("Need to exit from here somehow")
		continue_button.visible = true
		customer_chat_text.text = "A pity. Farewell!"
	else:
		sell_item(customer.item_low_price)

func _on_offer_2_pressed() -> void:
	interaction_container.visible = false
	player_chat_window.visible = true
	player_chat_text.text = offer2_label_text.text
	sell_item(customer.item_base_price)

func _on_offer_3_pressed() -> void:
	interaction_container.visible = false
	player_chat_window.visible = true
	player_chat_text.text = offer3_label_text.text
	sell_item(customer.item_high_price)

func sell_item(sale_price) -> void:
	var rep_gain: int = customer.make_offer(sale_price)
	if rep_gain > 0:
		#print("Sold")
		if kaching_audio:
			SfxPlayer.play(kaching_audio)
		GlobalSignals.sell_item.emit(item_for_sale, sale_price)
		player.gain_rep(rep_gain)
		customer_chat_text.text = customer.accept_dialog
	else:
		#print("No sale this time")
		if sad_trombone:
			SfxPlayer.play(sad_trombone)
		customer_chat_text.text = customer.reject_dialog
	
	continue_button.visible = true

func customer_exit() -> void:
	#await get_tree().create_timer(delay_time).timeout
	
	player_chat_window.visible = false
	customer_chat_window.visible = false

	var first_position: Vector2 = Vector2(start_position.x, 160)
	var second_position: Vector2 = start_position
	tween_customer(first_position, second_position, false)
	
	GlobalSignals.change_scene.emit(GlobalSignals.GameScene.MAIN_MENU)

func tween_customer(first_position: Vector2, second_position: Vector2, begin: bool) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	tween.tween_property(customer, "global_position", first_position, 0.8)
	tween.tween_property(customer, "global_position", second_position, 0.6)
	
	if begin:
		tween.finished.connect(start_dialog)

func _on_continue_button_pressed() -> void:
	continue_button.visible = false
	customer_exit()

func _show_level_up_window(title: String) -> void:
	reputation_level_text.text = "[color=Black] [p align=center][b]Congratulations[/b][/p][p] [/p][p align=center]You have attanded the reputation of[/p][p align=center]%s[/p][p] [/p][p align=center]New items are available for puchase.[/p][/color]" % title
	level_up_window.visible = true
	
func _on_congrats_button_pressed() -> void:
	level_up_window.visible = false
