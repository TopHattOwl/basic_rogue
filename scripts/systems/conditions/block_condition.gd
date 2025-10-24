class_name BlockCondition
extends Condition
## when entity blocks, block condition is met for duration amount of time

var is_active: bool = false
var duration: int = 5 # duration in turns
var turns_left: int

var owner: Node2D

func _init(_duration: int, _owner: Node2D) -> void:
    duration = _duration
    owner = _owner
    SignalBus.player_acted.connect(_on_player_acted)
    SignalBus.actor_hit_final.connect(_on_actor_hit)

func _on_actor_hit(d: Dictionary) -> void:
    ## if owner was the target and blocked the attack
    if d.target == owner and d.hit_action == GameData.HIT_ACTIONS.BLOCKED:
        is_active = true
        turns_left = duration


func _on_player_acted() -> void:
    turns_left -= 1
    if turns_left <= 0:
        is_active = false

func is_met(_entity: Node2D = null) -> bool:
    return is_active