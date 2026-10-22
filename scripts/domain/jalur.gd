class_name JalurHuruf
## Jalur goresan huruf besar untuk mode Tulis (ruang koordinat 100 x 140).
## Tiap huruf = daftar goresan; tiap goresan = daftar titik (Vector2).
## Huruf bulat (c, g, o, q, s) memakai titik-titik busur yang sudah dihitung kasar.

const JALUR: Dictionary = {
	"a": [[Vector2(6, 140), Vector2(50, 0), Vector2(94, 140)], [Vector2(26, 96), Vector2(74, 96)]],
	"b": [[Vector2(12, 0), Vector2(12, 140)], [Vector2(12, 0), Vector2(56, 0), Vector2(74, 19), Vector2(56, 38), Vector2(12, 38)], [Vector2(12, 38), Vector2(64, 38), Vector2(84, 64), Vector2(64, 140), Vector2(12, 140)]],
	"c": [[Vector2(86, 32), Vector2(62, 6), Vector2(36, 6), Vector2(12, 30), Vector2(8, 70), Vector2(12, 110), Vector2(36, 134), Vector2(62, 134), Vector2(86, 110)]],
	"d": [[Vector2(12, 0), Vector2(12, 140)], [Vector2(12, 0), Vector2(54, 0), Vector2(84, 36), Vector2(84, 104), Vector2(54, 140), Vector2(12, 140)]],
	"e": [[Vector2(86, 0), Vector2(12, 0), Vector2(12, 140), Vector2(88, 140)], [Vector2(12, 70), Vector2(68, 70)]],
	"f": [[Vector2(86, 0), Vector2(12, 0), Vector2(12, 140)], [Vector2(12, 70), Vector2(66, 70)]],
	"g": [[Vector2(88, 32), Vector2(62, 6), Vector2(36, 6), Vector2(10, 32), Vector2(8, 70), Vector2(10, 108), Vector2(36, 134), Vector2(64, 134), Vector2(88, 112), Vector2(88, 80), Vector2(58, 80)]],
	"h": [[Vector2(12, 0), Vector2(12, 140)], [Vector2(88, 0), Vector2(88, 140)], [Vector2(12, 70), Vector2(88, 70)]],
	"i": [[Vector2(50, 0), Vector2(50, 140)], [Vector2(24, 0), Vector2(76, 0)], [Vector2(24, 140), Vector2(76, 140)]],
	"j": [[Vector2(88, 0), Vector2(88, 104), Vector2(70, 132), Vector2(42, 138), Vector2(16, 120)]],
	"k": [[Vector2(12, 0), Vector2(12, 140)], [Vector2(86, 0), Vector2(16, 66)], [Vector2(34, 52), Vector2(88, 140)]],
	"l": [[Vector2(12, 0), Vector2(12, 140), Vector2(86, 140)]],
	"m": [[Vector2(8, 140), Vector2(8, 0), Vector2(50, 78), Vector2(92, 0), Vector2(92, 140)]],
	"n": [[Vector2(10, 140), Vector2(10, 0), Vector2(90, 140), Vector2(90, 0)]],
	"o": [[Vector2(50, 0), Vector2(76, 10), Vector2(92, 36), Vector2(92, 104), Vector2(76, 130), Vector2(50, 140), Vector2(24, 130), Vector2(8, 104), Vector2(8, 36), Vector2(24, 10), Vector2(50, 0)]],
	"p": [[Vector2(12, 140), Vector2(12, 0), Vector2(62, 0), Vector2(84, 22), Vector2(62, 46), Vector2(12, 46)]],
	"q": [[Vector2(50, 0), Vector2(76, 10), Vector2(92, 36), Vector2(92, 104), Vector2(76, 130), Vector2(50, 140), Vector2(24, 130), Vector2(8, 104), Vector2(8, 36), Vector2(24, 10), Vector2(50, 0)], [Vector2(60, 100), Vector2(94, 140)]],
	"r": [[Vector2(12, 140), Vector2(12, 0), Vector2(62, 0), Vector2(84, 22), Vector2(62, 46), Vector2(12, 46)], [Vector2(54, 46), Vector2(90, 140)]],
	"s": [[Vector2(84, 26), Vector2(58, 6), Vector2(30, 8), Vector2(14, 28), Vector2(26, 54), Vector2(72, 84), Vector2(86, 108), Vector2(70, 134), Vector2(38, 138), Vector2(12, 116)]],
	"t": [[Vector2(8, 0), Vector2(92, 0)], [Vector2(50, 0), Vector2(50, 140)]],
	"u": [[Vector2(10, 0), Vector2(10, 96), Vector2(28, 132), Vector2(50, 140), Vector2(72, 132), Vector2(90, 96), Vector2(90, 0)]],
	"v": [[Vector2(8, 0), Vector2(50, 140), Vector2(92, 0)]],
	"w": [[Vector2(6, 0), Vector2(26, 140), Vector2(50, 42), Vector2(74, 140), Vector2(94, 0)]],
	"x": [[Vector2(10, 0), Vector2(90, 140)], [Vector2(90, 0), Vector2(10, 140)]],
	"y": [[Vector2(8, 0), Vector2(50, 62), Vector2(92, 0)], [Vector2(50, 62), Vector2(50, 140)]],
	"z": [[Vector2(10, 0), Vector2(90, 0), Vector2(10, 140), Vector2(90, 140)]],
}
