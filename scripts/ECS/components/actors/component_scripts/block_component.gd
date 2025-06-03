class_name BlockComponent
extends Node


# signal block_power_changed(new_value, max_value)

signal block_success(blocked_damage)

@export var block_chance: float
@export var max_block_power: int
@export var block_recovery_rate: float

var current_block_power: int
var _turn_counter: int

func _ready():
    current_block_power = max_block_power
    _turn_counter = 0

    SignalBus.player_acted.connect(_on_turn_pass)


func try_block(damage: int) -> bool:
    if current_block_power <= 0:
        return false
    
    if randf() < block_chance:
        current_block_power = max(0, current_block_power - damage)
        SignalBus.block_power_changed.emit(current_block_power, max_block_power)
        block_success.emit(damage)
        return true

    return false

func _on_turn_pass():
    _turn_counter += 1

    if _turn_counter >= 5:
        _recover_block_power()
        _turn_counter = 0

func _recover_block_power():
    var recovery_amount = int(max_block_power * block_recovery_rate)

    current_block_power = min(current_block_power + recovery_amount, max_block_power)
    SignalBus.block_power_changed.emit(current_block_power, max_block_power)


func reset_block_power():
    current_block_power = max_block_power
    SignalBus.block_power_changed.emit(current_block_power, max_block_power)
