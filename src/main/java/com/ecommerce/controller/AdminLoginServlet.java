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

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
  private UserDAO userDAO;

  @Override
  public void init() throws ServletException {
    userDAO = new UserDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();

    // --- ÇIKIŞ YAPMA (LOGOUT) İŞLEMİ ---
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
      session.removeAttribute("adminUser");
      session.invalidate();
      response.sendRedirect(request.getContextPath() + "/admin-login");
      return;
    }

    if (session.getAttribute("adminUser") != null) {
      response.sendRedirect(request.getContextPath() + "/admin-dashboard");
      return;
    }

    // Formun nereye post edileceğini JSP'ye bildirmek için ufak bir işaret
    // koyuyoruz
    request.setAttribute("postAction", "admin-login");

    // admin-login.jsp olmadığı için standart login.jsp sayfasına yönlendiriyoruz
    request.getRequestDispatcher("/login.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String email = request.getParameter("email");
    String rawPassword = request.getParameter("password");
    String hashedPassword = SecurityUtil.hashPassword(rawPassword);

    User user = userDAO.loginUser(email, hashedPassword);

    if (user != null && "ADMIN".equals(user.getRole())) {
      HttpSession session = request.getSession();
      session.setAttribute("adminUser", user);
      response.sendRedirect(request.getContextPath() + "/admin-dashboard");
    } else {
      request.setAttribute("errorMessage", "Hatalı e-posta/şifre veya bu alana giriş yetkiniz yok!");
      request.setAttribute("postAction", "admin-login");
      request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
  }
}