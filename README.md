# Baca Ceria

Game edukasi membaca permulaan untuk anak Indonesia usia 4–7 tahun — judul pertama seri **Ceria** (Poggy). Dibangun dengan Godot 4.3, 100% offline, tanpa iklan & tanpa pelacak (ramah aturan Google Play Families).

## Isi permainan
- **Belajar Huruf** — ketuk huruf A–Z, dengar namanya (audio-first untuk anak pramembaca); mode **Kuis**: tebak huruf dari bunyinya (5 soal).
- **Suku Kata** — ketuk suku kata (ba bi bu be bo … 11 konsonan × 5 vokal); mode **Susun Kata**: rangkai suku kata jadi kata bergambar (bola, buku, mata, topi, roti, susu, roda, meja).
- **Kata Bergambar** — dengarkan kata, ketuk gambar yang benar (5 soal).
- Bintang penghargaan tiap sesi (tanpa gagal keras — jawaban salah hanya dinonaktifkan), progres tersimpan lokal.
- **Bagian Orang Tua** (tekan & tahan 2 detik): rapor sesi & bintang per mode + atur ulang progres.

Jalur belajar mengikuti Kurikulum Merdeka Fase A: huruf → suku kata → kata. Maskot: **Kiko** si burung hantu.

## Arsitektur (clean architecture)
- `scripts/main.gd` — perakit & penukar layar.
- `scripts/domain/data.gd` — konten (huruf, suku kata, kata).
- `scripts/services/` — `suara.gd` (narasi & sfx), `simpan.gd` (progres lokal).
- `scripts/ui/` — `gaya.gd` (sistem desain "Ceria"), `latar.gd`, `maskot.gd`, `gambar_kata.gd`, `bintang.gd`, `komponen.gd`, `layar/` (menu, huruf, suku, kata).

## Aset & lisensi
Lihat `LISENSI.md`. Font Baloo 2 (OFL), narasi disintesis lokal dengan Piper TTS (model id_ID), gambar & UI digambar prosedural dari kode, SFX disintesis dari kode.
