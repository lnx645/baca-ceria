class_name Suara
extends Node
## Pemutar audio: narasi (satu saluran, bisa berurutan) + sfx (polifoni kecil).

var _narasi: AudioStreamPlayer
var _sfx: Array[AudioStreamPlayer] = []
var _antre: Array[String] = []
var _pemain_musik: AudioStreamPlayer

func _init() -> void:
	_pemain_musik = AudioStreamPlayer.new()
	_pemain_musik.bus = "Master"
	add_child(_pemain_musik)
	_narasi = AudioStreamPlayer.new()
	_narasi.bus = "Master"
	add_child(_narasi)
	_narasi.finished.connect(_lanjut_antre)
	for i in 4:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_sfx.append(p)

func _muat(path: String) -> AudioStream:
	if ResourceLoader.exists(path):
		return load(path) as AudioStream
	return null

func _putar_narasi(path: String) -> void:
	var s := _muat(path)
	if s:
		_narasi.stream = s
		_narasi.play()

func huruf(h: String) -> void:
	_antre.clear()
	_putar_narasi("res://audio/huruf/%s.wav" % h)

func suku(s: String) -> void:
	_antre.clear()
	_putar_narasi("res://audio/suku/%s.wav" % s)

func kata(k: String) -> void:
	_antre.clear()
	_putar_narasi("res://audio/kata/%s.wav" % k)

func narasi(nama: String) -> void:
	_antre.clear()
	_putar_narasi("res://audio/narasi/%s.wav" % nama)

## Putar beberapa klip narasi berurutan, mis. prompt lalu targetnya.
func berurutan(daftar: Array) -> void:
	_antre.clear()
	for d in daftar:
		_antre.append(String(d))
	if not _antre.is_empty():
		_putar_narasi(_antre.pop_front())

func _lanjut_antre() -> void:
	if not _antre.is_empty():
		_putar_narasi(_antre.pop_front())

func sfx(nama: String) -> void:
	var s := _muat("res://audio/sfx/%s.wav" % nama)
	if s == null:
		return
	for p in _sfx:
		if not p.playing:
			p.stream = s
			p.play()
			return

func kalimat(teks: String) -> void:
	_putar_narasi("res://audio/kalimat/" + teks.to_lower().replace(" ", "_") + ".wav")

func latar_mulai() -> void:
	var jalur := "res://audio/musik/latar.wav"
	if not ResourceLoader.exists(jalur):
		return
	var aliran := load(jalur) as AudioStreamWAV
	if aliran == null:
		return
	aliran.loop_mode = AudioStreamWAV.LOOP_FORWARD
	aliran.loop_begin = 0
	aliran.loop_end = aliran.get_frames()
	_pemain_musik.stream = aliran
	_pemain_musik.volume_db = -26.0
	_pemain_musik.play()

func latar_stop() -> void:
	_pemain_musik.stop()
