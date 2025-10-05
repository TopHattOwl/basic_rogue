class_name DungeonMap
extends Resource

var dungeons: Array[Dungeon]


func add_dungeon(dungeon: Dungeon) -> void:
    dungeons.append(dungeon)

func get_dungeon_by_id(id: int) -> Dungeon:    
    var i = dungeons.find_custom(func(dungeon: Dungeon) -> bool:
        return dungeon.id == id)
    
    if i == -1:
        return null
    return dungeons[i]