use toko_online;

-- BAGIAN DIMAS PRAWIRAHARJA (NPM: 06.2023.1.07730)
-- Strategi: Composite B-Tree Index pada kolom (status, tanggal_pesan)

create index idx_pesanan_status_tgl on pesanan(status, tanggal_pesan);

-- 2. EKSEKUSI QUERY SETELAH OPTIMASI INDEKS

explain analyze
select p.id_pesanan, u.nama, u.kota, p.status, p.tanggal_pesan
from pesanan p
join users u on p.id_user = u.id_user
where p.status = 'selesai'
  and p.tanggal_pesan between '2025-01-01' and '2025-06-30'
order by p.tanggal_pesan desc;

-- 3. PENGUKURAN UKURAN FISIK INDEKS (STORAGE COST)

select 
    index_name as nama_indeks,
    round((stat_value * @@innodb_page_size) / 1024, 2) as ukuran_kb
from mysql.innodb_index_stats
where database_name = 'toko_online' 
  and table_name = 'pesanan' 
  and stat_description = 'Number of pages in the index';

-- BAGIAN WAHYU INDRATAMA (NPM: 06.2024.1.07758)
-- Strategi: Composite B-Tree Index pada kolom (kota, tanggal_daftar)

create index idx_users_kota_tgl on users(kota, tanggal_daftar);

-- 5. EKSEKUSI QUERY WAHYU SETELAH OPTIMASI INDEKS

explain analyze
select u.id_user, u.nama, u.kota, u.tanggal_daftar, count(p.id_pesanan) as total_pesanan
from users u
join pesanan p on u.id_user = p.id_user
where u.kota = 'surabaya'
  and u.tanggal_daftar >= '2024-06-01'
group by u.id_user, u.nama, u.kota, u.tanggal_daftar
order by u.tanggal_daftar desc;

-- 6. PENGUKURAN UKURAN FISIK INDEKS WAHYU

select 
    index_name as nama_indeks,
    round((stat_value * @@innodb_page_size) / 1024, 2) as ukuran_kb
from mysql.innodb_index_stats
where database_name = 'toko_online' 
  and table_name = 'users' 
  and stat_description = 'Number of pages in the index';

-- BAGIAN CHESTA SAYYIDINA AZZURA
-- Strategi: Covering Composite Index pada tabel detail_pesanan

create index idx_dp_produk_cover on detail_pesanan(id_produk, jumlah, harga_satuan);
analyze table detail_pesanan;

-- 8. EKSEKUSI QUERY CHESTA SETELAH OPTIMASI INDEKS

explain analyze
select k.id_kategori, k.nama_kategori,
       count(distinct pr.id_produk) as jumlah_produk,
       sum(dp.jumlah) as total_unit,
       sum(dp.jumlah * dp.harga_satuan) as pendapatan
from detail_pesanan dp
join produk pr on dp.id_produk = pr.id_produk
join kategori k on pr.id_kategori = k.id_kategori
group by k.id_kategori, k.nama_kategori
order by pendapatan desc;

-- 9. PENGUKURAN UKURAN FISIK INDEKS CHESTA

select 
    index_name as nama_indeks,
    round((stat_value * @@innodb_page_size) / 1024, 2) as ukuran_kb
from mysql.innodb_index_stats
where database_name = 'toko_online' 
  and table_name = 'detail_pesanan' 
  and stat_description = 'Number of pages in the index';

-- 10. FITUR INVISIBLE INDEX (PENGUJIAN REPRODUKSI TANPA DROP INDEX)

-- nonaktifkan indeks untuk mengulang baseline
alter table detail_pesanan alter index idx_dp_produk_cover invisible;

-- aktifkan kembali indeks untuk mengevaluasi optimasi
alter table detail_pesanan alter index idx_dp_produk_cover visible;