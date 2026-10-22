# Baca Ceria

**v1.2.1 — Perbaikan:** orientasi dikunci PORTRAIT di manifest (template ekspor Godot mengunci landscape — diperbaiki alat_orientasi.py saat pengemasan) + optimasi anti force-close di HP kentang (tekstur foto dikompresi VRAM + diperkecil 512px, latar digambar ulang 8x/detik; APK 63 MB → 53 MB).

**v1.2.0 — Portrait & Serba Baru:** tampilan tegak (portrait) di semua layar; mode **Tulis Huruf** (telusuri jalur A–Z dengan jari), **Kalimat Sederhana** (susun + baca kalimat), **Kartu Memori** (pasangkan foto ↔ kata), dan **Album Stiker** (kumpulkan 22 foto kata). Kata kini 22 dengan tema Hewan/Buah/Benda dan foto asli baru (singa, monyet, sapi, ayam, bangau, nyamuk, jeruk, mangga, anggur, nanas; susu diganti kotak susu, meja & pisang diganti foto lebih bersih). Suku kata bertambah digraf **ng & ny**. Panel orang tua: banyak profil anak, rapor per kemampuan + saran harian, musik latar lembut, dan gerbang Premium (Kalimat & Memori; pembayaran asli menyusul di Play Store — tombol aktivasi saat ini simulasi).

Game edukasi membaca permulaan untuk anak Indonesia usia 4–7 tahun — judul pertama seri **Ceria** (Poggy). Dibangun dengan Godot 4.3, 100% offline, tanpa iklan & tanpa pelacak (ramah aturan Google Play Families).

## Isi permainan
- **Belajar Huruf** — ketuk huruf A–Z, dengar namanya (audio-first untuk anak pramembaca); mode **Kuis**: tebak huruf dari bunyinya (5 soal).
- **Suku Kata** — ketuk suku kata (ba bi bu be bo … 11 konsonan × 5 vokal); mode **Susun Kata**: rangkai suku kata jadi kata berfoto asli (12 kata: bola, buku, mata, topi, roti, susu, roda, meja, apel, pisang, kucing, ikan).
- **Kata Bergambar** — dengarkan kata, ketuk gambar yang benar (5 soal).
- Bintang penghargaan tiap sesi (tanpa gagal keras — jawaban salah hanya dinonaktifkan), progres tersimpan lokal.
- **Bagian Orang Tua** (tekan & tahan 2 detik): rapor sesi & bintang per mode + atur ulang progres.

Jalur belajar mengikuti Kurikulum Merdeka Fase A: huruf → suku kata → kata. Maskot: **Kiko** si burung hantu.

## Arsitektur (clean architecture)
- `scripts/main.gd` — perakit & penukar layar.
- `scripts/domain/data.gd` — konten (huruf, suku kata, kata).
- `scripts/services/` — `suara.gd` (narasi & sfx), `simpan.gd` (progres lokal).
- `scripts/ui/` — `gaya.gd` (sistem desain "Ceria"), `latar.gd`, `maskot.gd`, `foto_kata.gd` (foto asli Wikimedia Commons, CC), `bintang.gd`, `komponen.gd`, `layar/` (menu, huruf, suku, kata).

## Aset & lisensi
Lihat `LISENSI.md`. Font Baloo 2 (OFL), narasi disintesis lokal dengan Piper TTS (model id_ID), gambar & UI digambar prosedural dari kode, SFX disintesis dari kode.
