extends Control;

class_name CardUI;

var _curr_card: Card;

func _ready():
	GameManager.subscribe_button(self);

func _on_pressed():
	GameManager.load_item(self, _curr_card);

func set_card(c: Card):
	_curr_card = c;
	$ARC/CardBG/MarginContainer/VBoxContainer/NamePanel/MarginContainer/RichTextLabel.text = c.name;
	$ARC/CardBG/MarginContainer/VBoxContainer/DescPanel/MarginContainer/RichTextLabel.text = c.description
