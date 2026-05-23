package com.ecommerce.dao;

import com.ecommerce.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class DashboardDAO {

  public Map<String, Integer> getStatistics() {
    Map<String, Integer> stats = new HashMap<>();

    try (Connection conn = DBConnection.getConnection()) {
      stats.put("totalProducts", getCount(conn, "SELECT COUNT(*) FROM products"));
      stats.put("totalCategories", getCount(conn, "SELECT COUNT(*) FROM categories"));
      stats.put("totalUsers", getCount(conn, "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER'"));
      stats.put("totalOrders", getCount(conn, "SELECT COUNT(*) FROM orders"));
      stats.put("pendingOrders", getCount(conn, "SELECT COUNT(*) FROM orders WHERE status = 'Beklemede'"));
    } catch (SQLException e) {
      e.printStackTrace();
    }

    return stats;
  }

  private int getCount(Connection conn, String query) throws SQLException {
    try (PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery()) {
      if (rs.next()) {
        return rs.getInt(1);
      }
    }
    return 0;
  }
}