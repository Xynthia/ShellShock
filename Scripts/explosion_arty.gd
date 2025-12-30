extends Node3D


@onready var fire_init: GPUParticles3D = $"fire init"
@onready var dirt: GPUParticles3D = $Dirt
@onready var smoke_spread: GPUParticles3D = $"smoke spread"
@onready var smoke_spread_2: GPUParticles3D = $"smoke spread2"


# Called when the node enters the scene tree for the first time.
func particle_start() -> void:
	fire_init.emitting = true
	dirt.emitting = true
	smoke_spread.emitting = true
	smoke_spread_2.emitting = true
