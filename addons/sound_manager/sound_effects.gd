extends "res://addons/sound_manager/abstract_audio_player_pool.gd"

func play(resource: AudioStream, override_bus: String="", random_pitch=false) -> AudioStreamPlayer:
	var player: AudioStreamPlayer = prepare(resource, override_bus)
	# TODO: add random pitch
	player.call_deferred("play")
	return player
