extends AudioStreamPlayer
class_name FootstepPlayer

# Preload the audio streams
var footstep_sounds = [
	preload("res://audio/assets/fs_1.wav"),
	preload("res://audio/assets/fs_2.wav"),
	preload("res://audio/assets/fs_3.wav"),
	preload("res://audio/assets/fs_4.wav")
]

func play_random_footstep_sound():
	var index: int = randi() % footstep_sounds.size()
	stream = footstep_sounds[index]
	bus = "Footsteps"
	play()
