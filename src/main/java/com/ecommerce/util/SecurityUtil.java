package com.ecommerce.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SecurityUtil {

  // Şifreyi alır, SHA-256 ile hashler ve geri döndürür
  public static String hashPassword(String password) {
    try {
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] encodedhash = digest.digest(password.getBytes());
      return bytesToHex(encodedhash);
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException("SHA-256 algoritması bulunamadı!", e);
    }
  }

  // Byte dizisini okunabilir 64 karakterli Hexadecimal (16'lık taban) string'e
  // çeviren yardımcı metot
  private static String bytesToHex(byte[] hash) {
    StringBuilder hexString = new StringBuilder(2 * hash.length);
    for (int i = 0; i < hash.length; i++) {
      String hex = Integer.toHexString(0xff & hash[i]);
      if (hex.length() == 1) {
        hexString.append('0');
      }
      hexString.append(hex);
    }
    return hexString.toString();
  }
}