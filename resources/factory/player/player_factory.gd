class_name PlayerFactory
extends Node

## makes the base player and adds it to GameData
static func make_base_player() -> Node2D:
    var _player = load(DirectoryPaths.player_scene).instantiate()

    GameData.player = _player

    return _player