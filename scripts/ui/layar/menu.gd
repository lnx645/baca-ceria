class_name LayarMenu
extends Control
## Menu utama (portrait): judul pelangi, Kiko, grid 6 mode, Album, profil & musik.

signal minta(nama: String)

var _app: Node
var _tahan: Timer
var _label_bintang: Label
var _chip_profil: Button

func siapkan(app: Node) -> void:
	_app = app
	_bangun()
	if not app.halo_dimainkan:
		app.halo_dimainkan = true
		app.suara.narasi("halo")

func _bangun() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 32)
	margin.add_theme_constant_override("margin_right", 32)
	margin.add_theme_constant_override("margin_top", 26)
	margin.add_theme_constant_override("margin_bottom", 22)
	add_child(margin)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 14)
	margin.add_child(v)
	# Judul pelangi di tengah
	var judul := HBoxContainer.new()
	judul.alignment = BoxContainer.ALIGNMENT_CENTER
	judul.add_theme_constant_override("separation", 2)
	v.add_child(judul)
	var kata := "BACA CERIA"
	for i in kata.length():
		var huruf := kata[i]
		var l := Gaya.judul(" " if huruf == " " else huruf, 66)
		l.add_theme_color_override("font_color", Gaya.PERMEN[i % Gaya.PERMEN.size()])
		l.rotation = deg_to_rad(-3.0 if i % 2 == 0 else 3.0)
		judul.add_child(l)
	var sub := Gaya.label("Belajar membaca sambil bermain!", 28, Gaya.TEKS)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(sub)
	# Kiko + info
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	tengah.add_theme_constant_override("separation", 16)
	v.add_child(tengah)
	var kiko := Maskot.new()
	kiko.custom_minimum_size = Vector2(185, 200)
	tengah.add_child(kiko)
	var info := VBoxContainer.new()
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 10)
	tengah.add_child(info)
	var baris_bintang := HBoxContainer.new()
	baris_bintang.add_theme_constant_override("separation", 8)
	info.add_child(baris_bintang)
	baris_bintang.add_child(Bintang.new(true, 38))
	_label_bintang = Gaya.label("%d bintang" % _app.simpan.total_bintang(), 28, Gaya.TEKS_LEMBUT, true)
	_label_bintang.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	baris_bintang.add_child(_label_bintang)
	_chip_profil = Gaya.tombol("Yang main: " + _app.simpan.profil_aktif(), Gaya.BIRU, 23)
	_chip_profil.custom_minimum_size = Vector2(330, 62)
	_chip_profil.pressed.connect(func() -> void: _pilih_profil())
	info.add_child(_chip_profil)
	var musik := Gaya.tombol("Musik: Nyala" if _app.simpan.musik_nyala() else "Musik: Mati", Gaya.UNGU, 23)
	musik.custom_minimum_size = Vector2(330, 62)
	musik.pressed.connect(func() -> void:
		var nyala: bool = not _app.simpan.musik_nyala()
		_app.simpan.set_musik(nyala)
		musik.text = "Musik: Nyala" if nyala else "Musik: Mati"
		if nyala:
			_app.suara.latar_mulai()
		else:
			_app.suara.latar_stop())
	info.add_child(musik)
	# Grid mode 2 kolom
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	v.add_child(grid)
	var mode: Array = [
		["huruf", "ABC\nBelajar Huruf", Gaya.BIRU, false],
		["suku", "BA BI BU\nSuku Kata", Gaya.HIJAU, false],
		["kata", "FOTO\nKata & Foto", Gaya.ORANYE, false],
		["tulis", "Aa\nTulis Huruf", Gaya.PINK, false],
		["kalimat", "KALIMAT\nSusun Kalimat", Gaya.UNGU, true],
		["memori", "PASANGAN\nKartu Memori", Color("00C2A8"), true],
	]
	for m in mode:
		var terkunci: bool = m[3] and not _app.simpan.premium()
		var b := Gaya.tombol(String(m[1]) + ("\nPremium" if terkunci else ""), m[2], 29)
		b.custom_minimum_size = Vector2(319, 148)
		var tujuan := String(m[0])
		var kunci_ini := terkunci
		b.pressed.connect(func() -> void:
			if kunci_ini:
				_app.suara.sfx("lembut")
				_app.suara.narasi("premium")
			else:
				_app.suara.sfx("pop")
				minta.emit(tujuan))
		grid.add_child(b)
	var album := Gaya.tombol("ALBUM STIKERMU", Gaya.EMAS, 30)
	album.custom_minimum_size = Vector2(652, 104)
	album.pressed.connect(func() -> void: _app.suara.sfx("pop"); minta.emit("album"))
	v.add_child(album)
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sp)
	# Gerbang orang tua (tekan & tahan 2 detik)
	var ortu_v := VBoxContainer.new()
	ortu_v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(ortu_v)
	var b_ortu := Gaya.tombol("Untuk Orang Tua", Color("90A4AE"), 22)
	b_ortu.custom_minimum_size = Vector2(280, 58)
	b_ortu.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ortu_v.add_child(b_ortu)
	var petunjuk := Gaya.label("tekan & tahan 2 detik", 18, Gaya.TEKS_LEMBUT)
	petunjuk.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ortu_v.add_child(petunjuk)
	_tahan = Timer.new()
	_tahan.wait_time = 2.0
	_tahan.one_shot = true
	add_child(_tahan)
	_tahan.timeout.connect(func() -> void: Komponen.ortu(self, _app))
	b_ortu.button_down.connect(func() -> void: _tahan.start())
	b_ortu.button_up.connect(func() -> void: _tahan.stop())

func _pilih_profil() -> void:
	_app.suara.narasi("pilih_profil")
	var redup := ColorRect.new()
	redup.color = Color(0.25, 0.2, 0.35, 0.45)
	redup.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(redup)
	var tengah := CenterContainer.new()
	tengah.set_anchors_preset(Control.PRESET_FULL_RECT)
	redup.add_child(tengah)
	var kartu := PanelContainer.new()
	kartu.add_theme_stylebox_override("panel", Gaya.panel(36))
	tengah.add_child(kartu)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	kartu.add_child(v)
	var j := Gaya.judul("Siapa yang main?", 38)
	j.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(j)
	for nama in _app.simpan.daftar_profil():
		var n := String(nama)
		var b := Gaya.tombol(n + (" (aktif)" if n == _app.simpan.profil_aktif() else ""), Gaya.BIRU if n == _app.simpan.profil_aktif() else Color("B8C4CC"), 28)
		b.custom_minimum_size = Vector2(360, 72)
		b.pressed.connect(func() -> void:
			_app.simpan.ganti_profil(n)
			_app.suara.sfx("pop")
			redup.queue_free()
			_chip_profil.text = "Yang main: " + n
			_label_bintang.text = "%d bintang" % _app.simpan.total_bintang())
		v.add_child(b)
	var batal := Gaya.tombol("Batal", Color("90A4AE"), 24)
	batal.pressed.connect(func() -> void: redup.queue_free())
	v.add_child(batal)
