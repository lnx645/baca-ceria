class_name LayarKata
extends Control
## Kata Bergambar: dengarkan kata, ketuk gambar yang benar (5 soal).

signal minta(nama: String)

var _app: Node
var _isi: VBoxContainer
var _ronde: int = 0
var _salah: int = 0
var _target: String = ""
var _terkunci: bool = false
var _baris_kartu: HBoxContainer
var _label_ronde: Label

func siapkan(app: Node) -> void:
	_app = app
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 44)
	margin.add_theme_constant_override("margin_right", 44)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	margin.add_child(v)
	Komponen.bilah(v, "Kata Bergambar", func() -> void: minta.emit("menu"))
	_isi = VBoxContainer.new()
	_isi.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(_isi)
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	tengah.add_theme_constant_override("separation", 18)
	_isi.add_child(tengah)
	_label_ronde = Gaya.label("Soal 1 dari 5", 28, Gaya.TEKS_LEMBUT, true)
	tengah.add_child(_label_ronde)
	var dengar := Gaya.tombol("Dengarkan", Gaya.ORANYE, 28)
	dengar.custom_minimum_size = Vector2(220, 66)
	dengar.pressed.connect(func() -> void: _suara_soal())
	tengah.add_child(dengar)
	_baris_kartu = HBoxContainer.new()
	_baris_kartu.alignment = BoxContainer.ALIGNMENT_CENTER
	_baris_kartu.add_theme_constant_override("separation", 24)
	_isi.add_child(_baris_kartu)
	_mulai()

func _mulai() -> void:
	_ronde = 0
	_salah = 0
	_ronde_baru()

func _ronde_baru() -> void:
	_ronde += 1
	if _ronde > 5:
		_selesai()
		return
	_terkunci = false
	_label_ronde.text = "Soal %d dari 5" % _ronde
	var semua: Array = Data.KATA.duplicate()
	semua.shuffle()
	_target = String(semua[0]["kata"])
	var opsi: Array = [semua[0], semua[1], semua[2]]
	opsi.shuffle()
	for anak in _baris_kartu.get_children():
		anak.queue_free()
	for k in opsi:
		var kata_ini := String(k["kata"])
		var kartu := Button.new()
		kartu.custom_minimum_size = Vector2(300, 300)
		kartu.add_theme_stylebox_override("normal", Gaya.panel(30))
		kartu.add_theme_stylebox_override("hover", Gaya.panel(30))
		kartu.add_theme_stylebox_override("pressed", Gaya.panel(30))
		kartu.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var g := FotoKata.new(kata_ini)
		g.set_anchors_preset(Control.PRESET_FULL_RECT)
		kartu.add_child(g)
		kartu.pressed.connect(func() -> void: _jawab(kartu, kata_ini))
		_baris_kartu.add_child(kartu)
	_suara_soal()

func _suara_soal() -> void:
	if _target != "":
		_app.suara.berurutan(["res://audio/narasi/mana_kata.wav", "res://audio/kata/%s.wav" % _target])

func _jawab(kartu: Button, kata: String) -> void:
	if _terkunci:
		return
	if kata == _target:
		_terkunci = true
		_app.suara.sfx("pop")
		_app.suara.narasi(Data.PUJIAN[randi() % Data.PUJIAN.size()])
		kartu.modulate = Color(0.8, 1.35, 0.8)
		await get_tree().create_timer(1.25).timeout
		if is_inside_tree():
			_ronde_baru()
	else:
		_salah += 1
		kartu.disabled = true
		kartu.modulate = Color(0.8, 0.8, 0.8, 0.55)
		_app.suara.sfx("lembut")
		if _salah % 2 == 1:
			_app.suara.narasi("coba_lagi")

func _selesai() -> void:
	var bintang := 3 if _salah <= 1 else (2 if _salah <= 3 else 1)
	_app.simpan.catat_sesi("kata", bintang)
	Komponen.hasil(self, _app, bintang,
		func() -> void: _mulai(),
		func() -> void: minta.emit("menu"))
