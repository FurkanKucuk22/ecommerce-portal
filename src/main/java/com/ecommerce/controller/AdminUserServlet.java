package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-user")
public class AdminUserServlet extends HttpServlet {
  private UserDAO userDAO;

  @Override
  public void init() throws ServletException {
    userDAO = new UserDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    if (session.getAttribute("adminUser") == null) {
      response.sendRedirect(request.getContextPath() + "/admin-login");
      return;
    }

    List<User> listUser = userDAO.getAllUsersForAdmin();
    request.setAttribute("listUser", listUser);
    request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
  }
}