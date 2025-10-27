class_name MonsterRemains
extends Node2D

var sprite: Sprite2D

var components: Node


func _init(monster_key: int) -> void:


    make_sprite(monster_key)
    add_to_group("remains")
    add_children()


func make_sprite(monster_key: int) -> void:
    var sprite_path = DirectoryPaths.monster_remains_sprites[monster_key]
    if not sprite_path:
        sprite_path = DirectoryPaths.monster_remains_sprites[0]
    var _sprite = load(sprite_path)
    sprite = Sprite2D.new()
    sprite.texture = _sprite

func add_children():
    add_child(sprite)
    var _components = Node.new()
    _components.name = "Components"
    components = _components
    add_child(components)

    z_as_relative = false
    z_index = GameData.MOSNTER_REMAINS_Z_INDEX

    add_components()

func add_components():
    var pos_comp = PositionComponent.new()
    pos_comp.name = GameData.get_component_name(GameData.ComponentKeys.POSITION)
    components.add_child(pos_comp)

    
