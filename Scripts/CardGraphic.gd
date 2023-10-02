extends Control;

class_name CardUI;

var _curr_card: Card;

func _ready():
	GameManager.subscribe_button(self);

func _on_pressed():
	GameManager.load_item(self, _curr_card);

func set_card(c: Card):
	_curr_card = c;
	$CardBG/MarginContainer/VBoxContainer/HBoxContainer2/NamePanel/MarginContainer/RichTextLabel.text = c.name;
	$CardBG/MarginContainer/VBoxContainer/DescPanel/MarginContainer/RichTextLabel.text = c.description
	$CardBG/MarginContainer/VBoxContainer/HBoxContainer2/EnergyPanel/MarginContainer/RichTextLabel.text = str(c.energyCost) + "e"

	var effect_text = ""
	
	for eff in c.effects:
		effect_text += eff + ": " + str(c.effects[eff]) + "\n"
	
	$CardBG/MarginContainer/VBoxContainer/HBoxContainer/StatsPanel/MarginContainer/RichTextLabel.text = effect_text
