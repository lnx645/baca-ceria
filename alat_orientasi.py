#!/usr/bin/env python3
"""Paksa android:screenOrientation=portrait (1) pada SEMUA elemen activity
di AndroidManifest.xml biner (AXML) sebuah APK.
Perlu karena template ekspor siap-pakai Godot mengunci landscape di manifest.
Pakai: alat_orientasi.py <apk-masuk> <apk-keluar>"""
import struct, sys, zipfile, shutil

def baca_pool(data, off):
    typ, hsz, size = struct.unpack_from('<HHI', data, off)
    assert typ == 0x0001, 'bukan string pool'
    count, _styles, flags, start = struct.unpack_from('<IIII', data, off + 8)
    utf8 = bool(flags & 0x100)
    offs = struct.unpack_from('<%dI' % count, data, off + hsz)
    strs = []
    for o in offs:
        p = off + start + o
        if utf8:
            n = data[p]; p += 1
            if n & 0x80: n = ((n & 0x7F) << 8) | data[p]; p += 1
            ln = data[p]; p += 1
            if ln & 0x80: ln = ((ln & 0x7F) << 8) | data[p]; p += 1
            strs.append(data[p:p + ln].decode('utf-8', 'replace'))
        else:
            n = struct.unpack_from('<H', data, p)[0]; p += 2
            if n & 0x8000:
                n = ((n & 0x7FFF) << 16) | struct.unpack_from('<H', data, p)[0]; p += 2
            strs.append(data[p:p + 2 * n].decode('utf-16-le', 'replace'))
    return strs, off + size

def patch_manifest(data):
    data = bytearray(data)
    strs, nxt = baca_pool(data, 8)
    cari = {nama: strs.index(nama) for nama in ('activity', 'activity-alias', 'screenOrientation') if nama in strs}
    assert 'screenOrientation' in cari, 'atribut screenOrientation tak ada'
    diubah = 0
    off = nxt
    while off < len(data):
        typ, hsz, size = struct.unpack_from('<HHI', data, off)
        if size == 0: break
        if typ == 0x0102:  # start element
            name_idx = struct.unpack_from('<I', data, off + 20)[0]
            if name_idx in (cari.get('activity'), cari.get('activity-alias')):
                astart, asize, acount = struct.unpack_from('<HHH', data, off + 24)
                for i in range(acount):
                    aoff = off + 16 + astart + i * asize
                    aname = struct.unpack_from('<I', data, aoff + 4)[0]
                    if aname == cari['screenOrientation']:
                        struct.pack_into('<I', data, aoff + 16, 1)  # 1 = portrait
                        diubah += 1
        off += size
    assert diubah >= 1, 'tidak ada screenOrientation yang diubah'
    print(f'screenOrientation -> portrait pada {diubah} activity')
    return bytes(data)

masuk, keluar = sys.argv[1], sys.argv[2]
zin = zipfile.ZipFile(masuk)
baru = patch_manifest(zin.read('AndroidManifest.xml'))
zout = zipfile.ZipFile(keluar, 'w')
for info in zin.infolist():
    isi = baru if info.filename == 'AndroidManifest.xml' else zin.read(info.filename)
    zout.writestr(info, isi)
zout.close(); zin.close()
print('APK tertulis:', keluar)
