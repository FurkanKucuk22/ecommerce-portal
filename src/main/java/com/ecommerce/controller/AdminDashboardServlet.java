package com.ecommerce.controller;

import com.ecommerce.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    if (session.getAttribute("adminUser") == null) {
      response.sendRedirect(request.getContextPath() + "/admin-login");
      return;
    }

    DashboardDAO dashboardDAO = new DashboardDAO();
    Map<String, Integer> stats = dashboardDAO.getStatistics();

    request.setAttribute("stats", stats);
    request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
  }
}