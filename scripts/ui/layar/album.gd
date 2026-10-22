class_name LayarAlbum
extends Control
## Album Stiker: foto kata yang sudah dikuasai jadi stiker koleksi.

signal minta(nama: String)

var _app: Node

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
	Komponen.bilah(v, "Album Stiker", func() -> void: minta.emit("menu"))
	var dimiliki: Array = _app.simpan.kata_dikuasai()
	var info := Gaya.label("Stikermu: %d dari %d — main Kata & Foto dan Susun Kata untuk mengumpulkan!" % [dimiliki.size(), Data.KATA.size()], 24, Gaya.TEKS_LEMBUT)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(info)
	var gulir := ScrollContainer.new()
	gulir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(gulir)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	gulir.add_child(grid)
	for k in Data.KATA:
		var nama := String(k["kata"])
		var punya: bool = dimiliki.has(nama)
		var sel := PanelContainer.new()
		sel.add_theme_stylebox_override("panel", Gaya.panel(24))
		var vb := VBoxContainer.new()
		vb.add_theme_constant_override("separation", 4)
		sel.add_child(vb)
		var foto := FotoKata.new(nama)
		foto.custom_minimum_size = Vector2(148, 148)
		if not punya:
			foto.modulate = Color(0.16, 0.16, 0.2, 0.55)
		vb.add_child(foto)
		var l := Gaya.label(nama if punya else "???", 26, Gaya.TEKS if punya else Gaya.TEKS_LEMBUT, true)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vb.add_child(l)
		grid.add_child(sel)
	_app.suara.narasi("album_buka")
