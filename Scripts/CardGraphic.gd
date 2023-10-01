extends Control;

class_name CardUI;

var _curr_card: Card;

func _ready():
	GameManager.subscribe_button($ARC/CardBG/Button);

func _on_pressed():
	GameManager.load_item(_curr_card);

func set_card(c: Card):
	_curr_card = c;
	$ARC/CardBG/MarginContainer/VBoxContainer/NamePanel/MarginContainer/RichTextLabel.text = c.name;
