extends Node
class_name PuzzleElement

# This can be extended/overridden by child scripts
func activate():
	print("%s activated" % name)

func deactivate():
	print("%s deactivated" % name)

func toggle():
	if is_active():
		deactivate()
	else:
		activate()

func is_active() -> bool:
	return false  # override in child
