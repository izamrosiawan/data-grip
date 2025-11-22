-- Tabel Master
CREATE TABLE Pasien (
    id_pasien INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15),
    tanggal_lahir DATE,
    golongan_darah VARCHAR(2)
);

CREATE TABLE Poliklinik (
    id_poliklinik INT PRIMARY KEY,
    nama VARCHAR(100),
    deskripsi TEXT,
    jumlah_dokter INT
);

CREATE TABLE Dokter (
    id_dokter INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15),
    spesialis VARCHAR(50),
    id_poliklinik INT,
    FOREIGN KEY (id_poliklinik) REFERENCES Poliklinik(id_poliklinik)
);

CREATE TABLE Perawat (
    id_perawat INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15),
    id_poliklinik INT,
    FOREIGN KEY (id_poliklinik) REFERENCES Poliklinik(id_poliklinik)
);

CREATE TABLE Apoteker (
    id_apoteker INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15)
);

CREATE TABLE Customer_Service (
    id_cs INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15)
);

CREATE TABLE Kasir (
    id_kasir INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15)
);

CREATE TABLE Pemasok (
    id_pemasok INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    no_hp VARCHAR(15),
    jenis_pemasok VARCHAR(20)
);

CREATE TABLE Obat (
    id_obat INT PRIMARY KEY,
    nama_obat VARCHAR(100),
    jenis_obat VARCHAR(50),
    ukuran VARCHAR(20),
    jumlah INT,
    harga DECIMAL(10, 2)
);

-- Tabel Relasi / Transaksional
CREATE TABLE Registrasi (
    id_registrasi INT PRIMARY KEY,
    id_pasien INT,
    id_cs INT,
    id_poliklinik INT,
    id_dokter INT,
    tanggal_kunjungan DATE,
    FOREIGN KEY (id_pasien) REFERENCES Pasien(id_pasien),
    FOREIGN KEY (id_cs) REFERENCES Customer_Service(id_cs),
    FOREIGN KEY (id_poliklinik) REFERENCES Poliklinik(id_poliklinik),
    FOREIGN KEY (id_dokter) REFERENCES Dokter(id_dokter)
);

CREATE TABLE Pemeriksaan (
    id_pemeriksaan INT PRIMARY KEY,
    id_registrasi INT,
    id_dokter INT,
    id_perawat INT,
    keluhan TEXT,
    berat_badan DECIMAL(5,2),
    tinggi_badan DECIMAL(5,2),
    suhu DECIMAL(4,2),
    hasil_pemeriksaan TEXT,
    tanggal_pemeriksaan DATE,
    FOREIGN KEY (id_registrasi) REFERENCES Registrasi(id_registrasi),
    FOREIGN KEY (id_dokter) REFERENCES Dokter(id_dokter),
    FOREIGN KEY (id_perawat) REFERENCES Perawat(id_perawat)
);

CREATE TABLE Resep (
    id_resep INT PRIMARY KEY,
    id_pemeriksaan INT,
    id_apoteker INT,
    tanggal_resep DATE,
    FOREIGN KEY (id_pemeriksaan) REFERENCES Pemeriksaan(id_pemeriksaan),
    FOREIGN KEY (id_apoteker) REFERENCES Apoteker(id_apoteker)
);

CREATE TABLE Detail_Resep (
    id_detail_resep INT PRIMARY KEY,
    id_resep INT,
    id_obat INT,
    dosis VARCHAR(50),
    jumlah INT,
    FOREIGN KEY (id_resep) REFERENCES Resep(id_resep),
    FOREIGN KEY (id_obat) REFERENCES Obat(id_obat)
);


CREATE TABLE Pembayaran (
    id_pembayaran INT PRIMARY KEY,
    id_registrasi INT,
    id_kasir INT,
    total_biaya DECIMAL(12, 2),
    metode_pembayaran VARCHAR(20),
    tipe_pembayaran VARCHAR(20),
    status_pembayaran VARCHAR(20),
    tanggal_pembayaran DATE,
    FOREIGN KEY (id_registrasi) REFERENCES Registrasi(id_registrasi),
    FOREIGN KEY (id_kasir) REFERENCES Kasir(id_kasir)
);

CREATE TABLE Pemasokan_Obat (
    id_pemasokan INT PRIMARY KEY,
    id_obat INT,
    id_pemasok INT,
    jumlah_pasok INT,
    tanggal_pasok DATE,
    FOREIGN KEY (id_obat) REFERENCES Obat(id_obat),
    FOREIGN KEY (id_pemasok) REFERENCES Pemasok(id_pemasok)
);