extends VBoxContainer


func _ready() -> void:
	
	# set icons textures
	$Str/Icon.texture = load(DirectoryPaths.strength_icon)
	$Per/Icon.texture = load(DirectoryPaths.perception_icon)
	$Int/Icon.texture = load(DirectoryPaths.intelligence_icon)
	$Dex/Icon.texture = load(DirectoryPaths.dexterity_icon)
	$Con/Icon.texture = load(DirectoryPaths.constitution_icon)

func set_stats(stats: Dictionary) -> void:

	# get the stats
	var strength_value: int = stats.get("strength", -1)
	var perception_value: int = stats.get("perception", -1)
	var intelligence_value: int = stats.get("intelligence", -1)
	var dexterity_value: int = stats.get("dexterity", -1)
	var constitution_value: int = stats.get("constitution", -1)


	# set labels

	$Str/Value.text = str(strength_value)
	$Per/Value.text = str(perception_value)
	$Int/Value.text = str(intelligence_value)
	$Dex/Value.text = str(dexterity_value)
	$Con/Value.text = str(constitution_value) 