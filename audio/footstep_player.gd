extends AudioStreamPlayer
class_name FootstepPlayer

# Preload the audio streams
var footstep_sounds = [
	preload("res://audio/assets/footsteps/footstep dirt 1.wav"),
	preload("res://audio/assets/footsteps/footstep dirt 5.wav"),
	preload("res://audio/assets/footsteps/footstep dirt 9.wav"),
	preload("res://audio/assets/footsteps/footstep dirt 14.wav"),
	preload("res://audio/assets/footsteps/footstep dirt 17.wav"),
	preload("res://audio/assets/footsteps/footstep dirt 28.wav")
]

func play_random_footstep_sound():
	var index: int = randi() % footstep_sounds.size()
	stream = footstep_sounds[index]
	bus = "Footsteps"
	play()
