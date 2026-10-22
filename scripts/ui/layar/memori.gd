class_name LayarMemori
extends Control
## Kartu Memori (Premium): balik kartu, pasangkan foto dengan katanya (3 pasang).

signal minta(nama: String)

var _app: Node
var _grid: GridContainer
var _label_info: Label
var _kartu: Array = []  # {tombol, kata, jenis, status, muka, punggung}
var _terbuka: Array = []
var _pasang_cocok: int = 0
var _percobaan: int = 0
var _sibuk: bool = false

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
	Komponen.bilah(v, "Kartu Memori", func() -> void: minta.emit("menu"))
	_label_info = Gaya.label("Temukan 3 pasangan foto dan katanya!", 26, Gaya.TEKS_LEMBUT)
	_label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(_label_info)
	var bungkus := HBoxContainer.new()
	bungkus.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(bungkus)
	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.add_theme_constant_override("h_separation", 14)
	_grid.add_theme_constant_override("v_separation", 14)
	bungkus.add_child(_grid)
	_mulai()

func _mulai() -> void:
	_kartu.clear()
	_terbuka.clear()
	_pasang_cocok = 0
	_percobaan = 0
	_sibuk = false
	for anak in _grid.get_children():
		anak.queue_free()
	var pool: Array = Data.KATA.duplicate()
	pool.shuffle()
	var pilihan: Array = pool.slice(0, 3)
	var deck: Array = []
	for k in pilihan:
		deck.append({"kata": String(k["kata"]), "jenis": "foto"})
		deck.append({"kata": String(k["kata"]), "jenis": "kata"})
	deck.shuffle()
	for i in deck.size():
		var d: Dictionary = deck[i]
		var b := Button.new()
		b.custom_minimum_size = Vector2(204, 268)
		b.add_theme_stylebox_override("normal", Gaya.panel(26))
		b.add_theme_stylebox_override("hover", Gaya.panel(26))
		b.add_theme_stylebox_override("pressed", Gaya.panel(26))
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		b.resized.connect(func() -> void: b.pivot_offset = b.size / 2.0)
		var punggung := Gaya.judul("?", 84)
		punggung.mouse_filter = Control.MOUSE_FILTER_IGNORE
		punggung.add_theme_color_override("font_color", Gaya.PINK)
		punggung.set_anchors_preset(Control.PRESET_FULL_RECT)
		punggung.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		punggung.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		b.add_child(punggung)
		var muka: Control
		if String(d["jenis"]) == "foto":
			var f := FotoKata.new(String(d["kata"]))
			f.set_anchors_preset(Control.PRESET_FULL_RECT)
			muka = f
		else:
			var l := Gaya.judul(String(d["kata"]), 46)
			l.add_theme_color_override("font_color", Gaya.UNGU)
			l.set_anchors_preset(Control.PRESET_FULL_RECT)
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			muka = l
		muka.mouse_filter = Control.MOUSE_FILTER_IGNORE
		muka.visible = false
		b.add_child(muka)
		var data := {"tombol": b, "kata": String(d["kata"]), "jenis": String(d["jenis"]),
			"status": "tutup", "muka": muka, "punggung": punggung}
		_kartu.append(data)
		var idx := i
		b.pressed.connect(func() -> void: _ketuk(idx))
		_grid.add_child(b)
	_app.suara.narasi("memori_prompt")

func _balik(data: Dictionary, buka: bool) -> void:
	var b: Button = data["tombol"]
	var tw := b.create_tween()
	tw.tween_property(b, "scale:x", 0.0, 0.13)
	tw.tween_callback(func() -> void:
		(data["muka"] as Control).visible = buka
		(data["punggung"] as Control).visible = not buka)
	tw.tween_property(b, "scale:x", 1.0, 0.13)

func _ketuk(idx: int) -> void:
	if _sibuk:
		return
	var data: Dictionary = _kartu[idx]
	if String(data["status"]) != "tutup":
		return
	data["status"] = "terbuka"
	_terbuka.append(idx)
	_balik(data, true)
	_app.suara.sfx("pop")
	if String(data["jenis"]) == "kata":
		_app.suara.kata(String(data["kata"]))
	if _terbuka.size() < 2:
		return
	_percobaan += 1
	var a: Dictionary = _kartu[int(_terbuka[0])]
	var b2: Dictionary = _kartu[int(_terbuka[1])]
	if String(a["kata"]) == String(b2["kata"]):
		a["status"] = "cocok"
		b2["status"] = "cocok"
		(a["tombol"] as Button).modulate = Color(0.82, 1.3, 0.82)
		(b2["tombol"] as Button).modulate = Color(0.82, 1.3, 0.82)
		_terbuka.clear()
		_pasang_cocok += 1
		_app.simpan.tandai_kata(String(a["kata"]))
		await get_tree().create_timer(0.4).timeout
		if not is_inside_tree():
			return
		_app.suara.narasi(Data.PUJIAN[randi() % Data.PUJIAN.size()])
		if _pasang_cocok >= 3:
			await get_tree().create_timer(0.8).timeout
			if is_inside_tree():
				var bintang := 3 if _percobaan <= 5 else (2 if _percobaan <= 8 else 1)
				_app.simpan.catat_sesi("memori", bintang)
				Komponen.hasil(self, _app, bintang,
					func() -> void: _mulai(),
					func() -> void: minta.emit("menu"))
	else:
		_sibuk = true
		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return
		a["status"] = "tutup"
		b2["status"] = "tutup"
		_balik(a, false)
		_balik(b2, false)
		_app.suara.sfx("lembut")
		_terbuka.clear()
		_sibuk = false
