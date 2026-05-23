package com.ecommerce.dao;

import com.ecommerce.model.CartItem;
import com.ecommerce.model.User;
import com.ecommerce.model.Order;
import com.ecommerce.util.DBConnection;
import com.ecommerce.model.Product;
import com.ecommerce.model.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.ArrayList;

public class OrderDAO {

  public boolean placeOrder(User user, List<CartItem> cartItems, double totalAmount) {
    Connection conn = null;
    PreparedStatement pstmtOrder = null;
    PreparedStatement pstmtItem = null;
    PreparedStatement pstmtStock = null;
    ResultSet rs = null;

    try {
      conn = DBConnection.getConnection();
      // Otomatik kaydetmeyi kapatıyoruz (İşlem yarıda kesilirse geri alabilmek için)
      conn.setAutoCommit(false);

      // Siparişi 'orders' tablosuna ekle
      String orderSql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'Beklemede')";
      pstmtOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
      pstmtOrder.setInt(1, user.getId());
      pstmtOrder.setDouble(2, totalAmount);
      pstmtOrder.executeUpdate();

      // Eklenen siparişin ID'sini alıyoruz
      rs = pstmtOrder.getGeneratedKeys();
      int orderId = 0;
      if (rs.next()) {
        orderId = rs.getInt(1);
      }

      // Sepetteki her ürünü 'order_items' tablosuna ekle ve stoğunu düşür
      String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
      String stockSql = "UPDATE products SET stock = stock - ? WHERE id = ?";

      pstmtItem = conn.prepareStatement(itemSql);
      pstmtStock = conn.prepareStatement(stockSql);

      for (CartItem item : cartItems) {
        // Sipariş detayını ekle
        pstmtItem.setInt(1, orderId);
        pstmtItem.setInt(2, item.getProduct().getId());
        pstmtItem.setInt(3, item.getQuantity());
        pstmtItem.setDouble(4, item.getProduct().getPrice());
        pstmtItem.setDouble(5, item.getTotalPrice());
        pstmtItem.executeUpdate();

        // Ürün stoğunu düşür
        pstmtStock.setInt(1, item.getQuantity());
        pstmtStock.setInt(2, item.getProduct().getId());
        pstmtStock.executeUpdate();
      }

      // Her şey sorunsuz çalıştıysa işlemleri veritabanına kalıcı olarak kaydet
      conn.commit();
      return true;

    } catch (Exception e) {
      // Hata olursa hiçbir şeyi kaydetme, sistemi eski haline döndür
      if (conn != null) {
        try {
          conn.rollback();
        } catch (SQLException ex) {
          ex.printStackTrace();
        }
      }
      e.printStackTrace();
      return false;
    } finally {
      // Bağlantıları temizle
      try {
        if (rs != null)
          rs.close();
        if (pstmtOrder != null)
          pstmtOrder.close();
        if (pstmtItem != null)
          pstmtItem.close();
        if (pstmtStock != null)
          pstmtStock.close();
        if (conn != null) {
          conn.setAutoCommit(true);
          conn.close();
        }
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }

  // 2. KULLANICIYA GÖRE SİPARİŞLERİ GETİRME METODU
  public List<Order> getOrdersByUserId(int userId) {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";

    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setInt(1, userId);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          Order order = new Order();
          order.setId(rs.getInt("id"));
          order.setUserId(rs.getInt("user_id"));
          order.setOrderDate(rs.getTimestamp("order_date"));
          order.setTotalAmount(rs.getDouble("total_amount"));
          order.setStatus(rs.getString("status"));
          order.setItems(getOrderItems(order.getId()));

          orders.add(order);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return orders;
  }

  // SİPARİŞ DETAYLARINI (ÜRÜNLERİ) ÇEKEN YARDIMCI METOT
  public List<OrderItem> getOrderItems(int orderId) {
    List<OrderItem> items = new ArrayList<>();
    String sql = "SELECT oi.*, p.name AS product_name, p.image_url FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";

    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setInt(1, orderId);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          OrderItem item = new OrderItem();
          item.setId(rs.getInt("id"));
          item.setQuantity(rs.getInt("quantity"));
          item.setUnitPrice(rs.getDouble("unit_price"));
          item.setSubtotal(rs.getDouble("subtotal"));

          // Ürün bilgilerini modele ekle
          Product product = new Product();
          product.setName(rs.getString("product_name"));
          product.setImageUrl(rs.getString("image_url"));
          item.setProduct(product);

          items.add(item);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return items;
  }

  // ADMİN İÇİN TÜM SİPARİŞLERİ GETİR (Müşteri adıyla birlikte)
  public List<Order> getAllOrdersForAdmin() {
    List<Order> orders = new ArrayList<>();
    // Müşteri adını da göstermek için users tablosu ile JOIN yapıyoruz
    String sql = "SELECT o.*, u.full_name AS customer_name FROM orders o " +
        "JOIN users u ON o.user_id = u.id ORDER BY o.id DESC";

    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {

      while (rs.next()) {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setOrderDate(rs.getTimestamp("order_date"));

        orders.add(order);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return orders;
  }

  // SİPARİŞ DURUMUNU GÜNCELLE
  public boolean updateOrderStatus(int orderId, String newStatus) {
    String sql = "UPDATE orders SET status = ? WHERE id = ?";
    try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setString(1, newStatus);
      pstmt.setInt(2, orderId);

      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }
}
