class_name LayarMenu
extends Control
## Menu utama: judul pelangi, Kiko, tiga tombol mode besar, gerbang orang tua.

signal minta(nama: String)

var _app: Node
var _tahan: Timer

func siapkan(app: Node) -> void:
	_app = app
	_bangun()
	if not app.halo_dimainkan:
		app.halo_dimainkan = true
		app.suara.narasi("halo")

func _bangun() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 56)
	margin.add_theme_constant_override("margin_right", 56)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 26)
	add_child(margin)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 18)
	margin.add_child(v)
	# Baris judul + maskot
	var atas := HBoxContainer.new()
	atas.add_theme_constant_override("separation", 10)
	v.add_child(atas)
	var kiko := Maskot.new()
	kiko.custom_minimum_size = Vector2(230, 250)
	atas.add_child(kiko)
	var kolom_judul := VBoxContainer.new()
	kolom_judul.alignment = BoxContainer.ALIGNMENT_CENTER
	atas.add_child(kolom_judul)
	var judul := HBoxContainer.new()
	judul.add_theme_constant_override("separation", 2)
	kolom_judul.add_child(judul)
	var kata := "BACA CERIA"
	for i in kata.length():
		var huruf := kata[i]
		var l := Gaya.judul(" " if huruf == " " else huruf, 86)
		l.add_theme_color_override("font_color", Gaya.PERMEN[i % Gaya.PERMEN.size()])
		l.rotation = deg_to_rad(-3.0 if i % 2 == 0 else 3.0)
		judul.add_child(l)
	var sub := Gaya.label("Belajar membaca sambil bermain!", 32, Gaya.TEKS)
	kolom_judul.add_child(sub)
	var bintang_baris := HBoxContainer.new()
	bintang_baris.add_theme_constant_override("separation", 8)
	kolom_judul.add_child(bintang_baris)
	var bs := Bintang.new(true, 40)
	bintang_baris.add_child(bs)
	var total := Gaya.label("%d bintang terkumpul" % _app.simpan.total_bintang(), 26, Gaya.TEKS_LEMBUT)
	total.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	bintang_baris.add_child(total)
	# Tombol mode
	var tengah := HBoxContainer.new()
	tengah.alignment = BoxContainer.ALIGNMENT_CENTER
	tengah.add_theme_constant_override("separation", 22)
	v.add_child(tengah)
	var b_huruf := Gaya.tombol("ABC\nBelajar Huruf", Gaya.BIRU, 36)
	b_huruf.custom_minimum_size = Vector2(320, 170)
	b_huruf.pressed.connect(func() -> void: _app.suara.sfx("pop"); minta.emit("huruf"))
	tengah.add_child(b_huruf)
	var b_suku := Gaya.tombol("BA BI BU\nSuku Kata", Gaya.HIJAU, 36)
	b_suku.custom_minimum_size = Vector2(320, 170)
	b_suku.pressed.connect(func() -> void: _app.suara.sfx("pop"); minta.emit("suku"))
	tengah.add_child(b_suku)
	var b_kata := Gaya.tombol("GAMBAR\nKata Bergambar", Gaya.ORANYE, 36)
	b_kata.custom_minimum_size = Vector2(320, 170)
	b_kata.pressed.connect(func() -> void: _app.suara.sfx("pop"); minta.emit("kata"))
	tengah.add_child(b_kata)
	# Gerbang orang tua (tekan & tahan)
	var bawah := HBoxContainer.new()
	v.add_child(bawah)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bawah.add_child(sp)
	var ortu_v := VBoxContainer.new()
	bawah.add_child(ortu_v)
	var b_ortu := Gaya.tombol("Untuk Orang Tua", Color("90A4AE"), 22)
	b_ortu.custom_minimum_size = Vector2(230, 58)
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
