class_name LayarKalimat
extends Control
## Kalimat Sederhana (Premium): Susun Kalimat dari chip kata + Baca Kalimat lantang.

signal minta(nama: String)

var _app: Node
var _isi: VBoxContainer
var _baris_mode: HBoxContainer
var _mode: String = "susun"
# Susun
var _pool: Array = []
var _ronde: int = 0
var _salah: int = 0
var _ini: Dictionary = {}
var _butuh: int = 0
var _slot_label: Array[Label] = []
var _baris_slot: HBoxContainer
var _baris_chip: HBoxContainer
var _gambar: FotoKata
# Baca
var _baca_ke: int = 0
var _label_kalimat: Button

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
	Komponen.bilah(v, "Kalimat Sederhana", func() -> void: minta.emit("menu"))
	_baris_mode = HBoxContainer.new()
	_baris_mode.add_theme_constant_override("separation", 14)
	v.add_child(_baris_mode)
	_segarkan_chip()
	_isi = VBoxContainer.new()
	_isi.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(_isi)
	_bangun_susun()
	_mulai_susun()

func _segarkan_chip() -> void:
	for anak in _baris_mode.get_children():
		anak.queue_free()
	var c1 := Komponen.chip("Susun", _mode == "susun", Gaya.UNGU)
	c1.pressed.connect(func() -> void: _ganti_mode("susun"))
	_baris_mode.add_child(c1)
	var c2 := Komponen.chip("Baca", _mode == "baca", Gaya.BIRU)
	c2.pressed.connect(func() -> void: _ganti_mode("baca"))
	_baris_mode.add_child(c2)

func _ganti_mode(mode: String) -> void:
	if mode == _mode:
		return
	_mode = mode
	_segarkan_chip()
	if mode == "susun":
		_bangun_susun()
		_mulai_susun()
	else:
		_bangun_baca()

func _bersihkan_isi() -> void:
	for anak in _isi.get_children():
		anak.queue_free()

func _lebar_kata(kata: String) -> float:
	return maxf(118.0, 30.0 * kata.length() + 46.0)

# --- SUSUN ---
func _bangun_susun() -> void:
	_bersihkan_isi()
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(tengah)
	var kartu := PanelContainer.new()
	kartu.add_theme_stylebox_override("panel", Gaya.panel(28))
	tengah.add_child(kartu)
	_gambar = FotoKata.new("kucing")
	_gambar.custom_minimum_size = Vector2(236, 236)
	kartu.add_child(_gambar)
	var baris_dengar := HBoxContainer.new()
	baris_dengar.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(baris_dengar)
	var dengar := Gaya.tombol("Dengarkan Kalimat", Gaya.ORANYE, 28)
	dengar.custom_minimum_size = Vector2(360, 72)
	dengar.pressed.connect(func() -> void:
		if not _ini.is_empty():
			_app.suara.kalimat(String(_ini["teks"])))
	baris_dengar.add_child(dengar)
	_baris_slot = HBoxContainer.new()
	_baris_slot.alignment = BoxContainer.ALIGNMENT_CENTER
	_baris_slot.add_theme_constant_override("separation", 12)
	_isi.add_child(_baris_slot)
	_baris_chip = HBoxContainer.new()
	_baris_chip.alignment = BoxContainer.ALIGNMENT_CENTER
	_baris_chip.add_theme_constant_override("separation", 12)
	_isi.add_child(_baris_chip)

func _mulai_susun() -> void:
	_pool = Data.KALIMAT.duplicate()
	_pool.shuffle()
	_ronde = 0
	_salah = 0
	_app.suara.narasi("kalimat_prompt")
	_ronde_baru()

func _ronde_baru() -> void:
	_ronde += 1
	if _ronde > 3:
		var bintang := 3 if _salah <= 1 else (2 if _salah <= 3 else 1)
		_app.simpan.catat_sesi("kalimat", bintang)
		Komponen.hasil(self, _app, bintang,
			func() -> void: _bangun_susun(); _mulai_susun(),
			func() -> void: minta.emit("menu"))
		return
	_ini = _pool[(_ronde - 1) % _pool.size()]
	_butuh = 0
	_gambar.id_kata = String(_ini["foto"])
	_gambar.queue_redraw()
	for anak in _baris_slot.get_children():
		anak.queue_free()
	_slot_label.clear()
	var katakata: Array = _ini["kata"]
	for k in katakata:
		var slot := PanelContainer.new()
		slot.add_theme_stylebox_override("panel", Gaya.panel(18))
		slot.custom_minimum_size = Vector2(_lebar_kata(String(k)), 86)
		var l := Gaya.judul("?", 40)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot.add_child(l)
		_baris_slot.add_child(slot)
		_slot_label.append(l)
	for anak in _baris_chip.get_children():
		anak.queue_free()
	var acak: Array = katakata.duplicate()
	acak.shuffle()
	for i in acak.size():
		var kata_ini := String(acak[i])
		var b := Gaya.tombol(kata_ini, Gaya.PERMEN[(i + 2) % Gaya.PERMEN.size()], 34)
		b.custom_minimum_size = Vector2(_lebar_kata(kata_ini), 86)
		b.pressed.connect(func() -> void: _ketuk_chip(b, kata_ini))
		_baris_chip.add_child(b)
	_app.suara.kalimat(String(_ini["teks"]))

func _ketuk_chip(b: Button, kata: String) -> void:
	var benar: Array = _ini["kata"]
	if _butuh < benar.size() and kata == String(benar[_butuh]):
		_slot_label[_butuh].text = kata
		_butuh += 1
		b.disabled = true
		b.modulate = Color(1, 1, 1, 0.25)
		_app.suara.kata(kata)
		if _butuh >= benar.size():
			await get_tree().create_timer(0.5).timeout
			if not is_inside_tree():
				return
			_app.suara.sfx("hore")
			_app.suara.kalimat(String(_ini["teks"]))
			await get_tree().create_timer(1.6).timeout
			if is_inside_tree():
				_ronde_baru()
	else:
		_salah += 1
		_app.suara.sfx("lembut")
		var tw := b.create_tween()
		var x0 := b.position.x
		tw.tween_property(b, "position:x", x0 - 8, 0.05)
		tw.tween_property(b, "position:x", x0 + 8, 0.05)
		tw.tween_property(b, "position:x", x0, 0.05)

# --- BACA ---
func _bangun_baca() -> void:
	_bersihkan_isi()
	_baca_ke = 0
	_pool = Data.KALIMAT.duplicate()
	_pool.shuffle()
	_tampil_baca()

func _tampil_baca() -> void:
	_bersihkan_isi()
	if _baca_ke >= 3:
		_app.simpan.catat_sesi("kalimat", 3)
		Komponen.hasil(self, _app, 3,
			func() -> void: _bangun_baca(),
			func() -> void: minta.emit("menu"))
		return
	var d: Dictionary = _pool[_baca_ke % _pool.size()]
	var teks := String(d["teks"])
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(tengah)
	var kartu := PanelContainer.new()
	kartu.add_theme_stylebox_override("panel", Gaya.panel(28))
	tengah.add_child(kartu)
	var foto := FotoKata.new(String(d["foto"]))
	foto.custom_minimum_size = Vector2(300, 300)
	kartu.add_child(foto)
	_label_kalimat = Gaya.tombol(teks + ".", Gaya.BIRU, 44)
	_label_kalimat.custom_minimum_size = Vector2(652, 130)
	_label_kalimat.pressed.connect(func() -> void: _app.suara.kalimat(teks))
	_isi.add_child(_label_kalimat)
	var info := Gaya.label("Ketuk kalimatnya untuk mendengar, lalu baca dengan suara lantang!", 24, Gaya.TEKS_LEMBUT)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_isi.add_child(info)
	var baris := HBoxContainer.new()
	baris.alignment = BoxContainer.ALIGNMENT_CENTER
	_isi.add_child(baris)
	var sudah := Gaya.tombol("Sudah Baca!", Gaya.HIJAU, 32)
	sudah.custom_minimum_size = Vector2(320, 88)
	sudah.pressed.connect(func() -> void:
		_app.suara.sfx("pop")
		_app.suara.narasi("selesai_baca")
		_baca_ke += 1
		await get_tree().create_timer(0.9).timeout
		if is_inside_tree():
			_tampil_baca())
	baris.add_child(sudah)
	_app.suara.narasi("baca_prompt")
	_app.suara.kalimat(teks)
