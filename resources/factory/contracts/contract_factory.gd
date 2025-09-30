class_name ContractFactory
extends Node

var debug := GameData.contract_debug


## makes a contract [br]
## if no `data` is given, fully random contract will be made
static func make_contract(data: Dictionary = {}) -> Contract:
    var contract = Contract.new(data)

    SignalBus.contract_generated.emit({"contract": contract})
    return contract