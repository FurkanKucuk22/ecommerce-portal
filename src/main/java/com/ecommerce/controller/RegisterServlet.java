package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
  private UserDAO userDAO;

  @Override
  public void init() throws ServletException {
    userDAO = new UserDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/register.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String rawPassword = request.getParameter("password"); // Kullanıcının girdiği düz şifre
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");

    // --- SUNUCU TARAFLI FORM DOĞRULAMA (SERVER-SIDE VALIDATION) ---
    if (fullName == null || fullName.trim().isEmpty() ||
        email == null || email.trim().isEmpty() ||
        rawPassword == null || rawPassword.trim().isEmpty()) {
      request.setAttribute("errorMessage", "Ad Soyad, E-Posta ve Şifre alanları boş bırakılamaz!");
      request.getRequestDispatcher("/register.jsp").forward(request, response);
      return;
    }

    // E-posta kontrolü
    if (userDAO.isEmailExists(email)) {
      request.setAttribute("errorMessage", "Bu e-posta adresi sistemde zaten kayıtlı!");
      request.getRequestDispatcher("/register.jsp").forward(request, response);
      return;
    }

    // ŞİFREYİ HASHLE (Veritabanına gitmeden önce)
    String hashedPassword = SecurityUtil.hashPassword(rawPassword);

    // Yeni kullanıcı nesnesini oluştururken artık hashlenmiş şifreyi
    // (hashedPassword) veriyoruz
    User newUser = new User(fullName, email, hashedPassword, phone, address, "CUSTOMER");

    // Kayıt işlemini gerçekleştir
    boolean isRegistered = userDAO.registerUser(newUser);

    if (isRegistered) {
      response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
    } else {
      request.setAttribute("errorMessage", "Kayıt işlemi sırasında bir hata oluştu. Lütfen tekrar deneyin.");
      request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
  }
}