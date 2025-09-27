class_name ContractFactory
extends Node

var debug := GameData.contract_debug


static func make_contract(data: Dictionary) -> Contract:
    var contract = Contract.new(data)
    return contract