
-- ONE-SHOT FINAL SQL FOR PRESENTATION
-- File: rumah_sakit_transactions_final.sql
-- Purpose: create sequences for integer PKs, sync them with existing data,
-- and provide two data-safe transactions compatible with DataGrip.
-- Run this file in DataGrip: sections are independent. Follow comments.

-- ============================================================
-- 0. SAFE RESET IF THERE IS AN OPEN TRANSACTION
-- ============================================================
ROLLBACK;

-- ============================================================
-- 1. CREATE/ATTACH SEQUENCES FOR PRIMARY KEYS (IF NOT EXISTS)
--    and synchronize them to current MAX values
-- ============================================================

-- apoteker
CREATE SEQUENCE IF NOT EXISTS apoteker_id_apoteker_seq;
ALTER TABLE apoteker ALTER COLUMN id_apoteker SET DEFAULT nextval('apoteker_id_apoteker_seq');
SELECT setval('apoteker_id_apoteker_seq', COALESCE((SELECT MAX(id_apoteker) FROM apoteker), 0));

-- dokter
CREATE SEQUENCE IF NOT EXISTS dokter_id_dokter_seq;
ALTER TABLE dokter ALTER COLUMN id_dokter SET DEFAULT nextval('dokter_id_dokter_seq');
SELECT setval('dokter_id_dokter_seq', COALESCE((SELECT MAX(id_dokter) FROM dokter), 0));

-- perawat
CREATE SEQUENCE IF NOT EXISTS perawat_id_perawat_seq;
ALTER TABLE perawat ALTER COLUMN id_perawat SET DEFAULT nextval('perawat_id_perawat_seq');
SELECT setval('perawat_id_perawat_seq', COALESCE((SELECT MAX(id_perawat) FROM perawat), 0));

-- pasien
CREATE SEQUENCE IF NOT EXISTS pasien_id_pasien_seq;
ALTER TABLE pasien ALTER COLUMN id_pasien SET DEFAULT nextval('pasien_id_pasien_seq');
SELECT setval('pasien_id_pasien_seq', COALESCE((SELECT MAX(id_pasien) FROM pasien), 0));

-- poliklinik (if id exists)
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='poliklinik' AND column_name='id_poliklinik') THEN
        CREATE SEQUENCE IF NOT EXISTS poliklinik_id_poliklinik_seq;
        ALTER TABLE poliklinik ALTER COLUMN id_poliklinik SET DEFAULT nextval('poliklinik_id_poliklinik_seq');
        PERFORM setval('poliklinik_id_poliklinik_seq', COALESCE((SELECT MAX(id_poliklinik) FROM poliklinik), 0));
    END IF;
END $$;

-- obat
CREATE SEQUENCE IF NOT EXISTS obat_id_obat_seq;
ALTER TABLE obat ALTER COLUMN id_obat SET DEFAULT nextval('obat_id_obat_seq');
SELECT setval('obat_id_obat_seq', COALESCE((SELECT MAX(id_obat) FROM obat), 0));

-- registrasi
CREATE SEQUENCE IF NOT EXISTS registrasi_id_registrasi_seq;
ALTER TABLE registrasi ALTER COLUMN id_registrasi SET DEFAULT nextval('registrasi_id_registrasi_seq');
SELECT setval('registrasi_id_registrasi_seq', COALESCE((SELECT MAX(id_registrasi) FROM registrasi), 0));

-- kunjungan
CREATE SEQUENCE IF NOT EXISTS kunjungan_id_kunjungan_seq;
ALTER TABLE kunjungan ALTER COLUMN id_kunjungan SET DEFAULT nextval('kunjungan_id_kunjungan_seq');
SELECT setval('kunjungan_id_kunjungan_seq', COALESCE((SELECT MAX(id_kunjungan) FROM kunjungan), 0));

-- pemeriksaan
CREATE SEQUENCE IF NOT EXISTS pemeriksaan_id_pemeriksaan_seq;
ALTER TABLE pemeriksaan ALTER COLUMN id_pemeriksaan SET DEFAULT nextval('pemeriksaan_id_pemeriksaan_seq');
SELECT setval('pemeriksaan_id_pemeriksaan_seq', COALESCE((SELECT MAX(id_pemeriksaan) FROM pemeriksaan), 0));

-- resep
CREATE SEQUENCE IF NOT EXISTS resep_id_resep_seq;
ALTER TABLE resep ALTER COLUMN id_resep SET DEFAULT nextval('resep_id_resep_seq');
SELECT setval('resep_id_resep_seq', COALESCE((SELECT MAX(id_resep) FROM resep), 0));

-- pembayaran (if exists)
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='pembayaran') THEN
        CREATE SEQUENCE IF NOT EXISTS pembayaran_id_pembayaran_seq;
        ALTER TABLE pembayaran ALTER COLUMN id_pembayaran SET DEFAULT nextval('pembayaran_id_pembayaran_seq');
        PERFORM setval('pembayaran_id_pembayaran_seq', COALESCE((SELECT MAX(id_pembayaran) FROM pembayaran), 0));
    END IF;
END $$;

-- ============================================================
-- 2. TRANSAKSI A: Registrasi -> Kunjungan (presentasi)
--    DataGrip-friendly: run block; copy RETURNING id; then run next.
-- ============================================================

-- Example: create a registrasi record and a linked kunjungan record atomically.
-- Adjust values if you want to use real pasien/id_poliklinik values from your DB.

BEGIN;

-- Insert registrasi (customer-facing)
INSERT INTO registrasi (id_pasien, id_cs, id_poliklinik, id_dokter, tanggal_kunjungan)
VALUES (1, NULL, NULL, NULL, CURRENT_DATE)
RETURNING id_registrasi;

-- In DataGrip: copy returned id_registrasi (e.g. 42), then run the following INSERT (replace :id_registrasi with real number)
-- Example (replace 42):
-- INSERT INTO kunjungan (id_pasien, tanggal, status, biaya)
-- VALUES (1, CURRENT_DATE, 'baru', 0)
-- RETURNING id_kunjungan;

-- Note: schema may differ; if your kunjungan table links to registrasi, adapt accordingly. This block demonstrates atomic insertion.
COMMIT;


-- ============================================================
-- 3. TRANSAKSI B: Pemeriksaan -> Resep -> Update Stok Obat
--    (DataGrip-friendly; copy RETURNING id_pemeriksaan and then paste in resep insert)
-- ============================================================

-- Assumptions for demo: replace IDs with ones valid in your DB
--  * id_registrasi = 20
--  * id_dokter = 3
--  * id_perawat = 5
--  * id_obat = 7
--  * qty_prescribed = 2

BEGIN;

-- 3A. Lock specific obat row to demonstrate isolation (row-level lock)
SELECT jumlah FROM obat WHERE id_obat = 7 FOR UPDATE;

-- 3B. Insert pemeriksaan (returns id_pemeriksaan)
INSERT INTO pemeriksaan (
    id_registrasi, id_dokter, id_perawat,
    tanggal_pemeriksaan, keluhan, hasil_pemeriksaan,
    suhu, berat_badan, tinggi_badan
)
VALUES (
    20, 3, 5,
    CURRENT_DATE, 'Demam, batuk, lemas', 'Flu berat',
    38.2, 55.0, 165.0
)
RETURNING id_pemeriksaan;

-- Copy the returned id_pemeriksaan (e.g. 123) for the next step in DataGrip.

-- 3C. Insert resep (DataGrip: replace <ID_PEMERIKSAAN> with returned id)
-- NOTE: your resep table in schema does NOT include obat id or quantity;
-- therefore we insert the resep header and then manually update obat stock as demonstration.
INSERT INTO resep (id_pemeriksaan, id_apoteker, tanggal_resep)
VALUES (<ID_PEMERIKSAAN>, 1, CURRENT_DATE)
RETURNING id_resep;

-- 3D. Update obat stock manually (example: id_obat = 7, qty = 2)
-- In presentation, replace 7 and 2 with real obat id and quantity
UPDATE obat SET jumlah = jumlah - 2 WHERE id_obat = 7;

COMMIT;

-- ============================================================
-- 4. DEMO 2-SESSION LOCKING NOTES (for live demo)
-- ============================================================
-- Use two consoles/tabs in DataGrip:
-- Session A:
-- BEGIN;
-- SELECT jumlah FROM obat WHERE id_obat = 7 FOR UPDATE;
-- (keep transaction open)
-- Session B:
-- UPDATE obat SET jumlah = jumlah - 1 WHERE id_obat = 7;
-- -- Session B will be blocked until Session A commits or rolls back.
-- Session A:
-- COMMIT;
-- Session B will then proceed.

-- ============================================================
-- 5. CLEANUP/SAFETY NOTES
-- ============================================================
-- If any error occurs in a section, run: ROLLBACK;
-- If you prefer to rename column 'jumlah' to 'stok' to match app code, use:
-- ALTER TABLE obat RENAME COLUMN jumlah TO stok;
-- but do this only if you know the app queries expect 'stok'.

-- End of file
