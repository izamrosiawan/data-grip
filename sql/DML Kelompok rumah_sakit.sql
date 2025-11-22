-- Insert sample data into Pasien
INSERT INTO Pasien (id_pasien, nama, alamat, no_hp, tanggal_lahir, golongan_darah) VALUES
(1, 'Andi', 'Jl. Merdeka 1', '081234567890', '1990-01-01', 'A'),
(2, 'Budi', 'Jl. Merdeka 2', '081234567891', '1985-05-12', 'B'),
(3, 'Citra', 'Jl. Merdeka 3', '081234567892', '1992-07-23', 'O');

-- Insert sample data into Poliklinik
INSERT INTO Poliklinik (id_poliklinik, nama, deskripsi, jumlah_dokter) VALUES
(1, 'Poli Umum', 'Pelayanan umum', 3),
(2, 'Poli Jantung', 'Spesialis jantung', 2);

-- Insert sample data into Dokter
INSERT INTO Dokter (id_dokter, nama, alamat, no_hp, spesialis, id_poliklinik) VALUES
(1, 'Dr. Siti', 'Jl. Dokter 1', '081234567800', 'Umum', 1),
(2, 'Dr. Rudi', 'Jl. Dokter 2', '081234567801', 'Jantung', 2);

-- Insert sample data into Customer_Service
INSERT INTO Customer_Service (id_cs, nama, alamat, no_hp) VALUES
(1, 'Dewi', 'Jl. CS 1', '081234567810');

-- Insert sample data into Kasir
INSERT INTO Kasir (id_kasir, nama, alamat, no_hp) VALUES
(1, 'Rina', 'Jl. Kasir 1', '081234567820');

-- Insert sample data into Registrasi
INSERT INTO Registrasi (id_registrasi, id_pasien, id_cs, id_poliklinik, id_dokter, tanggal_kunjungan) VALUES
(1, 1, 1, 1, 1, '2023-01-10'),
(2, 2, 1, 2, 2, '2023-02-15');

-- Insert sample data into Pembayaran
INSERT INTO Pembayaran (id_pembayaran, id_registrasi, id_kasir, total_biaya, metode_pembayaran, tipe_pembayaran, status_pembayaran, tanggal_pembayaran) VALUES
(1, 1, 1, 600000, 'Tunai', 'Lunas', 'Selesai', '2023-01-10'),
(2, 2, 1, 400000, 'Kartu', 'Cicil', 'Belum Lunas', '2023-02-15');