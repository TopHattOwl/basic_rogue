class_name SpellNode
extends Node2D
## all premade spell data is stored in spell_data except
## spell_type and spell_subtype

## same as SpellResource's uid, set when spell gets made in spell factory
@export var uid: String

## Premade spell resource get loaded in here
## from the spell factory, after deep copying the SpellResource
@export var spell_data: SpellResource

@export var spell_type: int # from enum SPELL_TYPE
@export var spell_subtype: int # from enum SPELL_SUBTYPE




## Do not override, get set when spell spawned
@export var caster: Node2D

## Do not override, get set when spell spawned
@export var target_grid: Vector2i

## Do not override, get set when spell spawned
@export var current_grid: Vector2i



# these are set when spell is created (deep copied in spell factory) and added to known spells

var debug = GameData.spell_debug

func _ready() -> void:
    pass


## overriden by child Spell Nodes
func cast_spell(_caster: Node2D, _target_grid: Vector2i) -> void:
    pass

## overriden by child Spell Nodes
func set_data() -> void:
    pass


## sets the spell's uid to spell_data.uid
func set_uid() -> void:
    uid = spell_data.uid

# NOT USED
## overriden by child Spell Nodes
func set_spawn_data(_caster: Node2D, _target_grid: Vector2i) -> void:
    caster = _caster
    target_grid = _target_grid

    if debug:
        print("base spell node set spawn data")