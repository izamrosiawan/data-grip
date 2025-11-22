BEGIN;

SELECT jumlah
FROM obat
WHERE id_obat = 7
FOR UPDATE;

INSERT INTO pemeriksaan (
    id_registrasi,
    id_dokter,
    id_perawat,
    tanggal_pemeriksaan,
    keluhan,
    hasil_pemeriksaan,
    suhu,
    berat_badan,
    tinggi_badan
)
VALUES (
    20,
    3,
    5,
    NOW(),
    'Demam, batuk, lemas',
    'Flu berat',
    38.2,
    55.0,
    165.0
)
RETURNING id_pemeriksaan;

INSERT INTO resep (id_pemeriksaan, id_apoteker, tanggal_resep)
VALUES (14, 1, CURRENT_DATE);

UPDATE obat
SET jumlah = jumlah - 2
WHERE id_obat = 7;

SELECT * FROM pemeriksaan WHERE id_pemeriksaan = 202;

SELECT * FROM resep WHERE id_pemeriksaan = 22;

SELECT id_obat, jumlah FROM obat WHERE id_obat = 7;

COMMIT;
