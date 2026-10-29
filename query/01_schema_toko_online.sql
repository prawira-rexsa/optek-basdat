create database if not exists `toko_online` character set utf8mb4 collate utf8mb4_unicode_ci;
use `toko_online`;

drop table if exists `detail_pesanan`;
drop table if exists `pesanan`;
drop table if exists `produk`;
drop table if exists `users`;
drop table if exists `kategori`;

create table `kategori` (
  `id_kategori` int unsigned not null auto_increment,
  `nama_kategori` varchar(100) not null,
  `deskripsi` text,
  primary key (`id_kategori`)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_unicode_ci;

create table `users` (
  `id_user` int unsigned not null auto_increment,
  `nama` varchar(150) not null,
  `email` varchar(150) not null,
  `password_hash` varchar(255) not null,
  `telepon` varchar(20) not null,
  `kota` varchar(100) not null,
  `tanggal_daftar` datetime not null,
  primary key (`id_user`),
  unique key `uk_users_email` (`email`)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_unicode_ci;

create table `produk` (
  `id_produk` int unsigned not null auto_increment,
  `id_kategori` int unsigned not null,
  `nama_produk` varchar(150) not null,
  `harga` decimal(12,2) not null,
  `stok` int not null,
  primary key (`id_produk`),
  key `fk_produk_kategori` (`id_kategori`),
  constraint `fk_produk_kategori` foreign key (`id_kategori`) references `kategori` (`id_kategori`) on delete cascade
) engine=innodb default charset=utf8mb4 collate=utf8mb4_unicode_ci;

create table `pesanan` (
  `id_pesanan` int unsigned not null auto_increment,
  `id_user` int unsigned not null,
  `status` enum('menunggu_pembayaran','diproses','dikirim','selesai','dibatalkan') not null,
  `tanggal_pesan` datetime not null,
  primary key (`id_pesanan`),
  key `fk_pesanan_users` (`id_user`),
  constraint `fk_pesanan_users` foreign key (`id_user`) references `users` (`id_user`) on delete cascade
) engine=innodb default charset=utf8mb4 collate=utf8mb4_unicode_ci;

create table `detail_pesanan` (
  `id_detail` int unsigned not null auto_increment,
  `id_pesanan` int unsigned not null,
  `id_produk` int unsigned not null,
  `jumlah` int not null,
  `harga_satuan` decimal(12,2) not null,
  primary key (`id_detail`),
  key `fk_detail_pesanan` (`id_pesanan`),
  key `fk_detail_produk` (`id_produk`),
  constraint `fk_detail_pesanan` foreign key (`id_pesanan`) references `pesanan` (`id_pesanan`) on delete cascade,
  constraint `fk_detail_produk` foreign key (`id_produk`) references `produk` (`id_produk`) on delete cascade
) engine=innodb default charset=utf8mb4 collate=utf8mb4_unicode_ci;
