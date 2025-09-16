extends Node
class_name Stats 
enum STATS {
	STR,
	DEX,
	VIT,
	WIS,
	SKL,
}

@export var str: int = 10
@export var dex: int = 10
@export var vit: int = 10
@export var wis: int = 10
@export var skl: int = 10

func get_stat(stat: STATS) -> int:
	match stat:
		STATS.STR: return str
		STATS.DEX: return dex
		STATS.VIT: return vit
		STATS.WIS: return wis
		STATS.SKL: return skl
		_: return 0
