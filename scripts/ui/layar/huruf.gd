class_name LayarHuruf
extends Control
## Belajar Huruf: mode Belajar (ketuk huruf = bunyi) + mode Kuis (tebak huruf dari bunyi).

signal minta(nama: String)

var _app: Node
var _mode: String = "belajar"
var _isi: VBoxContainer
var _baris_mode: HBoxContainer
var _chip_belajar: Button
var _chip_kuis: Button
var _pratinjau: Label
# Kuis
var _ronde: int = 0
var _salah: int = 0
var _target: String = ""
var _terkunci: bool = false
var _kotak_opsi: GridContainer
var _label_ronde: Label

func siapkan(app: Node) -> void:
	_app = app
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 32)
	margin.add_theme_constant_override("margin_right", 32)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 14)
	margin.add_child(v)
	Komponen.bilah(v, "Belajar Huruf", func() -> void: minta.emit("menu"))
	_baris_mode = HBoxContainer.new()
	_baris_mode.add_theme_constant_override("separation", 14)
	v.add_child(_baris_mode)
	_segarkan_chip()
	_isi = VBoxContainer.new()
	_isi.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(_isi)
	_bangun_belajar()

func _segarkan_chip() -> void:
	for anak in _baris_mode.get_children():
		anak.queue_free()
	_chip_belajar = Komponen.chip("Belajar", _mode == "belajar", Gaya.BIRU)
	_chip_belajar.pressed.connect(func() -> void: _ganti_mode("belajar"))
	_baris_mode.add_child(_chip_belajar)
	_chip_kuis = Komponen.chip("Kuis", _mode == "kuis", Gaya.ORANYE)
	_chip_kuis.pressed.connect(func() -> void: _ganti_mode("kuis"))
	_baris_mode.add_child(_chip_kuis)

func _ganti_mode(mode: String) -> void:
	if mode == _mode:
		return
	_mode = mode
	_segarkan_chip()
	_bersihkan_isi()
	if mode == "belajar":
		_bangun_belajar()
	else:
		_bangun_kuis()
		_mulai_kuis()

func _bersihkan_isi() -> void:
	for anak in _isi.get_children():
		anak.queue_free()

func _bangun_belajar() -> void:
	_bersihkan_isi()
	_app.suara.narasi("pilih_huruf")
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(tengah)
	_pratinjau = Gaya.judul("Aa", 120)
	_pratinjau.add_theme_color_override("font_color", Gaya.PERMEN[4])
	tengah.add_child(_pratinjau)
	var gulir := ScrollContainer.new()
	gulir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_isi.add_child(gulir)
	var grid := GridContainer.new()
	grid.columns = 5
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	gulir.add_child(grid)
	for i in Data.HURUF.size():
		var h := Data.HURUF[i]
		var b := Gaya.tombol(h.to_upper(), Gaya.PERMEN[i % Gaya.PERMEN.size()], 50)
		b.custom_minimum_size = Vector2(118, 102)
		var huruf_ini := h
		var idx := i
		b.pressed.connect(func() -> void:
			_pratinjau.text = huruf_ini.to_upper() + huruf_ini
			_pratinjau.add_theme_color_override("font_color", Gaya.PERMEN[idx % Gaya.PERMEN.size()])
			_app.suara.sfx("pop")
			_app.suara.huruf(huruf_ini))
		grid.add_child(b)

func _bangun_kuis() -> void:
	_bersihkan_isi()
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
	var sp := Control.new()
	sp.custom_minimum_size = Vector2(0, 26)
	_isi.add_child(sp)
	_kotak_opsi = GridContainer.new()
	_kotak_opsi.columns = 2
	_kotak_opsi.add_theme_constant_override("h_separation", 22)
	_kotak_opsi.add_theme_constant_override("v_separation", 22)
	var bungkus := HBoxContainer.new()
	bungkus.alignment = BoxContainer.ALIGNMENT_CENTER
	bungkus.add_child(_kotak_opsi)
	_isi.add_child(bungkus)

func _mulai_kuis() -> void:
	_ronde = 0
	_salah = 0
	_ronde_baru()

func _ronde_baru() -> void:
	_ronde += 1
	if _ronde > 5:
		_selesai_kuis()
		return
	_terkunci = false
	_label_ronde.text = "Soal %d dari 5" % _ronde
	_target = Data.HURUF[randi() % Data.HURUF.size()]
	var opsi: Array[String] = [_target]
	while opsi.size() < 4:
		var acak := Data.HURUF[randi() % Data.HURUF.size()]
		if not opsi.has(acak):
			opsi.append(acak)
	opsi.shuffle()
	for anak in _kotak_opsi.get_children():
		anak.queue_free()
	for h in opsi:
		var b := Gaya.tombol(h.to_upper(), Gaya.PERMEN[randi() % Gaya.PERMEN.size()], 104)
		b.custom_minimum_size = Vector2(250, 180)
		var huruf_ini := h
		b.pressed.connect(func() -> void: _jawab(b, huruf_ini))
		_kotak_opsi.add_child(b)
	_suara_soal()

func _suara_soal() -> void:
	if _target != "":
		_app.suara.berurutan(["res://audio/narasi/mana_huruf.wav", "res://audio/huruf/%s.wav" % _target])

func _jawab(b: Button, h: String) -> void:
	if _terkunci:
		return
	if h == _target:
		_terkunci = true
		_app.suara.sfx("pop")
		_app.suara.narasi(Data.PUJIAN[randi() % Data.PUJIAN.size()])
		b.modulate = Color(0.75, 1.4, 0.75)
		await get_tree().create_timer(1.25).timeout
		if is_inside_tree():
			_ronde_baru()
	else:
		_salah += 1
		b.disabled = true
		b.modulate = Color(0.75, 0.75, 0.75, 0.6)
		_app.suara.sfx("lembut")
		if _salah % 2 == 1:
			_app.suara.narasi("coba_lagi")

func _selesai_kuis() -> void:
	var bintang := 3 if _salah <= 1 else (2 if _salah <= 3 else 1)
	_app.simpan.catat_sesi("huruf", bintang)
	Komponen.hasil(self, _app, bintang,
		func() -> void: _bangun_kuis(); _mulai_kuis(),
		func() -> void: minta.emit("menu"))
