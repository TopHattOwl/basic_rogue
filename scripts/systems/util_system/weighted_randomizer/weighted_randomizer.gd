class_name WeightedRandomizer
extends Node



## gets a dict of monster types and it's weight {monster_id: spawn_weigth} [br]
## returns a monster id
static func weighted_random_monster(weights: Dictionary) -> int:

    if weights.is_empty():
        push_error("WeightedRandomizer: Empty weights in weighted_random_monster")
        return -1

    var total_weight = 0.0
    for weight in weights.values():
        total_weight += weight
    
    var random_value = randf_range(0.0, total_weight)


    # find monster id
    var current_weight = 0.0
    for id in weights.keys():
        current_weight += weights[id]
        if random_value <= current_weight:
            return id
        
    
    push_error("WeightedRandomizer: weighted_random_monster algorithm failed, returning  first monster in weights")
    return weights.keys()[0]