-- ====================================================================
-- SISTEM INFORMASI TOKO ONLINE
-- File 4: Script Pengujian DML Overhead (INSERT, UPDATE, DELETE)
-- RDBMS: MySQL 8.4 LTS (InnoDB)
-- Penulis: Dimas Prawiraharja, Wahyu Indratama, Chesta Sayyidina Azzura
-- ====================================================================

use toko_online;

-- ====================================================================
-- BAGIAN 1: PENGUJIAN DML OVERHEAD TABEL PESANAN (DIMAS PRAWIRAHARJA)
-- Indeks Diuji: idx_pesanan_status_tgl (status, tanggal_pesan)
-- ====================================================================

-- 1. Pengujian Operasi INSERT (1.000 Baris)
start transaction;
select now(6) as waktu_mulai;

insert into pesanan (id_user, status, tanggal_pesan)
select id_user, status, tanggal_pesan from pesanan limit 1000;

select now(6) as waktu_selesai;
rollback;

-- 2. Pengujian Operasi UPDATE (1.000 Baris Kolom Terindeks)
start transaction;
select now(6) as waktu_mulai;

update pesanan 
set tanggal_pesan = tanggal_pesan + interval 1 day 
where id_pesanan <= 1000;

select now(6) as waktu_selesai;
rollback;

-- 3. Pengujian Operasi DELETE (1.000 Baris)
start transaction;
select now(6) as waktu_mulai;

delete from pesanan 
where id_pesanan <= 1000;

select now(6) as waktu_selesai;
rollback;

/*
TABEL HASIL OVERHEAD DML DIMAS (TABEL PESANAN):
+-----------+--------------+--------------------+---------------------+
| Operasi   | Jumlah Baris | Waktu Tanpa Indeks | Waktu Dengan Indeks |
+-----------+--------------+--------------------+---------------------+
| INSERT    | 1.000 baris  | 28.45 ms           | 35.30 ms (+24.08%)  |
| UPDATE    | 1.000 baris  | 24.10 ms           | 32.69 ms (+35.64%)  |
| DELETE    | 1.000 baris  | 18.20 ms           | 25.12 ms (+38.02%)  |
+-----------+--------------+--------------------+---------------------+
*/


-- ====================================================================
-- BAGIAN 2: PENGUJIAN DML OVERHEAD TABEL USERS (WAHYU INDRATAMA)
-- Indeks Diuji: idx_users_kota_tgl (kota, tanggal_daftar)
-- ====================================================================

-- 1. Pengujian Operasi INSERT (1.000 Baris)
start transaction;
select now(6) as waktu_mulai;

insert into users (nama, email, password_hash, telepon, kota, tanggal_daftar)
select concat('user_bench_', id_user), concat('bench_', id_user, '@test.com'), password_hash, telepon, kota, tanggal_daftar 
from users limit 1000;

select now(6) as waktu_selesai;
rollback;

-- 2. Pengujian Operasi UPDATE (1.000 Baris Kolom Terindeks)
start transaction;
select now(6) as waktu_mulai;

update users 
set tanggal_daftar = tanggal_daftar + interval 1 day 
where id_user <= 1000;

select now(6) as waktu_selesai;
rollback;

-- 3. Pengujian Operasi DELETE (1.000 Baris)
start transaction;
select now(6) as waktu_mulai;

delete from users 
where id_user <= 1000;

select now(6) as waktu_selesai;
rollback;

/*
TABEL HASIL OVERHEAD DML WAHYU (TABEL USERS):
+-----------+--------------+--------------------+---------------------+
| Operasi   | Jumlah Baris | Waktu Tanpa Indeks | Waktu Dengan Indeks |
+-----------+--------------+--------------------+---------------------+
| INSERT    | 1.000 baris  | 15.20 ms           | 18.65 ms (+22.70%)  |
| UPDATE    | 1.000 baris  | 12.40 ms           | 16.80 ms (+35.48%)  |
| DELETE    | 1.000 baris  | 10.10 ms           | 13.90 ms (+37.62%)  |
+-----------+--------------+--------------------+---------------------+
*/


-- ====================================================================
-- BAGIAN 3: PENGUJIAN DML OVERHEAD TABEL DETAIL_PESANAN (CHESTA SAYYIDINA AZZURA)
-- Indeks Diuji: idx_dp_produk_cover (id_produk, jumlah, harga_satuan)
-- ====================================================================

-- 1. Pengujian Operasi INSERT (1.000 Baris)
start transaction;
select now(6) as waktu_mulai;

insert into detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan)
select id_pesanan, id_produk, jumlah, harga_satuan 
from detail_pesanan limit 1000;

select now(6) as waktu_selesai;
rollback;

-- 2. Pengujian Operasi UPDATE (1.000 Baris Kolom Terindeks 'jumlah')
start transaction;
select now(6) as waktu_mulai;

update detail_pesanan 
set jumlah = jumlah + 1 
where id_detail <= 1000;

select now(6) as waktu_selesai;
rollback;

-- 3. Pengujian Operasi DELETE (1.000 Baris)
start transaction;
select now(6) as waktu_mulai;

delete from detail_pesanan 
where id_detail <= 1000;

select now(6) as waktu_selesai;
rollback;

/*
TABEL HASIL OVERHEAD DML CHESTA (TABEL DETAIL_PESANAN):
+-----------+--------------+--------------------+---------------------+
| Operasi   | Jumlah Baris | Waktu Tanpa Indeks | Waktu Dengan Indeks |
+-----------+--------------+--------------------+---------------------+
| INSERT    | 1.000 baris  | 2.29 ms            | 12.85 ms (+460%)    |
| UPDATE    | 1.000 baris  | 0.41 ms            | 3.74 ms (+824%)     |
| DELETE    | 1.000 baris  | 2.31 ms            | 9.04 ms (+292%)     |
+-----------+--------------+--------------------+---------------------+

Catatan Chesta:
Pada covering index 3 kolom (id_produk, jumlah, harga_satuan) di tabel 
detail_pesanan (80.000 baris), overhead persentase terlihat sangat masif 
karena pembaruan nilai kolom 'jumlah' memaksa pemindahan posisi leaf node 
pada struktur B-Tree indeks sekunder.


=======================================================================
KESIMPULAN UMUM DML OVERHEAD KELOMPOK:
=======================================================================
1. Trade-off Indexing: Pembuatan secondary index mempercepat query SELECT 
   secara drastis (64% - 69% lebih cepat), namun membawa beban overhead 
   tulis (write penalty) pada operasi INSERT, UPDATE, dan DELETE.
2. Overhead INSERT: Bertambah 22% - 460% karena RDBMS harus menyisipkan 
   entri baru ke dalam seluruh B-Tree index yang terpasang pada tabel.
3. Overhead UPDATE: Menjadi paling signifikan ketika kolom yang diubah 
   termasuk dalam kunci indeks (seperti kolom tanggal_pesan, tanggal_daftar, 
   atau jumlah), karena engine InnoDB harus menghapus entri lama dan 
   menyisipkan entri baru pada pohon indeks (re-balancing B-Tree).
4. Overhead DELETE: Bertambah 37% - 292% karena penghapusan baris data 
   mengharuskan penandaan/pembersihan nodus indeks terkait.
5. Rekomendasi: Pembuatan indeks sekunder (terutama covering index) harus 
   diprioritaskan pada tabel yang didominasi beban baca (Read-Heavy) dan 
   dihindari pada tabel dengan transaksi tulis berfrekuensi tinggi (Write-Heavy).
=======================================================================
*/
