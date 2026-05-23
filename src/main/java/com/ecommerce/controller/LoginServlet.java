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

    // Kullanıcının formda girdiği şifreyi hash'le (Çünkü DB'deki hali hashlenmiş
    // durumda)
    String hashedPassword = SecurityUtil.hashPassword(rawPassword);

    // UserDAO içindeki login metodunu çağırıyoruz (Artık hashlenmiş şifreyi
    // arıyoruz)
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