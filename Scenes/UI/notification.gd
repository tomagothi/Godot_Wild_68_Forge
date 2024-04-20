extends TextureRect

var notification_message: String = ""
@onready var notification_text: Label = $NotificationText

func _process(_delta: float) -> void:
	if notification_message != "":
		notification_text.text = notification_message
		notification_message = ""
		
		_fade_in_tween()

func _fade_in_tween() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.75)
	await tween.tween_interval(2.0).finished
	tween.finished.connect(_fade_out_tween)

func _fade_out_tween() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.75)
	tween.finished.connect(func(): queue_free())
