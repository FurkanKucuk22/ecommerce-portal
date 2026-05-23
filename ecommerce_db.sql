-- 1. VERİTABANI OLUŞTURMA VE SEÇME
CREATE DATABASE IF NOT EXISTS ecommerce_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- Bağlantı karakter setini UTF-8 olarak zorluyoruz (Powershell veya dışarıdan okumalarda karakter bozulmasını engeller)
SET NAMES utf8mb4;

-- 2. TABLOLARI OLUŞTURMA (Eğer varsa önce siler ki çakışma olmasın)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Kullanıcılar Tablosu
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('ADMIN', 'CUSTOMER') DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kategoriler Tablosu
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Ürünler Tablosu
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Siparişler Tablosu
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('Beklemede', 'Hazirlaniyor', 'Kargoya Verildi', 'Teslim Edildi', 'Iptal Edildi') DEFAULT 'Beklemede',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Sipariş Detay Tablosu
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 3. ÖRNEK VERİLERİ (DUMMY DATA) EKLEME

-- KATEGORİLER
INSERT INTO categories (name, description, is_active) VALUES
('Telefon', 'En yeni akıllı telefonlar ve telefon aksesuarları', 1),
('Bilgisayar', 'Dizüstü, masaüstü bilgisayarlar ve donanımlar', 1),
('Aksesuar', 'Kulaklık, akıllı saat ve diğer teknolojik aksesuarlar', 1),
('Kitap & Hobi', 'Roman, bilim, eğitim kitapları ve hobi ürünleri', 1),
('Giyim', 'Erkek ve kadın modasına yön veren giyim ürünleri', 1);

-- KULLANICILAR (Şifrelerin hepsi "123456" değerinin hashlenmiş halidir)
INSERT INTO users (full_name, email, password, phone, address, role, created_at) VALUES
('Ahmet Yılmaz', 'admin@ecommerce.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '05551112233', 'İstanbul Merkez, Türkiye', 'ADMIN', NOW()),
('Elif Kaya', 'elif.kaya@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '05552223344', 'Ankara, Çankaya', 'CUSTOMER', NOW()),
('Mehmet Demir', 'm.demir88@hotmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '05329998877', 'İzmir, Karşıyaka', 'CUSTOMER', NOW()),
('Zeynep Çelik', 'zeynep.celik@yahoo.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '05447776655', 'Bursa, Nilüfer', 'CUSTOMER', NOW()),
('Caner Şahin', 'canersahin@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '05334445566', 'Antalya, Muratpaşa', 'CUSTOMER', NOW());

-- ÜRÜNLER (Gerçek ve kalıcı fotoğraf linkleri ile güncellendi)
INSERT INTO products (category_id, name, description, price, stock, image_url, is_active, created_at) VALUES
(1, 'Apple iPhone 15 Pro Max', '256 GB, Titanyum Kasa, A17 Pro İşlemci', 89999.99, 15, 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400', 1, NOW()),
(1, 'Samsung Galaxy S24 Ultra', '512 GB, Titanyum Çerçeve, Yapay Zeka Destekli', 74999.00, 20, 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400', 1, NOW()),
(1, 'Xiaomi Redmi Note 13 Pro', '12 GB RAM, 512 GB Hafıza, 200 MP Kamera', 18500.00, 50, 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400', 1, NOW()),
(2, 'Apple MacBook Pro M3', '14 inç, M3 Çip, 16 GB RAM, 512 GB SSD', 72500.00, 8, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400', 1, NOW()),
(2, 'Asus ROG Strix G16', 'Intel i7 13650HX, RTX 4060, 16GB RAM Oyuncu Bilgisayarı', 45000.00, 12, 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=400', 1, NOW()),
(3, 'Samsung Galaxy Buds3', 'Aktif gürültü engelleme, yüksek kaliteli ses, uzun pil ömrü', 3499.00, 45, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400', 1, NOW()),
(4, '1984 - George Orwell', 'Distopik bir başyapıt, Can Yayınları', 120.00, 150, 'https://i.dr.com.tr/cache/600x600-0/originals/0000000064038-1.jpg', 1, NOW()),
(5, 'Nike Air Force 1', 'Klasik beyaz spor ayakkabı, Günlük kullanım', 3800.00, 35, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400', 1, NOW());