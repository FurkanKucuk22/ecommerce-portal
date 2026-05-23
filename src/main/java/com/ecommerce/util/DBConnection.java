package com.ecommerce.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

  // Veritabanı bağlantı bilgileri
  private static final String URL = "jdbc:mysql://localhost:3306/ecommerce_db?useUnicode=true&characterEncoding=UTF-8";
  private static final String USERNAME = "root";
  private static final String PASSWORD = "";

  // Singleton pattern
  private static Connection connection = null;

  public static Connection getConnection() {
    try {
      if (connection == null || connection.isClosed()) {
        // MySQL Sürücüsünü yüklüyoruz
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Bağlantıyı kuruyoruz
        connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        System.out.println("Veritabanı bağlantısı BAŞARILI!");
      }
    } catch (ClassNotFoundException e) {
      System.out.println("MySQL Sürücüsü bulunamadı: " + e.getMessage());
    } catch (SQLException e) {
      System.out.println("Veritabanına bağlanırken hata oluştu: " + e.getMessage());
    }
    return connection;
  }
}
