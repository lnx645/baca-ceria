class_name LayarTulis
extends Control
## Tulis Huruf: telusuri titik-titik jalur huruf besar dengan jari.

signal minta(nama: String)

class AreaJalur:
	extends Control
	signal huruf_selesai
	signal titik_kena
	var huruf_ini: String = "a"
	var goresan: Array = []  # goresan -> titik-titik (ruang 100x140, sudah direnggangkan)
	var gi: int = 0
	var ti: int = 0
	var selesai: bool = false
	var _menekan: bool = false

	func atur(h: String) -> void:
		huruf_ini = h
		gi = 0
		ti = 0
		selesai = false
		goresan.clear()
		var mentah: Array = JalurHuruf.JALUR.get(h, [])
		for g in mentah:
			var titik: Array = []
			var jmaj: Array = g
			if jmaj.size() >= 2:
				titik.append(jmaj[0])
				for i in range(1, jmaj.size()):
					var a: Vector2 = jmaj[i - 1]
					var b: Vector2 = jmaj[i]
					var jarak := a.distance_to(b)
					var langkah := 11.0
					var t := langkah
					while t < jarak:
						titik.append(a.lerp(b, t / jarak))
						t += langkah
					titik.append(b)
			goresan.append(titik)
		queue_redraw()

	func _skala() -> float:
		return minf(size.x / 110.0, size.y / 150.0)

	func _lokal(p: Vector2) -> Vector2:
		var s := _skala()
		var geser := (size - Vector2(100, 140) * s) / 2.0
		return geser + p * s

	func _process(_d: float) -> void:
		queue_redraw()

	func _draw() -> void:
		if goresan.is_empty():
			return
		var s := _skala()
		var geser := (size - Vector2(100, 140) * s) / 2.0
		draw_string(Gaya.font_judul(), geser + Vector2(0, 138 * s), huruf_ini.to_upper(),
			HORIZONTAL_ALIGNMENT_CENTER, 100 * s, int(150 * s), Color(0.35, 0.3, 0.5, 0.13))
		for gi2 in goresan.size():
			var titik: Array = goresan[gi2]
			var kemasan := PackedVector2Array()
			for p in titik:
				kemasan.append(_lokal(p))
			draw_polyline(kemasan, Color(0, 0, 0, 0.07), 2.6 * s, true)
			for ti2 in titik.size():
				var pos := _lokal(titik[ti2])
				var kena: bool = gi2 < gi or (gi2 == gi and ti2 < ti)
				if kena:
					draw_circle(pos, 2.3 * s, Gaya.HIJAU)
				elif gi2 == gi and ti2 == ti and not selesai:
					var denyut := 2.9 + 0.5 * sin(Time.get_ticks_msec() / 220.0)
					draw_circle(pos, denyut * s, Gaya.EMAS)
					draw_circle(pos, 2.0 * s, Gaya.ORANYE)
				else:
					draw_circle(pos, 1.7 * s, Color(0.55, 0.5, 0.6, 0.75))

	func _cek(pos: Vector2) -> void:
		if selesai or gi >= goresan.size():
			return
		var titik: Array = goresan[gi]
		if ti >= titik.size():
			return
		var target := _lokal(titik[ti])
		if pos.distance_to(target) <= 4.8 * _skala():
			ti += 1
			titik_kena.emit()
			if ti >= titik.size():
				gi += 1
				ti = 0
				if gi >= goresan.size():
					selesai = true
					huruf_selesai.emit()
			queue_redraw()

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			_menekan = event.pressed
			if _menekan:
				_cek(event.position)
		elif event is InputEventMouseMotion and _menekan:
			_cek(event.position)
		elif event is InputEventScreenTouch:
			_menekan = event.pressed
			if _menekan:
				_cek(event.position)
		elif event is InputEventScreenDrag:
			_cek(event.position)

var _app: Node
var _area: AreaJalur
var _indeks: int = 0
var _label_huruf: Label
var _label_progres: Label
var _selesai_total: int = 0
var _sudah_dicatat: int = 0

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
	v.add_theme_constant_override("separation", 12)
	margin.add_child(v)
	Komponen.bilah(v, "Tulis Huruf", func() -> void: minta.emit("menu"))
	var nav := HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation", 16)
	v.add_child(nav)
	var sebelum := Gaya.tombol("<", Gaya.BIRU, 36)
	sebelum.custom_minimum_size = Vector2(84, 72)
	sebelum.pressed.connect(func() -> void: _pindah(-1))
	nav.add_child(sebelum)
	_label_huruf = Gaya.judul("A", 72)
	_label_huruf.custom_minimum_size = Vector2(120, 84)
	_label_huruf.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nav.add_child(_label_huruf)
	var sesudah := Gaya.tombol(">", Gaya.BIRU, 36)
	sesudah.custom_minimum_size = Vector2(84, 72)
	sesudah.pressed.connect(func() -> void: _pindah(1))
	nav.add_child(sesudah)
	var ulang := Gaya.tombol("Ulang", Gaya.ORANYE, 26)
	ulang.custom_minimum_size = Vector2(130, 72)
	ulang.pressed.connect(func() -> void: _area.atur(Data.HURUF[_indeks]))
	nav.add_child(ulang)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", Gaya.panel(30))
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(panel)
	_area = AreaJalur.new()
	_area.custom_minimum_size = Vector2(640, 690)
	_area.huruf_selesai.connect(_on_huruf_selesai)
	_area.titik_kena.connect(func() -> void: _app.suara.sfx("pop"))
	panel.add_child(_area)
	_label_progres = Gaya.label("Ikuti titik emas dengan jarimu ya!", 25, Gaya.TEKS_LEMBUT)
	_label_progres.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(_label_progres)
	var gulir := ScrollContainer.new()
	gulir.custom_minimum_size = Vector2(0, 78)
	gulir.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(gulir)
	var baris := HBoxContainer.new()
	baris.add_theme_constant_override("separation", 8)
	gulir.add_child(baris)
	for i in Data.HURUF.size():
		var h := Data.HURUF[i]
		var b := Gaya.tombol(h.to_upper(), Gaya.PERMEN[i % Gaya.PERMEN.size()], 26)
		b.custom_minimum_size = Vector2(62, 62)
		var idx := i
		b.pressed.connect(func() -> void: _ke_indeks(idx))
		baris.add_child(b)
	_ke_indeks(0)
	_app.suara.narasi("tulis_prompt")

func _ke_indeks(i: int) -> void:
	_indeks = clampi(i, 0, Data.HURUF.size() - 1)
	var h := Data.HURUF[_indeks]
	_label_huruf.text = h.to_upper()
	_label_huruf.add_theme_color_override("font_color", Gaya.PERMEN[_indeks % Gaya.PERMEN.size()])
	_area.atur(h)

func _pindah(delta: int) -> void:
	_app.suara.sfx("pop")
	_ke_indeks(_indeks + delta)

func _on_huruf_selesai() -> void:
	_selesai_total += 1
	_app.suara.sfx("hore")
	_app.suara.berurutan(["res://audio/huruf/%s.wav" % Data.HURUF[_indeks],
		"res://audio/narasi/%s.wav" % Data.PUJIAN[randi() % Data.PUJIAN.size()]])
	_label_progres.text = "Huruf selesai ditulis: %d — hebat!" % _selesai_total
	if _selesai_total % 3 == 0 and _sudah_dicatat < _selesai_total:
		_sudah_dicatat = _selesai_total
		_app.simpan.catat_sesi("tulis", 3)
	await get_tree().create_timer(1.8).timeout
	if is_inside_tree() and _indeks < Data.HURUF.size() - 1:
		_ke_indeks(_indeks + 1)
