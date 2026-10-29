use toko_online;

-- QUERY 1: Dimas Prawiraharja (NPM: 06.2023.1.07730)

explain analyze
select p.id_pesanan, u.nama, u.kota, p.status, p.tanggal_pesan
from pesanan p
join users u on p.id_user = u.id_user
where p.status = 'selesai'
  and p.tanggal_pesan between '2025-01-01' and '2025-06-30'
order by p.tanggal_pesan desc;

-- QUERY 2: Wahyu Indratama (NPM: 06.2024.1.07758)

explain analyze
select u.id_user, u.nama, u.kota, u.tanggal_daftar, count(p.id_pesanan) as total_pesanan
from users u
join pesanan p on u.id_user = p.id_user
where u.kota = 'surabaya'
  and u.tanggal_daftar >= '2024-06-01'
group by u.id_user, u.nama, u.kota, u.tanggal_daftar
order by u.tanggal_daftar desc;

-- QUERY 3: Chesta Sayyidina Azzura

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