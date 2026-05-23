package com.ecommerce.dao;

import com.ecommerce.model.Product;
import com.ecommerce.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Aktif Tüm Ürünleri Listeleme (Ana Sayfa İçin)
    public List<Product> getAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE is_active = true";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                product.setCreatedAt(rs.getTimestamp("created_at"));

                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Ürün listesi çekilirken hata: " + e.getMessage());
        }
        return products;
    }

    // Kategoriye Göre Filtreleme
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category_id = ? AND is_active = true";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setCategoryId(rs.getInt("category_id"));
                    product.setName(rs.getString("name"));
                    product.setDescription(rs.getString("description"));
                    product.setPrice(rs.getDouble("price"));
                    product.setStock(rs.getInt("stock"));
                    product.setImageUrl(rs.getString("image_url"));
                    product.setActive(rs.getBoolean("is_active"));

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.out.println("Kategoriye göre ürün çekilirken hata: " + e.getMessage());
        }
        return products;
    }

    // ID'ye göre tek bir ürünü getiren metot
    public Product getProductById(int id) {
        Product product = null;
        String query = "SELECT * FROM products WHERE id = ?";

        try (java.sql.Connection conn = com.ecommerce.util.DBConnection.getConnection();
                java.sql.PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);
            java.sql.ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    // ADMİN İÇİN TÜM ÜRÜNLERİ KATEGORİ ADIYLA BİRLİKTE GETİR (Aktif/Pasif Hepsi)
    public List<Product> getAllProductsForAdmin() {
        List<Product> products = new ArrayList<>();

        String sql = "SELECT p.*, c.name AS category_name FROM products p " +
                "JOIN categories c ON p.category_id = c.id ORDER BY p.id DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setImageUrl(rs.getString("image_url"));
                p.setActive(rs.getBoolean("is_active"));
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // YENİ ÜRÜN EKLE
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, product.getCategoryId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getDescription());
            pstmt.setDouble(4, product.getPrice());
            pstmt.setInt(5, product.getStock());
            pstmt.setString(6, product.getImageUrl());
            pstmt.setBoolean(7, product.isActive());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ÜRÜN GÜNCELLE
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET category_id=?, name=?, description=?, price=?, stock=?, image_url=?, is_active=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, product.getCategoryId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getDescription());
            pstmt.setDouble(4, product.getPrice());
            pstmt.setInt(5, product.getStock());
            pstmt.setString(6, product.getImageUrl());
            pstmt.setBoolean(7, product.isActive());
            pstmt.setInt(8, product.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ÜRÜN SİL (Veya Aktifliğini Kapat)
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Ürün Arama Metodu (İsim veya açıklamada geçen kelimeyi arar)
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true AND (name LIKE ? OR description LIKE ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Kullanıcının girdiği kelimenin sağına ve soluna % işareti koyuyoruz (İçinde
            // geçenleri bulmak için)
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setActive(rs.getBoolean("is_active"));

                    products.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Toplam Aktif Ürün Sayısını Bulur (Sayfa sayısını hesaplamak için)
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(id) FROM products WHERE is_active = true";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Sadece İstenilen Sayfanın Ürünlerini Getirir (LIMIT ve OFFSET kullanır)
    public List<Product> getPaginatedProducts(int start, int total) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true LIMIT ?, ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, start);
            pstmt.setInt(2, total);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setActive(rs.getBoolean("is_active"));
                    products.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}