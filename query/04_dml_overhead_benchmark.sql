use toko_online;

-- BAGIAN 1: PENGUJIAN DML OVERHEAD TABEL PESANAN (DIMAS PRAWIRAHARJA)
-- Indeks Diuji: idx_pesanan_status_tgl (status, tanggal_pesan)

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

-- BAGIAN 2: PENGUJIAN DML OVERHEAD TABEL USERS (WAHYU INDRATAMA)
-- Indeks Diuji: idx_users_kota_tgl (kota, tanggal_daftar)

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

-- BAGIAN 3: PENGUJIAN DML OVERHEAD TABEL DETAIL_PESANAN (CHESTA SAYYIDINA AZZURA)
-- Indeks Diuji: idx_dp_produk_cover (id_produk, jumlah, harga_satuan)

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
