import time
import random
from datetime import datetime, timedelta
import pymysql
from faker import Faker

fake = Faker('id_ID')
random.seed(42)

DB_CONFIG = {
    'host': '127.0.0.1',
    'port': 3306,
    'user': 'root',
    'password': '',
    'database': 'toko_online',
    'charset': 'utf8mb4',
    'ausstocommit': False
}

def generate_data():
    start_total = time.time()
    conn = pymysql.connect(**DB_CONFIG)
    cursor = conn.cursor()

    print("============================================================")
    print(">>> MEMULAI GENERASI DATA DUMMY TOKO ONLINE")
    print("============================================================")

    try:
        print("\n[1/5] Menyiapkan data tabel `kategori` (10 baris)...")
        kategori_list = [
            'Elektronik', 'Komputer & Laptop', 'Handphone & Tablet',
            'Pakaian Pria', 'Pakaian Wanita', 'Sepatu & Sandal',
            'Buku & Alat Tulis', 'Makanan & Minuman', 'Otomotif & Aksesoris',
            'Olahraga & Outdoor'
        ]
        sql_kategori = "INSERT INTO kategori (nama_kategori) VALUES (%s)"
        cursor.executemany(sql_kategori, [(k,) for k in kategori_list])
        conn.commit()
        print(f"  [OK] {len(kategori_list)} kategori berhasil dimasukkan.")

        print("\n[2/5] Menyiapkan data tabel `users` (5.000 baris)...")
        kota_list = [
            'Jakarta Pusat', 'Jakarta Selatan', 'Jakarta Barat', 'Surabaya',
            'Bandung', 'Semarang', 'Medan', 'Makassar', 'Yogyakarta',
            'Malang', 'Denpasar', 'Palembang', 'Tangerang', 'Bekasi', 'Depok'
        ]
        
        users_data = []
        base_date = datetime(2024, 1, 1)
        for i in range(1, 5001):
            nama = fake.name()
            email = f"user_{i}_{fake.user_name()}@{fake.free_email_domain()}"
            kota = random.choice(kota_list)
            days_offset = random.randint(0, 700)
            seconds_offset = random.randint(0, 86400)
            tgl_daftar = base_date + timedelta(days=days_offset, seconds=seconds_offset)
            users_data.append((nama, email, kota, tgl_daftar))

        sql_users = "INSERT INTO users (nama, email, kota, tanggal_daftar) VALUES (%s, %s, %s, %s)"
        cursor.executemany(sql_users, users_data)
        conn.commit()
        print(f"  [OK] {len(users_data):,} users berhasil dimasukkan.")

        print("\n[3/5] Menyiapkan data tabel `produk` (1.000 baris)...")
        sample_produk_names = [
            ('Elektronik', ['Smart TV 43 Inch', 'Speaker Bluetooth', 'Kamera Mirrorless', 'Earphone TWS', 'Powerbank 20000mAh']),
            ('Komputer & Laptop', ['Laptop Gaming Core i7', 'Mechanical Keyboard', 'Mouse Wireless', 'Monitor IPS 24 Inch', 'SSD NVMe 1TB']),
            ('Handphone & Tablet', ['Smartphone 5G 128GB', 'Tablet Android 10 Inch', 'Stylus Pen', 'Casing Silikon', 'Fast Charger 65W']),
            ('Pakaian Pria', ['Kemeja Flanel', 'Celana Chino Panjang', 'Kaos Polos Cotton', 'Jaket Bomber', 'Hoodie Oversize']),
            ('Pakaian Wanita', ['Blouse Katun', 'Rok Plisket', 'Cardigan Rajut', 'Dress Kasual', 'Celana Kulot']),
            ('Sepatu & Sandal', ['Sepatu Sneakers', 'Sepatu Lari Running', 'Sandal Gunung', 'Sepatu Pantofel Kulit', 'Slip-on Shoes']),
            ('Buku & Alat Tulis', ['Buku Belajar SQL', 'Notebook A5 Hardcover', 'Pulpen Gel Set', 'Buku Manajemen Bisnis', 'Binder Kuliah']),
            ('Makanan & Minuman', ['Biji Kopi Arabika 250g', 'Teh Hijau Organik', 'Keripik Tempe Renyah', 'Madu Murni 500ml', 'Cokelat Hitam 80%']),
            ('Otomotif & Aksesoris', ['Helm Full Face SNI', 'Oli Mesin Matic 1L', 'Jas Hujan Ponco', 'Kunci Ring Set', 'Lampu LED Motor']),
            ('Olahraga & Outdoor', ['Matras Yoga 6mm', 'Tenda Camping 4 Orang', 'Dumbbell 5kg Set', 'Tas Ransel Outdoor 40L', 'Botol Minum 1L'])
        ]

        produk_data = []
        for i in range(1, 1001):
            id_kat = random.randint(1, 10)
            base_name = random.choice(sample_produk_names[id_kat - 1][1])
            nama_produk = f"{base_name} Tipe-{i}"
            harga = round(random.uniform(25000.0, 4500000.0), -3) # Kelipatan ribuan
            stok = random.randint(10, 250)
            produk_data.append((id_kat, nama_produk, harga, stok))

        sql_produk = "INSERT INTO produk (id_kategori, nama_produk, harga, stok) VALUES (%s, %s, %s, %s)"
        cursor.executemany(sql_produk, produk_data)
        conn.commit()
        print(f"  [OK] {len(produk_data):,} produk berhasil dimasukkan.")

        print("\n[4/5] Menyiapkan data tabel `pesanan` (20.000 baris)...")
        status_choices = ['selesai', 'selesai', 'selesai', 'dikirim', 'dibayar', 'baru', 'batal']
        pesanan_data = []
        for i in range(1, 20001):
            id_user = random.randint(1, 5000)
            status = random.choice(status_choices)
            days_offset = random.randint(30, 720)
            seconds_offset = random.randint(0, 86400)
            tgl_pesan = base_date + timedelta(days=days_offset, seconds=seconds_offset)
            pesanan_data.append((id_user, status, tgl_pesan))

        sql_pesanan = "INSERT INTO pesanan (id_user, status, tanggal_pesan) VALUES (%s, %s, %s)"
        for offset in range(0, len(pesanan_data), 5000):
            cursor.executemany(sql_pesanan, pesanan_data[offset:offset+5000])
            conn.commit()
        print(f"  [OK] {len(pesanan_data):,} pesanan berhasil dimasukkan.")

        cursor.execute("SELECT id_produk, harga FROM produk")
        produk_price_map = {row[0]: row[1] for row in cursor.fetchall()}

        print("\n[5/5] Menyiapkan data tabel `detail_pesanan` (80.000 baris)...")
        detail_data = []
        for id_pesan in range(1, 20001):
            picked_products = random.sample(range(1, 1001), 4)
            for id_prod in picked_products:
                jumlah = random.randint(1, 5)
                harga_satuan = produk_price_map[id_prod]
                detail_data.append((id_pesan, id_prod, jumlah, harga_satuan))

        sql_detail = "INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan) VALUES (%s, %s, %s, %s)"
        for offset in range(0, len(detail_data), 10000):
            cursor.executemany(sql_detail, detail_data[offset:offset+10000])
            conn.commit()
        print(f"  [OK] {len(detail_data):,} detail pesanan berhasil dimasukkan.")

    except Exception as e:
        conn.rollback()
        print(f"\n[ERROR] Terjadi kesalahan: {e}")
        raise e
    finally:
        cursor.close()
        conn.close()

    elapsed = time.time() - start_total
    print("\n" + "=" * 60)
    print(f"[SUKSES] Seluruh 106.010 data dummy selesai di-generate dalam {elapsed:.2f} detik.")
    print("============================================================")

if __name__ == '__main__':
    generate_data()
