package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
  private UserDAO userDAO;

  @Override
  public void init() throws ServletException {
    userDAO = new UserDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // --- ÇIKIŞ YAP (LOGOUT) İŞLEMİ KONTROLÜ ---
    String action = request.getParameter("action");

    if ("logout".equals(action)) {
      // Mevcut oturumu bul (yoksa yenisini oluşturma)
      HttpSession session = request.getSession(false);
      if (session != null) {
        // Oturumu sunucu belleğinden tamamen sil! (Kimlik kartını yak)
        session.invalidate();
      }
      // Çıkış yapıldıktan sonra temiz bir şekilde login sayfasına yönlendir
      response.sendRedirect(request.getContextPath() + "/login");
      return; // Metodun aşağıya devam etmesini engelle
    }

    // Eğer çıkış yapma işlemi değilse, normal login sayfasını göster
    request.getRequestDispatcher("/login.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    String email = request.getParameter("email");
    String rawPassword = request.getParameter("password");

    // --- SUNUCU TARAFLI FORM DOĞRULAMA (SERVER-SIDE VALIDATION) ---
    if (email == null || email.trim().isEmpty() || rawPassword == null || rawPassword.trim().isEmpty()) {
      request.setAttribute("errorMessage", "E-posta ve şifre alanları boş bırakılamaz!");
      request.getRequestDispatcher("/login.jsp").forward(request, response);
      return;
    }

    // Kullanıcının formda girdiği şifreyi hash'le
    String hashedPassword = SecurityUtil.hashPassword(rawPassword);

    // UserDAO içindeki login metodunu çağırıyoruz
    User user = userDAO.loginUser(email, hashedPassword);

    if (user != null) {
      HttpSession session = request.getSession();
      session.setAttribute("loggedInUser", user);
      response.sendRedirect(request.getContextPath() + "/home");
    } else {
      request.setAttribute("errorMessage", "E-posta adresi veya şifre hatalı!");
      request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
  }
}