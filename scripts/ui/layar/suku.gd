class_name LayarSuku
extends Control
## Suku Kata: mode Belajar (ketuk suku kata) + Susun Kata (rangkai suku kata jadi kata).

signal minta(nama: String)

var _app: Node
var _isi: VBoxContainer
var _baris_mode: HBoxContainer
var _chip_belajar: Button
var _chip_susun: Button
var _mode: String = "belajar"
var _konsonan_ini: String = "b"
var _tampilan: Label
var _baris_vokal: HBoxContainer
var _baris_konsonan: HBoxContainer
# Susun kata
var _antre: Array = []
var _kata_ini: Dictionary = {}
var _butuh: int = 0
var _salah: int = 0
var _jumlah_selesai: int = 0
var _slot_label: Array[Label] = []
var _gambar: GambarKata
var _baris_chip: HBoxContainer
var _baris_slot: HBoxContainer

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
	v.add_theme_constant_override("separation", 14)
	margin.add_child(v)
	Komponen.bilah(v, "Suku Kata", func() -> void: minta.emit("menu"))
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
	_chip_belajar = Komponen.chip("Belajar", _mode == "belajar", Gaya.HIJAU)
	_chip_belajar.pressed.connect(func() -> void: _ganti_mode("belajar"))
	_baris_mode.add_child(_chip_belajar)
	_chip_susun = Komponen.chip("Susun Kata", _mode == "susun", Gaya.UNGU)
	_chip_susun.pressed.connect(func() -> void: _ganti_mode("susun"))
	_baris_mode.add_child(_chip_susun)

func _ganti_mode(mode: String) -> void:
	if mode == _mode:
		return
	_mode = mode
	_segarkan_chip()
	if mode == "belajar":
		_bangun_belajar()
	else:
		_bangun_susun()
		_mulai_susun()

func _bersihkan_isi() -> void:
	for anak in _isi.get_children():
		anak.queue_free()

func _bangun_belajar() -> void:
	_bersihkan_isi()
	_app.suara.narasi("belajar_suku")
	_baris_konsonan = HBoxContainer.new()
	_baris_konsonan.alignment = BoxContainer.ALIGNMENT_CENTER
	_baris_konsonan.add_theme_constant_override("separation", 10)
	_isi.add_child(_baris_konsonan)
	_segarkan_konsonan()
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(tengah)
	_tampilan = Gaya.judul("ba", 190)
	_tampilan.add_theme_color_override("font_color", Gaya.UNGU)
	tengah.add_child(_tampilan)
	_baris_vokal = HBoxContainer.new()
	_baris_vokal.alignment = BoxContainer.ALIGNMENT_CENTER
	_baris_vokal.add_theme_constant_override("separation", 16)
	_isi.add_child(_baris_vokal)
	_segarkan_vokal()

func _segarkan_konsonan() -> void:
	for anak in _baris_konsonan.get_children():
		anak.queue_free()
	for i in Data.KONSONAN.size():
		var k := Data.KONSONAN[i]
		var b := Gaya.tombol(k, Gaya.UNGU if k == _konsonan_ini else Color("B8C4CC"), 36)
		b.custom_minimum_size = Vector2(78, 70)
		var k_ini := k
		b.pressed.connect(func() -> void:
			_konsonan_ini = k_ini
			_segarkan_konsonan()
			_segarkan_vokal()
			_app.suara.sfx("pop"))
		_baris_konsonan.add_child(b)

func _segarkan_vokal() -> void:
	for anak in _baris_vokal.get_children():
		anak.queue_free()
	for i in Data.VOKAL.size():
		var s := _konsonan_ini + Data.VOKAL[i]
		var b := Gaya.tombol(s, Gaya.PERMEN[i % Gaya.PERMEN.size()], 76)
		b.custom_minimum_size = Vector2(168, 138)
		var s_ini := s
		b.pressed.connect(func() -> void:
			_tampilan.text = s_ini
			_app.suara.sfx("pop")
			_app.suara.suku(s_ini))
		_baris_vokal.add_child(b)

func _bangun_susun() -> void:
	_bersihkan_isi()
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 30)
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(h)
	var kartu := PanelContainer.new()
	kartu.add_theme_stylebox_override("panel", Gaya.panel(30))
	h.add_child(kartu)
	_gambar = GambarKata.new("bola")
	_gambar.custom_minimum_size = Vector2(250, 200)
	kartu.add_child(_gambar)
	var kanan := VBoxContainer.new()
	kanan.add_theme_constant_override("separation", 20)
	h.add_child(kanan)
	var dengar := Gaya.tombol("Dengarkan Kata", Gaya.ORANYE, 30)
	dengar.custom_minimum_size = Vector2(300, 74)
	dengar.pressed.connect(func() -> void:
		if not _kata_ini.is_empty():
			_app.suara.kata(String(_kata_ini["kata"])))
	kanan.add_child(dengar)
	_baris_slot = HBoxContainer.new()
	_baris_slot.add_theme_constant_override("separation", 14)
	kanan.add_child(_baris_slot)
	_baris_chip = HBoxContainer.new()
	_baris_chip.add_theme_constant_override("separation", 14)
	kanan.add_child(_baris_chip)

func _mulai_susun() -> void:
	_antre = Data.KATA.duplicate()
	_antre.shuffle()
	_jumlah_selesai = 0
	_salah = 0
	_app.suara.narasi("susun_kata")
	_kata_baru()

func _kata_baru() -> void:
	if _jumlah_selesai >= 4:
		_selesai_susun()
		return
	_kata_ini = _antre[_jumlah_selesai % _antre.size()]
	_butuh = 0
	_gambar.id_kata = String(_kata_ini["kata"])
	_gambar.queue_redraw()
	# Slot kosong
	for anak in _baris_slot.get_children():
		anak.queue_free()
	_slot_label.clear()
	var suku_benar: Array = _kata_ini["suku"]
	for s in suku_benar:
		var slot := PanelContainer.new()
		slot.add_theme_stylebox_override("panel", Gaya.panel(20))
		slot.custom_minimum_size = Vector2(140, 108)
		var l := Gaya.judul("?", 54)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.add_child(l)
		_baris_slot.add_child(slot)
		_slot_label.append(l)
	# Chip: suku benar + 1 pengecoh
	for anak in _baris_chip.get_children():
		anak.queue_free()
	var chip_teks: Array[String] = []
	for s in suku_benar:
		chip_teks.append(String(s))
	var pengecoh := ""
	while pengecoh == "" or chip_teks.has(pengecoh):
		var lain: Dictionary = Data.KATA[randi() % Data.KATA.size()]
		var daftar: Array = lain["suku"]
		pengecoh = String(daftar[randi() % daftar.size()])
	chip_teks.append(pengecoh)
	chip_teks.shuffle()
	for i in chip_teks.size():
		var b := Gaya.tombol(chip_teks[i], Gaya.PERMEN[i % Gaya.PERMEN.size()], 52)
		b.custom_minimum_size = Vector2(140, 100)
		var teks_ini := chip_teks[i]
		b.pressed.connect(func() -> void: _ketuk_chip(b, teks_ini))
		_baris_chip.add_child(b)
	_app.suara.kata(String(_kata_ini["kata"]))

func _ketuk_chip(b: Button, teks: String) -> void:
	var suku_benar: Array = _kata_ini["suku"]
	if _butuh < suku_benar.size() and teks == String(suku_benar[_butuh]):
		_slot_label[_butuh].text = teks
		_butuh += 1
		b.disabled = true
		b.modulate = Color(1, 1, 1, 0.25)
		_app.suara.suku(teks)
		if _butuh >= suku_benar.size():
			_jumlah_selesai += 1
			await get_tree().create_timer(0.55).timeout
			if not is_inside_tree():
				return
			_app.suara.sfx("hore")
			_app.suara.kata(String(_kata_ini["kata"]))
			await get_tree().create_timer(1.3).timeout
			if is_inside_tree():
				_kata_baru()
	else:
		_salah += 1
		_app.suara.sfx("lembut")
		var tw := b.create_tween()
		var x0 := b.position.x
		tw.tween_property(b, "position:x", x0 - 8, 0.05)
		tw.tween_property(b, "position:x", x0 + 8, 0.05)
		tw.tween_property(b, "position:x", x0, 0.05)

func _selesai_susun() -> void:
	var bintang := 3 if _salah <= 1 else (2 if _salah <= 4 else 1)
	_app.simpan.catat_sesi("suku", bintang)
	Komponen.hasil(self, _app, bintang,
		func() -> void: _bangun_susun(); _mulai_susun(),
		func() -> void: minta.emit("menu"))
