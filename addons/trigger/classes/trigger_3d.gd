@icon("res://addons/trigger/art/trigger3d.svg")
class_name Trigger3D extends Area3D

## Target node containing the method [code]method_name[/code].
@export var target_node: Node
## Node that can activate the trigger. If empty, any Area or Body will have this ability.
@export var activator_node: Node3D = target_node
## Name of the method that will be called on signal [code]call_on[/code].
@export var method_name: String
## Arguments passed to the method when called.
## Notice: if [code]omit_activator_arg[/code] is not [code]true[/code], the first (or the only if [code]method_args[/code] is empty) argument will be the activator node.
@export var method_args: Array[Variant] = []
## If [code]true[/code], the activator node won't be the first argument (see [code]method_args[/code]).
@export var omit_activator_arg: bool = false
## The signal that will activate the trigger.
@export_enum("area_entered", "area_exited", "body_entered", "body_exited") var call_on: String = "body_entered"
## If [code]true[/code], the trigger can be activated multiple times.
@export var multi_activation: bool = false

var was_activated: bool = false

func _on_activation(activator):
	if !multi_activation:
		if was_activated: return
	if activator_node:
		if activator_node != activator: return
	var callable: Callable
	var callable_args = method_args
	if !omit_activator_arg:
		callable_args.push_front(activator)
	callable = Callable(target_node, method_name).bindv(callable_args)
	if !multi_activation:
		was_activated = true
	callable.call()

func _ready():
	Signal(self, call_on).connect(_on_activation)
