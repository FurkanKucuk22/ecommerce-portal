package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-order")
public class AdminOrderServlet extends HttpServlet {
  private OrderDAO orderDAO;

  @Override
  public void init() throws ServletException {
    orderDAO = new OrderDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // GÜVENLİK KONTROLÜ
    HttpSession session = request.getSession();
    if (session.getAttribute("adminUser") == null) {
      response.sendRedirect(request.getContextPath() + "/admin-login");
      return;
    }

    String action = request.getParameter("action");
    if (action == null) {
      action = "list";
    }

    // 2. İŞLEME GÖRE METOT ÇAĞIR
    if ("detail".equals(action)) {
      showOrderDetail(request, response);
    } else {
      listOrders(request, response);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    // GÜVENLİK KONTROLÜ
    HttpSession session = request.getSession();
    if (session.getAttribute("adminUser") == null) {
      response.sendRedirect(request.getContextPath() + "/admin-login");
      return;
    }

    String action = request.getParameter("action");

    // SİPARİŞ DURUMU GÜNCELLEME İŞLEMİ
    if ("updateStatus".equals(action)) {
      int orderId = Integer.parseInt(request.getParameter("orderId"));
      String newStatus = request.getParameter("status");

      orderDAO.updateOrderStatus(orderId, newStatus);

      // Güncelleme bitince tekrar sipariş listesine dön
      response.sendRedirect("admin-order");
    }
  }

  // --- YARDIMCI METOTLAR ---

  private void listOrders(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    List<Order> listOrder = orderDAO.getAllOrdersForAdmin();
    request.setAttribute("listOrder", listOrder);
    request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
  }

  private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    int orderId = Integer.parseInt(request.getParameter("id"));
    List<OrderItem> items = orderDAO.getOrderItems(orderId);
    request.setAttribute("items", items);
    request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
  }
}