package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
  private OrderDAO orderDAO;

  @Override
  public void init() throws ServletException {
    orderDAO = new OrderDAO();
  }

  // GET Metodu: "Siparişlerim" (my-orders.jsp) sayfasını görüntülemek için
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    User loggedInUser = (User) session.getAttribute("loggedInUser");

    if (loggedInUser == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
    }

    // Giriş yapmış kullanıcının kendi ID'sine göre siparişleri çek
    List<Order> myOrders = orderDAO.getOrdersByUserId(loggedInUser.getId());
    request.setAttribute("myOrders", myOrders);
    request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
  }

  // POST Metodu: Sepeti onaylayıp "Sipariş Oluşturmak" için
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    User loggedInUser = (User) session.getAttribute("loggedInUser");

    if (loggedInUser == null) {
      request.setAttribute("errorMessage", "Siparişi tamamlamak için lütfen önce giriş yapın.");
      request.getRequestDispatcher("/login.jsp").forward(request, response);
      return;
    }

    @SuppressWarnings("unchecked")
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/cart.jsp");
      return;
    }

    double totalAmount = 0;
    for (CartItem item : cart) {
      totalAmount += item.getTotalPrice();
    }

    boolean isSuccess = orderDAO.placeOrder(loggedInUser, cart, totalAmount);

    if (isSuccess) {
      session.removeAttribute("cart");
      response.sendRedirect(request.getContextPath() + "/home?order=success");
    } else {
      request.setAttribute("errorMessage", "Sipariş oluşturulurken hata meydana geldi.");
      request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
  }
}