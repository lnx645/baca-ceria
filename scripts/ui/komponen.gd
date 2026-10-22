class_name Komponen
## Pembangun bersama: bilah atas, chip mode, panel hasil, panel orang tua.

static func bilah(induk: Control, judul: String, on_kembali: Callable) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 16)
	var kembali := Gaya.tombol("<", Gaya.PINK, 36)
	kembali.custom_minimum_size = Vector2(76, 64)
	kembali.pressed.connect(on_kembali)
	h.add_child(kembali)
	var t := Gaya.judul(judul, 44)
	t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h.add_child(t)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(sp)
	induk.add_child(h)
	return h

static func chip(teks: String, aktif: bool, warna: Color) -> Button:
	var b := Gaya.tombol(teks, warna if aktif else Color("B8C4CC"), 26)
	b.custom_minimum_size = Vector2(190, 62)
	if not aktif:
		b.modulate = Color(1, 1, 1, 0.75)
	return b

## Panel hasil sesi: bintang pop satu-satu + pujian + tombol.
static func hasil(induk: Control, app: Node, bintang: int, on_lagi: Callable, on_menu: Callable) -> void:
	app.suara.sfx("hore")
	app.suara.narasi("berhasil")
	var redup := ColorRect.new()
	redup.color = Color(0.25, 0.2, 0.35, 0.45)
	redup.set_anchors_preset(Control.PRESET_FULL_RECT)
	induk.add_child(redup)
	var tengah := CenterContainer.new()
	tengah.set_anchors_preset(Control.PRESET_FULL_RECT)
	redup.add_child(tengah)
	var kartu := PanelContainer.new()
	kartu.add_theme_stylebox_override("panel", Gaya.panel(40))
	tengah.add_child(kartu)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	kartu.add_child(v)
	var judul := Gaya.judul("KERJA BAGUS!", 54)
	judul.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(judul)
	var baris := HBoxContainer.new()
	baris.alignment = BoxContainer.ALIGNMENT_CENTER
	baris.add_theme_constant_override("separation", 14)
	v.add_child(baris)
	var bintang_nodes: Array[Bintang] = []
	for i in 3:
		var b := Bintang.new(i < bintang, 96)
		b.scale = Vector2.ZERO
		baris.add_child(b)
		bintang_nodes.append(b)
	var puji := Gaya.label("Kamu hebat! Terus semangat belajar ya!", 26, Gaya.TEKS_LEMBUT)
	puji.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(puji)
	var tombol_baris := HBoxContainer.new()
	tombol_baris.alignment = BoxContainer.ALIGNMENT_CENTER
	tombol_baris.add_theme_constant_override("separation", 16)
	v.add_child(tombol_baris)
	var lagi := Gaya.tombol("Main Lagi", Gaya.HIJAU, 30)
	lagi.custom_minimum_size = Vector2(220, 76)
	lagi.pressed.connect(func() -> void: redup.queue_free(); on_lagi.call())
	tombol_baris.add_child(lagi)
	var menu := Gaya.tombol("Menu", Gaya.BIRU, 30)
	menu.custom_minimum_size = Vector2(180, 76)
	menu.pressed.connect(func() -> void: redup.queue_free(); on_menu.call())
	tombol_baris.add_child(menu)
	_pop_bintang(bintang_nodes, app)

static func _pop_bintang(nodes: Array[Bintang], app: Node) -> void:
	for i in nodes.size():
		var b := nodes[i]
		if not is_instance_valid(b):
			continue
		b.pivot_offset = b.size / 2.0 if b.size != Vector2.ZERO else Vector2(48, 48)
		var tw := b.create_tween()
		tw.tween_interval(0.25 * float(i + 1))
		tw.tween_callback(func() -> void: if b.emas: app.suara.sfx("pop"))
		tw.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(b, "scale", Vector2.ONE, 0.35)

## Panel khusus orang tua: profil anak, rapor per kemampuan, saran, premium, reset.
static func ortu(induk: Control, app: Node) -> void:
	app.suara.narasi("untuk_ortu")
	var redup := ColorRect.new()
	redup.color = Color(0.25, 0.2, 0.35, 0.45)
	redup.set_anchors_preset(Control.PRESET_FULL_RECT)
	induk.add_child(redup)
	var tengah := CenterContainer.new()
	tengah.set_anchors_preset(Control.PRESET_FULL_RECT)
	redup.add_child(tengah)
	var kartu := PanelContainer.new()
	kartu.add_theme_stylebox_override("panel", Gaya.panel(36))
	tengah.add_child(kartu)
	var gulir := ScrollContainer.new()
	gulir.custom_minimum_size = Vector2(604, 1020)
	gulir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	kartu.add_child(gulir)
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_theme_constant_override("separation", 12)
	gulir.add_child(v)
	v.add_child(Gaya.judul("Untuk Ayah & Bunda", 40))
	# --- Profil anak ---
	v.add_child(Gaya.label("Profil anak (yang sedang aktif dicentang):", 24, Gaya.TEKS_LEMBUT))
	for nama in app.simpan.daftar_profil():
		var n := String(nama)
		var aktif: bool = n == app.simpan.profil_aktif()
		var b := Gaya.tombol((n + " (aktif)") if aktif else n, Gaya.BIRU if aktif else Color("B8C4CC"), 24)
		b.custom_minimum_size = Vector2(420, 58)
		b.pressed.connect(func() -> void:
			app.simpan.ganti_profil(n)
			redup.queue_free()
			ortu(induk, app))
		v.add_child(b)
	var baris_tambah := HBoxContainer.new()
	baris_tambah.add_theme_constant_override("separation", 10)
	v.add_child(baris_tambah)
	var isian := LineEdit.new()
	isian.placeholder_text = "Nama anak baru"
	isian.custom_minimum_size = Vector2(300, 58)
	isian.max_length = 16
	isian.add_theme_font_override("font", Gaya.font_biasa())
	isian.add_theme_font_size_override("font_size", 24)
	baris_tambah.add_child(isian)
	var tambah := Gaya.tombol("Tambah", Gaya.HIJAU, 24)
	tambah.custom_minimum_size = Vector2(150, 58)
	tambah.pressed.connect(func() -> void:
		if app.simpan.tambah_profil(isian.text):
			redup.queue_free()
			ortu(induk, app))
	baris_tambah.add_child(tambah)
	if app.simpan.daftar_profil().size() > 1:
		var hapus := Gaya.tombol("Hapus Profil Aktif", Color("B8C4CC"), 22)
		hapus.pressed.connect(func() -> void:
			if hapus.text == "Hapus Profil Aktif":
				hapus.text = "Yakin? Ketuk Sekali Lagi"
			else:
				app.simpan.hapus_profil(app.simpan.profil_aktif())
				redup.queue_free()
				ortu(induk, app))
		v.add_child(hapus)
	# --- Rapor per kemampuan ---
	v.add_child(Gaya.label("Rapor — profil: " + app.simpan.profil_aktif(), 26, Gaya.TEKS, true))
	for mode in Simpan.MODE_LABEL.keys():
		var baris_mode := Gaya.label("%s — %d sesi, %d bintang (%s)" % [String(Simpan.MODE_LABEL[mode]), app.simpan.sesi(mode), app.simpan.bintang(mode), app.simpan.status_kemampuan(mode)], 24)
		baris_mode.custom_minimum_size = Vector2(548, 0)
		baris_mode.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(baris_mode)
	v.add_child(Gaya.label("Total: %d bintang dari %d sesi. Sesi hari ini: %d." % [app.simpan.total_bintang(), app.simpan.total_sesi(), app.simpan.sesi_hari_ini()], 24))
	var saran := Gaya.label(app.simpan.saran_hari_ini(), 24, Gaya.UNGU, true)
	saran.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(saran)
	# --- Premium ---
	if app.simpan.premium():
		v.add_child(Gaya.label("Premium: AKTIF — semua mode terbuka. Terima kasih!", 24, Gaya.HIJAU, true))
		var matikan := Gaya.tombol("Nonaktifkan Premium", Color("B8C4CC"), 22)
		matikan.pressed.connect(func() -> void:
			app.simpan.set_premium(false)
			redup.queue_free()
			ortu(induk, app))
		v.add_child(matikan)
	else:
		v.add_child(Gaya.label("Premium membuka mode Kalimat & Kartu Memori.", 24, Gaya.TEKS_LEMBUT))
		var aktifkan := Gaya.tombol("Aktifkan Premium (Simulasi)", Gaya.EMAS, 24)
		aktifkan.pressed.connect(func() -> void:
			app.simpan.set_premium(true)
			redup.queue_free()
			ortu(induk, app))
		v.add_child(aktifkan)
	var kredit := Gaya.label("Foto benda asli dari Wikimedia Commons (lisensi CC — rincian per foto ada di LISENSI.md repo). Narasi: suara sintetis Piper TTS.", 17, Gaya.TEKS_LEMBUT)
	kredit.custom_minimum_size = Vector2(548, 0)
	kredit.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(kredit)
	var baris := HBoxContainer.new()
	baris.add_theme_constant_override("separation", 14)
	v.add_child(baris)
	var reset := Gaya.tombol("Atur Ulang Semua", Color("B8C4CC"), 23)
	reset.pressed.connect(func() -> void:
		if reset.text == "Atur Ulang Semua":
			reset.text = "Yakin? Ketuk Sekali Lagi"
		else:
			app.simpan.reset_semua()
			redup.queue_free()
			ortu(induk, app))
	baris.add_child(reset)
	var tutup := Gaya.tombol("Tutup", Gaya.BIRU, 25)
	tutup.custom_minimum_size = Vector2(170, 64)
	tutup.pressed.connect(func() -> void: redup.queue_free())
	baris.add_child(tutup)
