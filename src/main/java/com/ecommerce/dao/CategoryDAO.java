package com.ecommerce.dao;

import com.ecommerce.model.Category;
import com.ecommerce.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

  public List<Category> getAllActiveCategories() {
    List<Category> categories = new ArrayList<>();
    String query = "SELECT * FROM categories WHERE is_active = true";

    try (Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery()) {

      while (rs.next()) {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setActive(rs.getBoolean("is_active"));
        categories.add(category);
      }
    } catch (SQLException e) {
      System.out.println("Kategoriler çekilirken hata: " + e.getMessage());
    }
    return categories;
  }

  // ADMİN İÇİN TÜM KATEGORİLERİ GETİR (Aktif/Pasif hepsi)
  public List<Category> getAllCategoriesForAdmin() {
    List<Category> categories = new ArrayList<>();
    String sql = "SELECT * FROM categories ORDER BY id DESC";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {
      while (rs.next()) {
        Category cat = new Category();
        cat.setId(rs.getInt("id"));
        cat.setName(rs.getString("name"));
        cat.setDescription(rs.getString("description"));
        cat.setActive(rs.getBoolean("is_active"));
        categories.add(cat);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return categories;
  }

  // KATEGORİ EKLE
  public boolean addCategory(Category category) {
    String sql = "INSERT INTO categories (name, description, is_active) VALUES (?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setString(1, category.getName());
      pstmt.setString(2, category.getDescription());
      pstmt.setBoolean(3, category.isActive());
      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }

  // ID'YE GÖRE KATEGORİ GETİR (Güncelleme formu için lazım olacak)
  public Category getCategoryById(int id) {
    Category category = null;
    String sql = "SELECT * FROM categories WHERE id = ?";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setInt(1, id);
      try (ResultSet rs = pstmt.executeQuery()) {
        if (rs.next()) {
          category = new Category();
          category.setId(rs.getInt("id"));
          category.setName(rs.getString("name"));
          category.setDescription(rs.getString("description"));
          category.setActive(rs.getBoolean("is_active"));
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return category;
  }

  // KATEGORİ GÜNCELLE
  public boolean updateCategory(Category category) {
    String sql = "UPDATE categories SET name=?, description=?, is_active=? WHERE id=?";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setString(1, category.getName());
      pstmt.setString(2, category.getDescription());
      pstmt.setBoolean(3, category.isActive());
      pstmt.setInt(4, category.getId());
      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }

  // KATEGORİ SİL VEYA PASİFE ÇEK
  public boolean deleteCategory(int id) {
    // Önce bu kategoriye bağlı ürün var mı diye kontrol edelim
    String checkSql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
    String updateSql = "UPDATE categories SET is_active = 0 WHERE id = ?";
    String deleteSql = "DELETE FROM categories WHERE id = ?";

    try (Connection conn = DBConnection.getConnection()) {
      boolean hasProducts = false;
      try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
        checkStmt.setInt(1, id);
        try (ResultSet rs = checkStmt.executeQuery()) {
          if (rs.next() && rs.getInt(1) > 0) {
            hasProducts = true;
          }
        }
      }

      // Eğer ürün varsa sadece pasife çek, yoksa komple sil
      String finalSql = hasProducts ? updateSql : deleteSql;
      try (PreparedStatement executeStmt = conn.prepareStatement(finalSql)) {
        executeStmt.setInt(1, id);
        return executeStmt.executeUpdate() > 0;
      }
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }
}